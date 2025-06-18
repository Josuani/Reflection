# Documentación de la API

Este documento describe las APIs y servicios disponibles en el proyecto **Reflection**, incluyendo endpoints, modelos de datos y ejemplos de uso.

## 📋 Tabla de Contenidos

- [Visión General](#visión-general)
- [Autenticación](#autenticación)
- [Modelos de Datos](#modelos-de-datos)
- [Endpoints de Usuarios](#endpoints-de-usuarios)
- [Endpoints de Misiones](#endpoints-de-misiones)
- [Endpoints de Progreso](#endpoints-de-progreso)
- [Servicios Locales](#servicios-locales)
- [Ejemplos de Uso](#ejemplos-de-uso)
- [Códigos de Error](#códigos-de-error)

## 🔍 Visión General

La API de Reflection está construida sobre **Firebase** y utiliza **Firestore** como base de datos principal. Además, implementa un sistema de caché local con **Hive** para optimizar el rendimiento y permitir funcionalidad offline.

### Tecnologías Utilizadas

- **Firebase Firestore**: Base de datos NoSQL en la nube
- **Firebase Auth**: Autenticación de usuarios
- **Hive**: Base de datos local para caché
- **Streams**: Actualizaciones en tiempo real

### Estructura de Colecciones

```
firestore/
├── usuarios/           # Perfiles de usuarios
├── misiones/           # Definición de misiones
├── progreso/           # Progreso de usuarios
└── configuracion/      # Configuración global
```

## 🔐 Autenticación

### Métodos de Autenticación

1. **Email/Password**
2. **Google Sign-In**
3. **Apple Sign-In** (iOS)

### Flujo de Autenticación

```dart
// 1. Iniciar sesión
Future<UserCredential> signInWithEmailAndPassword(
  String email, 
  String password
);

// 2. Obtener usuario actual
User? user = FirebaseAuth.instance.currentUser;

// 3. Escuchar cambios de autenticación
FirebaseAuth.instance.authStateChanges().listen((User? user) {
  if (user == null) {
    // Usuario no autenticado
  } else {
    // Usuario autenticado
  }
});
```

### Tokens JWT

Los tokens JWT se manejan automáticamente por Firebase Auth y se renuevan automáticamente.

## 📊 Modelos de Datos

### 1. Usuario (UsersRecord)

```dart
class UsersRecord {
  final String? nombre;           // Nombre completo del usuario
  final String? email;            // Email del usuario
  final int? puntos;              // Puntos acumulados
  final int? nivel;               // Nivel actual
  final String? avatar;           // URL del avatar
  final DateTime? createdAt;      // Fecha de creación
  final DateTime? lastLogin;      // Último login
  final Map<String, dynamic>? preferences; // Preferencias del usuario
}
```

### 2. Misión (TasksRecord)

```dart
class TasksRecord {
  final String? titulo;           // Título de la misión
  final String? descripcion;      // Descripción detallada
  final String? categoria;        // Categoría (fuerza_fisica, mente_activa, etc.)
  final int? puntos;              // Puntos que otorga
  final String? status;           // Estado (disponible, en_progreso, completado)
  final String? usuarioId;        // ID del usuario propietario
  final DateTime? createdAt;      // Fecha de creación
  final DateTime? updatedAt;      // Fecha de última actualización
  final DateTime? completedAt;    // Fecha de completado
  final Map<String, dynamic>? metadata; // Metadatos adicionales
}
```

### 3. Progreso (ProgressRecord)

```dart
class ProgressRecord {
  final String? usuarioId;        // ID del usuario
  final String? misionId;         // ID de la misión
  final String? status;           // Estado del progreso
  final DateTime? startedAt;      // Fecha de inicio
  final DateTime? completedAt;    // Fecha de completado
  final int? puntosGanados;       // Puntos ganados
  final Map<String, dynamic>? logs; // Logs de actividad
}
```

### 4. Modelos Locales (Hive)

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
  @HiveField(1) final String tipo; // create, update, delete
  @HiveField(2) final Map<String, dynamic> datos;
  @HiveField(3) final DateTime timestamp;
}
```

## 👤 Endpoints de Usuarios

### Crear Usuario

```dart
// Método: POST
// Ruta: /usuarios
// Descripción: Crear un nuevo usuario

Future<void> createUsuario(Map<String, dynamic> data) async {
  await usuariosRef.add({
    ...data,
    'createdAt': FieldValue.serverTimestamp(),
    'puntos': 0,
    'nivel': 1,
  });
}

// Ejemplo de uso:
await createUsuario({
  'nombre': 'Juan Pérez',
  'email': 'juan@ejemplo.com',
  'avatar': 'https://ejemplo.com/avatar.jpg',
});
```

### Obtener Usuario

```dart
// Método: GET
// Ruta: /usuarios/{id}
// Descripción: Obtener datos de un usuario específico

Future<DocumentSnapshot> readUsuario(String id) async {
  return await usuariosRef.doc(id).get();
}

// Ejemplo de uso:
DocumentSnapshot doc = await readUsuario('user123');
Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
```

### Actualizar Usuario

```dart
// Método: PUT
// Ruta: /usuarios/{id}
// Descripción: Actualizar datos de un usuario

Future<void> updateUsuario(String id, Map<String, dynamic> data) async {
  await usuariosRef.doc(id).update({
    ...data,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// Ejemplo de uso:
await updateUsuario('user123', {
  'puntos': 150,
  'nivel': 2,
  'lastLogin': FieldValue.serverTimestamp(),
});
```

### Eliminar Usuario

```dart
// Método: DELETE
// Ruta: /usuarios/{id}
// Descripción: Eliminar un usuario

Future<void> deleteUsuario(String id) async {
  await usuariosRef.doc(id).delete();
}
```

### Stream de Usuario

```dart
// Método: STREAM
// Ruta: /usuarios/{id}
// Descripción: Escuchar cambios en tiempo real

Stream<DocumentSnapshot> userStream(String id) {
  return usuariosRef.doc(id).snapshots();
}

// Ejemplo de uso:
userStream('user123').listen((snapshot) {
  if (snapshot.exists) {
    Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;
    // Actualizar UI
  }
});
```

## 🎯 Endpoints de Misiones

### Crear Misión

```dart
// Método: POST
// Ruta: /misiones
// Descripción: Crear una nueva misión

Future<String> createMission(Map<String, dynamic> missionData) async {
  final docRef = await misionesRef.add({
    ...missionData,
    'status': 'disponible',
    'createdAt': FieldValue.serverTimestamp(),
  });
  return docRef.id;
}

// Ejemplo de uso:
String missionId = await createMission({
  'titulo': 'Hacer ejercicio',
  'descripcion': '30 minutos de cardio',
  'categoria': 'fuerza_fisica',
  'puntos': 50,
  'usuarioId': 'user123',
});
```

### Obtener Misiones

```dart
// Método: GET
// Ruta: /misiones
// Descripción: Obtener todas las misiones

Stream<List<Map<String, dynamic>>> getMissions() {
  return misionesRef
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              })
          .toList());
}
```

### Obtener Misiones por Estado

```dart
// Método: GET
// Ruta: /misiones?status={status}
// Descripción: Obtener misiones filtradas por estado

Stream<List<Map<String, dynamic>>> getMissionsByStatus(String status) {
  return misionesRef
      .where('status', isEqualTo: status)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              })
          .toList());
}

// Ejemplo de uso:
getMissionsByStatus('disponible').listen((missions) {
  // Actualizar lista de misiones disponibles
});
```

### Actualizar Estado de Misión

```dart
// Método: PUT
// Ruta: /misiones/{id}
// Descripción: Actualizar el estado de una misión

Future<void> updateMissionStatus(String missionId, String newStatus) async {
  await misionesRef.doc(missionId).update({
    'status': newStatus,
    'updatedAt': FieldValue.serverTimestamp(),
    if (newStatus == 'completado') 
      'completedAt': FieldValue.serverTimestamp(),
  });
}

// Ejemplo de uso:
await updateMissionStatus('mission123', 'en_progreso');
```

### Eliminar Misión

```dart
// Método: DELETE
// Ruta: /misiones/{id}
// Descripción: Eliminar una misión

Future<void> deleteMission(String missionId) async {
  await misionesRef.doc(missionId).delete();
}
```

### Obtener Misiones por Usuario

```dart
// Método: GET
// Ruta: /misiones?usuarioId={usuarioId}
// Descripción: Obtener misiones de un usuario específico

Stream<List<Map<String, dynamic>>> getMissionsByUser(String usuarioId) {
  return misionesRef
      .where('usuarioId', isEqualTo: usuarioId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) {
                final data = doc.data();
                data['id'] = doc.id;
                return data;
              })
          .toList());
}
```

## 📈 Endpoints de Progreso

### Crear Progreso

```dart
// Método: POST
// Ruta: /progreso
// Descripción: Crear un nuevo registro de progreso

Future<void> createProgreso(Map<String, dynamic> data) async {
  await progresoRef.add({
    ...data,
    'startedAt': FieldValue.serverTimestamp(),
  });
}

// Ejemplo de uso:
await createProgreso({
  'usuarioId': 'user123',
  'misionId': 'mission123',
  'status': 'en_progreso',
});
```

### Obtener Progreso de Usuario

```dart
// Método: GET
// Ruta: /progreso?usuarioId={usuarioId}
// Descripción: Obtener todo el progreso de un usuario

Future<QuerySnapshot> readProgreso(String usuarioId) async {
  return await progresoRef
      .where('usuarioId', isEqualTo: usuarioId)
      .get();
}
```

### Actualizar Progreso

```dart
// Método: PUT
// Ruta: /progreso/{id}
// Descripción: Actualizar un registro de progreso

Future<void> updateProgreso(String id, Map<String, dynamic> data) async {
  await progresoRef.doc(id).update({
    ...data,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// Ejemplo de uso:
await updateProgreso('progress123', {
  'status': 'completado',
  'puntosGanados': 50,
  'completedAt': FieldValue.serverTimestamp(),
});
```

## 💾 Servicios Locales

### DatabaseService

El `DatabaseService` proporciona una capa de abstracción para el acceso a datos tanto locales como remotos.

```dart
class DatabaseService {
  // Singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Referencias a Firestore
  final CollectionReference usuariosRef = FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference misionesRef = FirebaseFirestore.instance.collection('misiones');
  final CollectionReference progresoRef = FirebaseFirestore.instance.collection('progreso');

  // Boxes de Hive
  late Box<Mision> missionCacheBox;
  late Box<DraftChange> draftChangesBox;
  late Box<Setting> settingsBox;
  late Box<UIState> uiStateBox;

  // Inicialización
  Future<void> initialize() async {
    // Registrar adaptadores de Hive
    Hive.registerAdapter(MisionAdapter());
    Hive.registerAdapter(DraftChangeAdapter());
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(UIStateAdapter());

    // Abrir boxes
    missionCacheBox = await Hive.openBox<Mision>('cache_misiones');
    draftChangesBox = await Hive.openBox<DraftChange>('borradores_cambios');
    settingsBox = await Hive.openBox<Setting>('preferencias');
    uiStateBox = await Hive.openBox<UIState>('estado_ui');
  }

  // Sincronización de cambios pendientes
  Future<void> syncPendingChanges() async {
    final drafts = draftChangesBox.values.toList();
    for (var draft in drafts) {
      try {
        switch (draft.tipo) {
          case 'create':
            await _createFromDraft(draft);
            break;
          case 'update':
            await _updateFromDraft(draft);
            break;
          case 'delete':
            await _deleteFromDraft(draft);
            break;
        }
        await draftChangesBox.delete(draft.id);
      } catch (e) {
        print('Error syncing draft ${draft.id}: $e');
      }
    }
  }

  // Refrescar caché de misiones
  Future<void> refreshMissionsCache() async {
    try {
      final snapshot = await misionesRef.get();
      for (var doc in snapshot.docs) {
        final mision = Mision.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        await missionCacheBox.put(mision.id, mision);
      }
    } catch (e) {
      print('Error refreshing missions cache: $e');
    }
  }
}
```

### Operaciones de Caché

```dart
// Guardar misión en caché
Future<void> cacheMision(Mision m) => missionCacheBox.put(m.id, m);

// Obtener misión del caché
Mision? getCachedMision(String id) => missionCacheBox.get(id);

// Eliminar misión del caché
Future<void> removeCachedMision(String id) => missionCacheBox.delete(id);

// Guardar borrador
Future<void> saveDraft(DraftChange d) => draftChangesBox.put(d.id, d);

// Obtener borrador
DraftChange? getDraft(String id) => draftChangesBox.get(id);
```

## 💡 Ejemplos de Uso

### Ejemplo 1: Crear y Completar una Misión

```dart
// 1. Crear misión
String missionId = await createMission({
  'titulo': 'Leer 30 minutos',
  'descripcion': 'Leer un libro por 30 minutos',
  'categoria': 'mente_activa',
  'puntos': 30,
  'usuarioId': currentUserId,
});

// 2. Iniciar progreso
await createProgreso({
  'usuarioId': currentUserId,
  'misionId': missionId,
  'status': 'en_progreso',
});

// 3. Actualizar estado de misión
await updateMissionStatus(missionId, 'en_progreso');

// 4. Completar misión
await updateMissionStatus(missionId, 'completado');

// 5. Actualizar progreso
await updateProgreso(progressId, {
  'status': 'completado',
  'puntosGanados': 30,
  'completedAt': FieldValue.serverTimestamp(),
});

// 6. Actualizar puntos del usuario
await updateUsuario(currentUserId, {
  'puntos': FieldValue.increment(30),
});
```

### Ejemplo 2: Escuchar Cambios en Tiempo Real

```dart
class MissionListWidget extends StatefulWidget {
  @override
  _MissionListWidgetState createState() => _MissionListWidgetState();
}

class _MissionListWidgetState extends State<MissionListWidget> {
  List<Map<String, dynamic>> missions = [];
  StreamSubscription? _missionsSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToMissions();
  }

  void _subscribeToMissions() {
    _missionsSubscription = getMissionsByStatus('disponible').listen((missions) {
      setState(() {
        this.missions = missions;
      });
    });
  }

  @override
  void dispose() {
    _missionsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: missions.length,
      itemBuilder: (context, index) {
        final mission = missions[index];
        return ListTile(
          title: Text(mission['titulo']),
          subtitle: Text(mission['descripcion']),
          trailing: Text('${mission['puntos']} pts'),
        );
      },
    );
  }
}
```

### Ejemplo 3: Manejo Offline

```dart
class OfflineAwareService {
  final DatabaseService _db = DatabaseService();
  final Connectivity _connectivity = Connectivity();

  Future<void> createMissionOffline(Map<String, dynamic> missionData) async {
    // Crear borrador local
    final draft = DraftChange(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tipo: 'create',
      datos: missionData,
      timestamp: DateTime.now(),
    );

    await _db.saveDraft(draft);

    // Si hay conexión, sincronizar inmediatamente
    if (await _connectivity.checkConnectivity() != ConnectivityResult.none) {
      await _db.syncPendingChanges();
    }
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _db.syncPendingChanges();
      }
    });
  }
}
```

## ❌ Códigos de Error

### Errores de Firebase

```dart
// Errores comunes y sus soluciones
try {
  await createMission(missionData);
} on FirebaseException catch (e) {
  switch (e.code) {
    case 'permission-denied':
      // Usuario no tiene permisos
      print('Error: No tienes permisos para crear misiones');
      break;
    case 'unavailable':
      // Servicio no disponible
      print('Error: Servicio temporalmente no disponible');
      break;
    case 'invalid-argument':
      // Datos inválidos
      print('Error: Datos de misión inválidos');
      break;
    default:
      print('Error desconocido: ${e.message}');
  }
}
```

### Errores de Hive

```dart
try {
  await Hive.openBox<Mision>('cache_misiones');
} on HiveError catch (e) {
  print('Error de Hive: ${e.message}');
  // Recrear box si es necesario
  await Hive.deleteBoxFromDisk('cache_misiones');
  await Hive.openBox<Mision>('cache_misiones');
}
```

### Manejo de Errores Personalizado

```dart
class ApiException implements Exception {
  final String message;
  final String code;
  final dynamic details;

  ApiException(this.message, {this.code = 'UNKNOWN', this.details});

  @override
  String toString() => 'ApiException: $message (Code: $code)';
}

// Uso en servicios
Future<void> safeCreateMission(Map<String, dynamic> data) async {
  try {
    await createMission(data);
  } catch (e) {
    throw ApiException(
      'Error al crear misión',
      code: 'MISSION_CREATE_ERROR',
      details: e,
    );
  }
}
```

---

Esta documentación proporciona una guía completa para utilizar las APIs del proyecto **Reflection**. Para más detalles sobre implementación específica, consulta los archivos de código fuente. 