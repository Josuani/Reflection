# Guía de Despliegue

Esta guía te ayudará a desplegar la aplicación **Reflection** en diferentes plataformas y configurar el entorno de producción.

## 📋 Tabla de Contenidos

- [Configuración de Firebase](#configuración-de-firebase)
- [Configuración de Entorno](#configuración-de-entorno)
- [Build de Producción](#build-de-producción)
- [Despliegue en Android](#despliegue-en-android)
- [Despliegue en iOS](#despliegue-en-ios)
- [Despliegue Web](#despliegue-web)
- [Configuración de CI/CD](#configuración-de-cicd)
- [Monitoreo y Analytics](#monitoreo-y-analytics)
- [Seguridad](#seguridad)
- [Optimización](#optimización)

## 🔥 Configuración de Firebase

### 1. Configuración de Producción

#### Crear Proyecto de Producción

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Crear nuevo proyecto: `reflection-prod`
3. Habilitar Google Analytics (recomendado)

#### Configurar Authentication

```bash
# Habilitar proveedores de autenticación
- Email/Password ✅
- Google Sign-In ✅
- Apple Sign-In ✅ (solo iOS)
```

#### Configurar Firestore

```javascript
// firebase/firestore.rules (Producción)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios: solo propietario puede leer/escribir
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId;
    }
    
    // Misiones: lectura pública, escritura solo propietario
    match /misiones/{missionId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.usuarioId;
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.usuarioId;
    }
    
    // Progreso: solo propietario
    match /progreso/{progressId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.usuarioId;
    }
    
    // Configuración: solo lectura
    match /configuracion/{docId} {
      allow read: if request.auth != null;
      allow write: if false; // Solo admins pueden escribir
    }
  }
}
```

#### Configurar Storage

```javascript
// firebase/storage.rules (Producción)
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Avatares de usuario
    match /usuarios/{userId}/avatar/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == userId;
    }
    
    // Imágenes de misiones
    match /misiones/{missionId}/images/{fileName} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.metadata.usuarioId;
    }
  }
}
```

#### Configurar Índices

```json
// firebase/firestore.indexes.json
{
  "indexes": [
    {
      "collectionGroup": "misiones",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "usuarioId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "status",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "createdAt",
          "order": "DESCENDING"
        }
      ]
    },
    {
      "collectionGroup": "progreso",
      "queryScope": "COLLECTION",
      "fields": [
        {
          "fieldPath": "usuarioId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "misionId",
          "order": "ASCENDING"
        },
        {
          "fieldPath": "completedAt",
          "order": "DESCENDING"
        }
      ]
    }
  ]
}
```

### 2. Configuración de Variables de Entorno

#### Archivo de Configuración de Producción

```dart
// lib/config/production_config.dart
class ProductionConfig {
  static const String firebaseProjectId = 'reflection-prod';
  static const String firebaseApiKey = 'tu-api-key-produccion';
  static const String firebaseAppId = 'tu-app-id-produccion';
  
  // Configuración de la aplicación
  static const String appName = 'Reflection';
  static const String appVersion = '1.0.0';
  static const bool debugMode = false;
  
  // Configuración de analytics
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  
  // Configuración de caché
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiration = Duration(days: 7);
}
```

## ⚙️ Configuración de Entorno

### 1. Variables de Entorno

```bash
# .env.production
FIREBASE_PROJECT_ID=reflection-prod
FIREBASE_API_KEY=tu-api-key-produccion
FIREBASE_APP_ID=tu-app-id-produccion
FIREBASE_MESSAGING_SENDER_ID=tu-sender-id
FIREBASE_STORAGE_BUCKET=reflection-prod.appspot.com

# App Configuration
APP_NAME=Reflection
APP_VERSION=1.0.0
DEBUG_MODE=false
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true

# Cache Configuration
MAX_CACHE_SIZE=104857600
CACHE_EXPIRATION_DAYS=7
```

### 2. Configuración de Build

#### Android

```gradle
// android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.tuempresa.reflection"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        
        // Configuración de Firebase
        manifestPlaceholders = [
            firebaseProjectId: project.findProperty('FIREBASE_PROJECT_ID') ?: 'reflection-prod'
        ]
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    // Firebase
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-crashlytics'
    implementation 'com.google.firebase:firebase-performance'
}
```

#### iOS

```xml
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Reflection</string>
<key>CFBundleIdentifier</key>
<string>com.tuempresa.reflection</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>

<!-- Configuración de Firebase -->
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
<key>FirebaseAutomaticScreenReportingEnabled</key>
<false/>
```

## 🏗️ Build de Producción

### 1. Optimización de Código

```dart
// lib/main.dart (Producción)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configuración de producción
  if (kReleaseMode) {
    // Habilitar Crashlytics
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    
    // Configurar Analytics
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    
    // Configurar Performance
    await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  }
  
  // Inicializar Hive con configuración de producción
  await Hive.initFlutter();
  Hive.registerAdapter(MisionAdapter());
  Hive.registerAdapter(DraftChangeAdapter());
  Hive.registerAdapter(SettingAdapter());
  Hive.registerAdapter(UIStateAdapter());
  
  // Abrir boxes con configuración optimizada
  await Hive.openBox<Mision>('cache_misiones');
  await Hive.openBox<DraftChange>('borradores_cambios');
  await Hive.openBox<Setting>('preferencias');
  await Hive.openBox<UIState>('estado_ui');
  
  // Inicializar Firebase
  await initFirebase();
  
  // Ejecutar app
  runApp(MyApp());
}
```

### 2. Comandos de Build

```bash
# Limpiar build anterior
flutter clean

# Obtener dependencias
flutter pub get

# Build para Android (APK)
flutter build apk --release

# Build para Android (App Bundle)
flutter build appbundle --release

# Build para iOS
flutter build ios --release

# Build para Web
flutter build web --release
```

### 3. Optimizaciones de Build

#### Android

```gradle
// android/app/proguard-rules.pro
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Hive
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }
```

#### iOS

```swift
// ios/Runner/AppDelegate.swift
import UIKit
import Flutter
import Firebase
import FirebaseCrashlytics

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    
    // Configurar Crashlytics
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

## 📱 Despliegue en Android

### 1. Configuración de Firma

```bash
# Generar keystore
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload

# Configurar key.properties
# android/key.properties
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the keystore file, e.g., /Users/<user name>/upload-keystore.jks>
```

### 2. Configuración de Build

```gradle
// android/app/build.gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. Subir a Google Play Store

```bash
# Build App Bundle
flutter build appbundle --release

# Subir a Google Play Console
# 1. Ir a Google Play Console
# 2. Crear nueva release
# 3. Subir app-bundle-release.aab
# 4. Configurar descripción, capturas, etc.
# 5. Publicar
```

## 🍎 Despliegue en iOS

### 1. Configuración de Certificados

```bash
# 1. Crear certificado de distribución en Apple Developer
# 2. Crear perfil de aprovisionamiento
# 3. Configurar en Xcode
```

### 2. Configuración de Xcode

```swift
// ios/Runner.xcodeproj/project.pbxproj
// Configurar:
// - Bundle Identifier
// - Team ID
// - Provisioning Profile
// - Code Signing Identity
```

### 3. Subir a App Store

```bash
# Build para iOS
flutter build ios --release

# Abrir en Xcode
open ios/Runner.xcworkspace

# En Xcode:
# 1. Product > Archive
# 2. Distribute App
# 3. App Store Connect
# 4. Upload
```

## 🌐 Despliegue Web

### 1. Configuración de Firebase Hosting

```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Inicializar proyecto
firebase init hosting

# Configurar:
# - Public directory: build/web
# - Single-page app: Yes
# - Overwrite index.html: No
```

### 2. Configuración de Hosting

```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  }
}
```

### 3. Desplegar

```bash
# Build para web
flutter build web --release

# Desplegar a Firebase Hosting
firebase deploy --only hosting
```

## 🔄 Configuración de CI/CD

### 1. GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.0.0'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Analyze project source
      run: flutter analyze
    
    - name: Run tests
      run: flutter test
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk

  deploy-android:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.0.0'
    
    - name: Setup Java
      uses: actions/setup-java@v3
      with:
        distribution: 'zulu'
        java-version: '11'
    
    - name: Decode Keystore
      run: |
        echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/keystore.jks
    
    - name: Build App Bundle
      run: flutter build appbundle --release
      env:
        KEYSTORE_PASSWORD: ${{ secrets.KEYSTORE_PASSWORD }}
        KEY_PASSWORD: ${{ secrets.KEY_PASSWORD }}
        KEY_ALIAS: ${{ secrets.KEY_ALIAS }}
    
    - name: Upload to Play Store
      uses: r0adkll/upload-google-play@v1
      with:
        serviceAccountJsonPlainText: ${{ secrets.SERVICE_ACCOUNT_JSON }}
        packageName: com.tuempresa.reflection
        releaseFiles: build/app/outputs/bundle/release/app-release.aab
        track: internal
```

### 2. Firebase App Distribution

```yaml
# .github/workflows/firebase-distribution.yml
name: Firebase App Distribution

on:
  push:
    branches: [ develop ]

jobs:
  distribute:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.0.0'
    
    - name: Build APK
      run: flutter build apk --release
    
    - name: Upload to Firebase App Distribution
      uses: wzieba/Firebase-Distribution-Github-Action@v1
      with:
        appId: ${{ secrets.FIREBASE_APP_ID }}
        serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
        groups: testers
        file: build/app/outputs/flutter-apk/app-release.apk
        releaseNotes: ${{ github.event.head_commit.message }}
```

## 📊 Monitoreo y Analytics

### 1. Firebase Analytics

```dart
// lib/services/analytics_service.dart
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  
  // Eventos personalizados
  static Future<void> logMissionCreated(String category, int points) async {
    await _analytics.logEvent(
      name: 'mission_created',
      parameters: {
        'category': category,
        'points': points,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  static Future<void> logMissionCompleted(String missionId, int pointsEarned) async {
    await _analytics.logEvent(
      name: 'mission_completed',
      parameters: {
        'mission_id': missionId,
        'points_earned': pointsEarned,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
  
  static Future<void> logUserLevelUp(int newLevel) async {
    await _analytics.logEvent(
      name: 'level_up',
      parameters: {
        'new_level': newLevel,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

### 2. Firebase Crashlytics

```dart
// lib/services/crashlytics_service.dart
class CrashlyticsService {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  static Future<void> logError(String message, dynamic error, StackTrace? stackTrace) async {
    await _crashlytics.recordError(
      error,
      stackTrace,
      reason: message,
    );
  }
  
  static Future<void> setUserIdentifier(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }
  
  static Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }
}
```

### 3. Firebase Performance

```dart
// lib/services/performance_service.dart
class PerformanceService {
  static final FirebasePerformance _performance = FirebasePerformance.instance;
  
  static Future<void> startTrace(String traceName) async {
    final trace = _performance.newTrace(traceName);
    await trace.start();
    return trace;
  }
  
  static Future<void> stopTrace(Trace trace) async {
    await trace.stop();
  }
  
  static Future<void> addMetric(String traceName, String metricName, int value) async {
    final trace = _performance.newTrace(traceName);
    trace.setMetric(metricName, value);
  }
}
```

## 🔒 Seguridad

### 1. Configuración de Seguridad

```javascript
// firebase/firestore.rules (Seguridad avanzada)
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Función para validar datos de usuario
    function isValidUser(userData) {
      return userData.keys().hasAll(['nombre', 'email']) &&
             userData.nombre is string &&
             userData.email is string &&
             userData.email.matches('^[^@]+@[^@]+\\.[^@]+$');
    }
    
    // Función para validar datos de misión
    function isValidMission(missionData) {
      return missionData.keys().hasAll(['titulo', 'descripcion', 'categoria', 'puntos']) &&
             missionData.titulo is string &&
             missionData.titulo.size() > 0 &&
             missionData.titulo.size() <= 100 &&
             missionData.descripcion is string &&
             missionData.descripcion.size() <= 500 &&
             missionData.categoria in ['fuerza_fisica', 'mente_activa', 'salud_nutricion', 'economia_finanzas', 'habitos_higiene'] &&
             missionData.puntos is int &&
             missionData.puntos > 0 &&
             missionData.puntos <= 1000;
    }
    
    // Usuarios
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId &&
        (request.method == 'get' || isValidUser(request.resource.data));
    }
    
    // Misiones
    match /misiones/{missionId} {
      allow read: if request.auth != null;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.usuarioId &&
        isValidMission(request.resource.data);
      allow update, delete: if request.auth != null && 
        request.auth.uid == resource.data.usuarioId;
    }
    
    // Progreso
    match /progreso/{progressId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.usuarioId;
    }
  }
}
```

### 2. Validación de Datos

```dart
// lib/utils/validators.dart
class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }
  
  static bool isValidMissionData(Map<String, dynamic> data) {
    return data['titulo'] != null &&
           data['titulo'].toString().isNotEmpty &&
           data['titulo'].toString().length <= 100 &&
           data['descripcion'] != null &&
           data['descripcion'].toString().length <= 500 &&
           data['categoria'] != null &&
           ['fuerza_fisica', 'mente_activa', 'salud_nutricion', 'economia_finanzas', 'habitos_higiene']
               .contains(data['categoria']) &&
           data['puntos'] != null &&
           data['puntos'] is int &&
           data['puntos'] > 0 &&
           data['puntos'] <= 1000;
  }
  
  static bool isValidUserData(Map<String, dynamic> data) {
    return data['nombre'] != null &&
           data['nombre'].toString().isNotEmpty &&
           data['email'] != null &&
           isValidEmail(data['email'].toString());
  }
}
```

## ⚡ Optimización

### 1. Optimización de Rendimiento

```dart
// lib/utils/performance_utils.dart
class PerformanceUtils {
  // Lazy loading de imágenes
  static Widget cachedImage(String url, {double? width, double? height}) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      memCacheWidth: 300,
      memCacheHeight: 300,
    );
  }
  
  // Optimización de listas
  static Widget optimizedListView({
    required List<dynamic> items,
    required Widget Function(BuildContext, int) itemBuilder,
  }) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: itemBuilder,
      cacheExtent: 1000,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
    );
  }
  
  // Debounce para búsquedas
  static Timer? _debounceTimer;
  static void debounce(VoidCallback callback, {Duration duration = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }
}
```

### 2. Optimización de Red

```dart
// lib/services/network_service.dart
class NetworkService {
  static final Connectivity _connectivity = Connectivity();
  
  // Verificar conectividad
  static Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
  
  // Retry con backoff exponencial
  static Future<T> retryWithBackoff<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    int retries = 0;
    Duration delay = initialDelay;
    
    while (retries < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        retries++;
        if (retries >= maxRetries) rethrow;
        
        await Future.delayed(delay);
        delay *= 2;
      }
    }
    
    throw Exception('Max retries exceeded');
  }
}
```

### 3. Optimización de Caché

```dart
// lib/services/cache_service.dart
class CacheService {
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB
  static const Duration cacheExpiration = Duration(days: 7);
  
  // Limpiar caché expirado
  static Future<void> cleanExpiredCache() async {
    final now = DateTime.now();
    final box = Hive.box<Mision>('cache_misiones');
    
    final expiredKeys = <String>[];
    for (var key in box.keys) {
      final mission = box.get(key);
      if (mission != null && now.difference(mission.timestamp) > cacheExpiration) {
        expiredKeys.add(key);
      }
    }
    
    for (var key in expiredKeys) {
      await box.delete(key);
    }
  }
  
  // Optimizar tamaño de caché
  static Future<void> optimizeCacheSize() async {
    final box = Hive.box<Mision>('cache_misiones');
    final missions = box.values.toList();
    
    // Ordenar por fecha de acceso
    missions.sort((a, b) => a.lastAccessed.compareTo(b.lastAccessed));
    
    // Eliminar misiones más antiguas si excede el tamaño máximo
    int currentSize = 0;
    for (var mission in missions) {
      currentSize += mission.size;
      if (currentSize > maxCacheSize) {
        await box.delete(mission.id);
      }
    }
  }
}
```

---

Esta guía proporciona una referencia completa para desplegar **Reflection** en producción de manera segura y optimizada. 