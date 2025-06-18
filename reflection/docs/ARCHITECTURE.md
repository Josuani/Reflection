# Arquitectura del Sistema

Este documento describe la arquitectura técnica del proyecto **Reflection**, incluyendo patrones de diseño, estructura de código y decisiones arquitectónicas.

## 📋 Tabla de Contenidos

- [Visión General](#visión-general)
- [Arquitectura de Capas](#arquitectura-de-capas)
- [Patrones de Diseño](#patrones-de-diseño)
- [Estructura de Directorios](#estructura-de-directorios)
- [Flujo de Datos](#flujo-de-datos)
- [Modelos de Datos](#modelos-de-datos)
- [Servicios](#servicios)
- [Estado de la Aplicación](#estado-de-la-aplicación)
- [Seguridad](#seguridad)
- [Rendimiento](#rendimiento)

## 🏗️ Visión General

Reflection utiliza una arquitectura de **3 capas** con separación clara de responsabilidades:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │   Pages     │  │ Components  │  │   Widgets   │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                   BUSINESS LOGIC LAYER                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Services   │  │  Providers  │  │   Models    │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     DATA LAYER                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │  Firebase   │  │    Hive     │  │   Cache     │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Arquitectura de Capas

### 1. Presentation Layer (Capa de Presentación)

**Responsabilidades:**
- Interfaz de usuario
- Navegación
- Gestión de eventos de usuario
- Renderizado de widgets

**Componentes:**
```dart
lib/
├── pages/                    # Páginas principales
│   ├── home/                 # Dashboard
│   ├── misiones2/            # Gestión de misiones
│   ├── profile/              # Perfil de usuario
│   └── configuracion/        # Configuración
├── components/               # Componentes reutilizables
│   ├── item_de_mision_widget.dart
│   ├── list_widget.dart
│   └── sidebar/
└── main_app_shell/           # Shell principal de la app
```

### 2. Business Logic Layer (Capa de Lógica de Negocio)

**Responsabilidades:**
- Lógica de aplicación
- Validaciones
- Transformación de datos
- Gestión de estado

**Componentes:**
```dart
lib/
├── services/                 # Servicios de aplicación
│   └── database_service.dart
├── backend/                  # Lógica de backend
│   ├── firebase/             # Servicios de Firebase
│   └── schema/               # Modelos de datos
└── auth/                     # Autenticación
```

### 3. Data Layer (Capa de Datos)

**Responsabilidades:**
- Persistencia de datos
- Sincronización
- Caché local
- Acceso a APIs externas

**Componentes:**
```dart
# Firebase (Remoto)
- Firestore Database
- Firebase Auth
- Firebase Storage

# Hive (Local)
- Cache de misiones
- Borradores de cambios
- Preferencias de usuario
- Estado de UI
```

## 🔄 Patrones de Diseño

### 1. Provider Pattern

**Propósito:** Gestión de estado global
**Implementación:** Usando `provider` package

```dart
// Ejemplo: AppStateNotifier
class AppStateNotifier extends ChangeNotifier {
  static AppStateNotifier _instance = AppStateNotifier._internal();
  factory AppStateNotifier() => _instance;
  AppStateNotifier._internal();

  BaseAuthUser? _user;
  BaseAuthUser? get user => _user;

  void update(BaseAuthUser? user) {
    _user = user;
    notifyListeners();
  }
}
```

### 2. Repository Pattern

**Propósito:** Abstracción del acceso a datos
**Implementación:** `DatabaseService`

```dart
class DatabaseService {
  // Firestore operations
  Future<void> createUsuario(Map<String, dynamic> data);
  Future<DocumentSnapshot> readUsuario(String id);
  Future<void> updateUsuario(String id, Map<String, dynamic> data);
  
  // Hive operations
  Future<void> cacheMision(Mision m);
  Mision? getCachedMision(String id);
}
```

### 3. Service Layer Pattern

**Propósito:** Encapsulación de lógica de negocio
**Implementación:** Servicios específicos por dominio

```dart
class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<List<Map<String, dynamic>>> getMissionsByStatus(String status);
  Future<String> createMission(Map<String, dynamic> missionData);
  Future<void> updateMissionStatus(String missionId, String newStatus);
}
```

### 4. Observer Pattern

**Propósito:** Reactividad y actualizaciones en tiempo real
**Implementación:** Streams de Firebase

```dart
// Suscripción a cambios en tiempo real
_missionService.getMissionsByStatus('disponible').listen((missions) {
  setState(() => _availableMissions = missions);
});
```

## 📁 Estructura de Directorios

```
lib/
├── main.dart                     # Punto de entrada
├── index.dart                    # Exportaciones principales
│
├── pages/                        # Páginas de la aplicación
│   ├── home/                     # Dashboard principal
│   │   ├── home_page_widget.dart
│   │   ├── home_page_model.dart
│   │   └── widgets/              # Widgets específicos de home
│   ├── misiones2/                # Gestión de misiones
│   │   ├── misiones2_widget.dart
│   │   └── misiones2_model.dart
│   ├── profile/                  # Perfil de usuario
│   ├── configuracion/            # Configuración
│   └── login_reflection/         # Autenticación
│
├── components/                   # Componentes reutilizables
│   ├── item_de_mision_widget.dart
│   ├── list_widget.dart
│   ├── slack_sidebar.dart
│   └── sidebar/
│
├── backend/                      # Lógica de backend
│   ├── backend.dart              # Configuración principal
│   ├── firebase/                 # Servicios de Firebase
│   │   ├── firebase_config.dart
│   │   └── mission_service.dart
│   └── schema/                   # Modelos de datos
│       ├── users_record.dart
│       ├── tasks_record.dart
│       └── util/
│
├── services/                     # Servicios de aplicación
│   ├── database_service.dart     # Servicio principal de datos
│   └── database_service.g.dart   # Código generado por Hive
│
├── auth/                         # Autenticación
│   ├── auth_manager.dart
│   ├── base_auth_user_provider.dart
│   └── firebase_auth/
│
├── flutter_flow/                 # Configuración de FlutterFlow
│   ├── flutter_flow_theme.dart
│   ├── flutter_flow_util.dart
│   └── nav/
│
├── main_app_shell/               # Shell principal
│   └── main_app_shell_widget.dart
│
├── modales/                      # Modales y diálogos
│   └── tarjetaobjetivo/
│
└── utils/                        # Utilidades
```

## 🔄 Flujo de Datos

### 1. Flujo de Creación de Misión

```
User Input → Page → Service → Repository → Firebase/Hive
     ↓
UI Update ← State ← Provider ← Service ← Repository
```

### 2. Flujo de Sincronización

```
Firebase Change → Stream → Service → Provider → UI Update
     ↓
Local Cache ← Hive ← Service ← Data Transformation
```

### 3. Flujo de Autenticación

```
Login → Auth Service → Firebase Auth → User Provider → App State
     ↓
Navigation ← Router ← Auth State ← User Data
```

## 📊 Modelos de Datos

### 1. Modelos de Hive (Local)

```dart
@HiveType(typeId: 0)
class Mision extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String titulo;
  @HiveField(2) final String descripcion;
  @HiveField(3) final int puntos;
}

@HiveType(typeId: 1)
class DraftChange extends HiveObject {
  @HiveField(0) final String id;
  @HiveField(1) final String tipo;
  @HiveField(2) final Map<String, dynamic> datos;
  @HiveField(3) final DateTime timestamp;
}
```

### 2. Modelos de Firestore (Remoto)

```dart
class UsersRecord {
  final String? nombre;
  final String? email;
  final int? puntos;
  final int? nivel;
  final String? avatar;
  final DateTime? createdAt;
}

class TasksRecord {
  final String? titulo;
  final String? descripcion;
  final String? categoria;
  final int? puntos;
  final String? status;
  final String? usuarioId;
}
```

### 3. Relaciones de Datos

```
Usuario (1) ←→ (N) Misiones
Usuario (1) ←→ (N) Progreso
Mision (1) ←→ (N) Progreso
```

## 🔧 Servicios

### 1. DatabaseService

**Responsabilidades:**
- Gestión de datos remotos (Firestore)
- Gestión de datos locales (Hive)
- Sincronización offline/online
- CRUD operations

```dart
class DatabaseService {
  // Firestore collections
  final CollectionReference usuariosRef;
  final CollectionReference misionesRef;
  final CollectionReference progresoRef;
  
  // Hive boxes
  late Box<Mision> missionCacheBox;
  late Box<DraftChange> draftChangesBox;
  
  // Operations
  Future<void> syncPendingChanges();
  Future<void> refreshMissionsCache();
}
```

### 2. MissionService

**Responsabilidades:**
- Operaciones específicas de misiones
- Gestión de estados
- Validaciones de negocio

```dart
class MissionService {
  Stream<List<Map<String, dynamic>>> getMissionsByStatus(String status);
  Future<String> createMission(Map<String, dynamic> missionData);
  Future<void> updateMissionStatus(String missionId, String newStatus);
  Future<void> deleteMission(String missionId);
}
```

### 3. AuthManager

**Responsabilidades:**
- Gestión de autenticación
- Manejo de sesiones
- Validación de permisos

## 🎛️ Estado de la Aplicación

### 1. Estado Global

```dart
class AppState {
  BaseAuthUser? currentUser;
  bool isLoading;
  String currentRoute;
  Map<String, dynamic> userPreferences;
}
```

### 2. Estado Local (por página)

```dart
class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> quickActions = [];
  bool isRefreshing = false;
}
```

### 3. Gestión de Estado

- **Provider**: Para estado global
- **setState**: Para estado local de widgets
- **Streams**: Para datos reactivos de Firebase

## 🔒 Seguridad

### 1. Autenticación

- Firebase Authentication
- Google Sign-In
- Apple Sign-In (iOS)
- JWT tokens

### 2. Autorización

```javascript
// Firestore Rules
match /usuarios/{userId} {
  allow read, write: if request.auth != null && 
    request.auth.uid == userId;
}

match /misiones/{missionId} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && 
    request.auth.uid == resource.data.usuarioId;
}
```

### 3. Validación de Datos

- Validación en cliente (Dart)
- Validación en servidor (Firestore Rules)
- Sanitización de inputs

## ⚡ Rendimiento

### 1. Optimizaciones de Red

- **Caché local**: Hive para datos frecuentemente accedidos
- **Paginación**: Carga incremental de datos
- **Compresión**: Datos comprimidos en tránsito

### 2. Optimizaciones de UI

- **Widgets const**: Para widgets inmutables
- **ListView.builder**: Para listas largas
- **CachedNetworkImage**: Para imágenes

### 3. Optimizaciones de Memoria

- **Dispose**: Limpieza de recursos
- **Stream subscriptions**: Cancelación apropiada
- **Weak references**: Para evitar memory leaks

### 4. Estrategias de Caché

```dart
// Caché de misiones
Future<void> cacheMision(Mision m) => missionCacheBox.put(m.id, m);
Mision? getCachedMision(String id) => missionCacheBox.get(id);

// Caché de imágenes
CachedNetworkImage(
  imageUrl: imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

## 🔄 Ciclo de Vida de la Aplicación

### 1. Inicialización

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MisionAdapter());
  
  // Inicializar Firebase
  await initFirebase();
  
  // Ejecutar app
  runApp(MyApp());
}
```

### 2. Gestión de Estado

```dart
class _MyAppState extends State<MyApp> {
  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  
  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }
}
```

### 3. Limpieza

```dart
@override
void dispose() {
  authUserSub.cancel();
  super.dispose();
}
```

## 📈 Escalabilidad

### 1. Arquitectura Modular

- Separación clara de responsabilidades
- Componentes reutilizables
- Servicios independientes

### 2. Base de Datos

- Firestore: Escalabilidad automática
- Índices optimizados
- Reglas de seguridad granulares

### 3. Código

- Patrones de diseño escalables
- Tests unitarios
- Documentación mantenida

---

Esta arquitectura proporciona una base sólida para el crecimiento y mantenimiento del proyecto **Reflection**. 