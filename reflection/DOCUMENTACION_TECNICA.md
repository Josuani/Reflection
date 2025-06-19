# Documentación Técnica - Reflection

## 🏗️ Arquitectura del Sistema

### Patrón de Arquitectura
La aplicación sigue un patrón **MVVM (Model-View-ViewModel)** con elementos de **Clean Architecture**:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Pages     │  │ Components  │  │   Modals    │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    DOMAIN LAYER                             │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Models    │  │  Services   │  │   Utils     │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                   DATA LAYER                                │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │  Firebase   │  │    Hive     │  │ SharedPrefs │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

### Flujo de Datos
1. **UI** → **Service Layer** → **Repository** → **Data Sources**
2. **Data Sources** → **Repository** → **Service Layer** → **UI**
3. **Offline Sync**: Cambios locales se sincronizan automáticamente

## 🔐 Sistema de Autenticación

### Implementación Firebase Auth
```dart
// auth/firebase_auth/firebase_user_provider.dart
class FirebaseUserProvider extends BaseAuthUserProvider {
  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user != null
          ? FirebaseUser(userCredential.user!)
          : null;
    } catch (e) {
      // Manejo de errores
    }
  }
}
```

### Estados de Autenticación
- **Unauthenticated**: Usuario no autenticado
- **Authenticating**: Proceso de autenticación en curso
- **Authenticated**: Usuario autenticado exitosamente
- **Error**: Error en el proceso de autenticación

### Métodos de Autenticación Soportados
1. **Email/Password**
2. **Google Sign-In**
3. **Apple Sign-In**
4. **Anonymous Auth**

## 💾 Gestión de Datos

### DatabaseService - Patrón Singleton
```dart
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();
  
  // Firestore Collections
  final CollectionReference usuariosRef = FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference misionesRef = FirebaseFirestore.instance.collection('misiones');
  final CollectionReference progresoRef = FirebaseFirestore.instance.collection('progreso');
}
```

### Estructura de Firestore

#### Colección: usuarios
```json
{
  "id": "user_123",
  "email": "usuario@ejemplo.com",
  "displayName": "Juan Pérez",
  "photoURL": "https://...",
  "nivel": 5,
  "puntos": 1250,
  "fechaCreacion": "2024-01-01T00:00:00Z",
  "ultimaActividad": "2024-01-15T10:30:00Z",
  "configuracion": {
    "tema": "dark",
    "idioma": "es",
    "notificaciones": true
  }
}
```

#### Colección: misiones
```json
{
  "id": "mision_456",
  "titulo": "Ejercicio matutino",
  "descripcion": "Completa 30 minutos de ejercicio",
  "categoria": "fuerza_fisica",
  "puntos": 100,
  "dificultad": "facil",
  "duracion": "30min",
  "requisitos": ["nivel_3"],
  "recompensas": {
    "xp": 100,
    "badges": ["ejercicio_matutino"]
  },
  "activa": true,
  "fechaCreacion": "2024-01-01T00:00:00Z"
}
```

#### Colección: progreso
```json
{
  "id": "progreso_789",
  "usuarioId": "user_123",
  "misionId": "mision_456",
  "estado": "completada",
  "fechaInicio": "2024-01-15T06:00:00Z",
  "fechaCompletado": "2024-01-15T06:30:00Z",
  "puntosObtenidos": 100,
  "evidencia": "url_imagen_o_texto"
}
```

### Almacenamiento Local con Hive

#### Boxes Configurados
1. **cache_misiones**: Caché de misiones para funcionamiento offline
2. **borradores_cambios**: Cambios pendientes de sincronización
3. **preferencias**: Configuración del usuario
4. **estado_ui**: Estado de la interfaz de usuario

#### Sincronización Offline
```dart
Future<void> syncPendingChanges() async {
  final drafts = draftChangesBox.values.toList();
  for (var draft in drafts) {
    switch (draft.tipo) {
      case 'create':
        await misionesRef.add(draft.datos);
        break;
      case 'update':
        await misionesRef.doc(draft.id).update(draft.datos);
        break;
      case 'delete':
        await misionesRef.doc(draft.id).delete();
        break;
    }
    await draftChangesBox.delete(draft.id);
  }
}
```

## 🎨 Sistema de UI/UX

### FlutterFlow Theme
```dart
class FlutterFlowTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    // Configuración personalizada
  );
  
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    // Configuración personalizada
  );
}
```

### Componentes Reutilizables

#### ItemDeMisionWidget
```dart
class ItemDeMisionWidget extends StatelessWidget {
  final Mision mision;
  final VoidCallback? onTap;
  final bool isCompleted;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: _buildCategoryIcon(mision.categoria),
        title: Text(mision.titulo),
        subtitle: Text(mision.descripcion),
        trailing: _buildPointsBadge(mision.puntos),
        onTap: onTap,
      ),
    );
  }
}
```

### Navegación con GoRouter
```dart
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomePageWidget(),
    ),
    GoRoute(
      path: '/misiones',
      builder: (context, state) => MisionesPageWidget(),
    ),
    GoRoute(
      path: '/perfil',
      builder: (context, state) => ProfilePageWidget(),
    ),
  ],
);
```

## 🔄 Gestión de Estado

### Provider Pattern
```dart
class AppStateNotifier extends ChangeNotifier {
  static final AppStateNotifier _instance = AppStateNotifier._internal();
  factory AppStateNotifier() => _instance;
  AppStateNotifier._internal();

  BaseAuthUser? _user;
  bool _isLoading = true;

  BaseAuthUser? get user => _user;
  bool get isLoading => _isLoading;

  void update(BaseAuthUser? user) {
    _user = user;
    _isLoading = false;
    notifyListeners();
  }
}
```

### Streams para Datos en Tiempo Real
```dart
// Stream de usuario autenticado
Stream<BaseAuthUser> userStream = FirebaseAuth.instance.authStateChanges()
    .map((user) => user != null ? FirebaseUser(user) : null);

// Stream de misiones
Stream<List<Mision>> misionesStream = FirebaseFirestore.instance
    .collection('misiones')
    .where('activa', isEqualTo: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => Mision.fromMap(doc.id, doc.data()))
        .toList());
```

## 🚀 Optimizaciones de Rendimiento

### Lazy Loading
```dart
class LazyMisionesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('misiones')
          .limit(10) // Carga inicial limitada
          .snapshots(),
      builder: (context, snapshot) {
        // Implementación con paginación
      },
    );
  }
}
```

### Caché de Imágenes
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 300, // Optimización de memoria
  memCacheHeight: 300,
)
```

### Debouncing para Búsquedas
```dart
class SearchController {
  Timer? _debounce;
  
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      // Ejecutar búsqueda
      performSearch(query);
    });
  }
}
```

## 🔒 Seguridad

### Reglas de Firestore
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios solo pueden leer/escribir sus propios datos
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Misiones son de solo lectura para usuarios autenticados
    match /misiones/{misionId} {
      allow read: if request.auth != null;
      allow write: if false; // Solo admin puede modificar
    }
    
    // Progreso solo puede ser modificado por el usuario propietario
    match /progreso/{progresoId} {
      allow read, write: if request.auth != null && 
        resource.data.usuarioId == request.auth.uid;
    }
  }
}
```

### Validación de Datos
```dart
class MisionValidator {
  static String? validateTitulo(String? titulo) {
    if (titulo == null || titulo.isEmpty) {
      return 'El título es requerido';
    }
    if (titulo.length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }
    if (titulo.length > 100) {
      return 'El título no puede exceder 100 caracteres';
    }
    return null;
  }
  
  static String? validatePuntos(int? puntos) {
    if (puntos == null || puntos < 0) {
      return 'Los puntos deben ser un número positivo';
    }
    if (puntos > 1000) {
      return 'Los puntos no pueden exceder 1000';
    }
    return null;
  }
}
```

## 🧪 Testing

### Tests Unitarios
```dart
void main() {
  group('Mision Tests', () {
    test('should create mision from map', () {
      final map = {
        'titulo': 'Test Mission',
        'descripcion': 'Test Description',
        'puntos': 100,
      };
      
      final mision = Mision.fromMap('test_id', map);
      
      expect(mision.id, equals('test_id'));
      expect(mision.titulo, equals('Test Mission'));
      expect(mision.puntos, equals(100));
    });
  });
}
```

### Tests de Widgets
```dart
testWidgets('ItemDeMisionWidget displays correctly', (WidgetTester tester) async {
  final mision = Mision(
    id: 'test_id',
    titulo: 'Test Mission',
    descripcion: 'Test Description',
    puntos: 100,
  );
  
  await tester.pumpWidget(
    MaterialApp(
      home: ItemDeMisionWidget(mision: mision),
    ),
  );
  
  expect(find.text('Test Mission'), findsOneWidget);
  expect(find.text('Test Description'), findsOneWidget);
  expect(find.text('100'), findsOneWidget);
});
```

## 📊 Monitoreo y Logging

### Firebase Performance
```dart
class PerformanceService {
  static void startTrace(String traceName) {
    FirebasePerformance.instance.newTrace(traceName).start();
  }
  
  static void endTrace(String traceName) {
    FirebasePerformance.instance.newTrace(traceName).stop();
  }
  
  static void addMetric(String traceName, String metricName, int value) {
    FirebasePerformance.instance
        .newTrace(traceName)
        .setMetric(metricName, value);
  }
}
```

### Logging Estructurado
```dart
class Logger {
  static void info(String message, {Map<String, dynamic>? data}) {
    print('INFO: $message ${data != null ? jsonEncode(data) : ''}');
  }
  
  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    print('ERROR: $message');
    if (error != null) print('Error: $error');
    if (stackTrace != null) print('StackTrace: $stackTrace');
  }
  
  static void debug(String message, {Map<String, dynamic>? data}) {
    if (kDebugMode) {
      print('DEBUG: $message ${data != null ? jsonEncode(data) : ''}');
    }
  }
}
```

## 🔧 Configuración de Desarrollo

### Variables de Entorno
```dart
class Environment {
  static const String firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const String firebaseProjectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const bool isProduction = bool.fromEnvironment('IS_PRODUCTION', defaultValue: false);
}
```

### Configuración de Build
```yaml
# pubspec.yaml
flutter:
  build:
    target-platform: android-arm64,android-arm,ios
    dart-define:
      FIREBASE_API_KEY: "your_api_key"
      FIREBASE_PROJECT_ID: "your_project_id"
      IS_PRODUCTION: "false"
```

## 📱 Configuración de Plataformas

### Android
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest>
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
  
  <application>
    <meta-data
      android:name="com.google.firebase.messaging.default_notification_icon"
      android:resource="@drawable/ic_notification" />
  </application>
</manifest>
```

### iOS
```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>com.example.reflection</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>reflection</string>
    </array>
  </dict>
</array>
```

---

Esta documentación técnica proporciona una visión completa de la arquitectura y implementación del proyecto Reflection. Para más detalles específicos, consulta los archivos de código fuente correspondientes. 