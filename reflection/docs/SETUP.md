# Guía de Instalación y Configuración

Esta guía te ayudará a configurar el proyecto **Reflection** en tu entorno de desarrollo local.

## 📋 Tabla de Contenidos

- [Prerrequisitos](#prerrequisitos)
- [Instalación de Flutter](#instalación-de-flutter)
- [Configuración del Proyecto](#configuración-del-proyecto)
- [Configuración de Firebase](#configuración-de-firebase)
- [Configuración de Entorno](#configuración-de-entorno)
- [Ejecutar la Aplicación](#ejecutar-la-aplicación)
- [Solución de Problemas](#solución-de-problemas)

## 🔧 Prerrequisitos

### Software Requerido

- **Flutter SDK** 3.0.0 o superior
- **Dart SDK** 3.0.0 o superior
- **Android Studio** o **VS Code**
- **Git**
- **Node.js** (para Firebase CLI)

### Cuentas Requeridas

- [Cuenta de Firebase](https://firebase.google.com/)
- [Cuenta de GitHub](https://github.com/) (opcional)

## 🚀 Instalación de Flutter

### 1. Descargar Flutter

**Windows:**
```bash
# Descargar desde https://flutter.dev/docs/get-started/install/windows
# Extraer en C:\flutter
```

**macOS:**
```bash
# Usando Homebrew
brew install flutter

# O descargar manualmente
git clone https://github.com/flutter/flutter.git
export PATH="$PATH:`pwd`/flutter/bin"
```

**Linux:**
```bash
# Descargar desde https://flutter.dev/docs/get-started/install/linux
# Extraer en ~/flutter
export PATH="$PATH:`pwd`/flutter/bin"
```

### 2. Verificar Instalación

```bash
flutter doctor
```

Asegúrate de que todos los componentes estén marcados como ✅.

### 3. Configurar IDE

**VS Code:**
1. Instalar extensión "Flutter"
2. Instalar extensión "Dart"

**Android Studio:**
1. Instalar plugin "Flutter"
2. Instalar plugin "Dart"

## 📁 Configuración del Proyecto

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/reflection.git
cd reflection
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Verificar Configuración

```bash
flutter analyze
flutter test
```

## 🔥 Configuración de Firebase

### 1. Crear Proyecto Firebase

1. Ir a [Firebase Console](https://console.firebase.google.com/)
2. Hacer clic en "Crear proyecto"
3. Nombrar el proyecto (ej: "reflection-app")
4. Habilitar Google Analytics (opcional)
5. Crear proyecto

### 2. Configurar Authentication

1. En Firebase Console, ir a "Authentication"
2. Hacer clic en "Comenzar"
3. Habilitar proveedores:
   - **Email/Password**
   - **Google** (recomendado)
   - **Apple** (para iOS)

### 3. Configurar Firestore Database

1. Ir a "Firestore Database"
2. Hacer clic en "Crear base de datos"
3. Seleccionar "Comenzar en modo de prueba"
4. Elegir ubicación (ej: "us-central1")

### 4. Configurar Storage

1. Ir a "Storage"
2. Hacer clic en "Comenzar"
3. Seleccionar ubicación
4. Configurar reglas de seguridad

### 5. Obtener Configuración

1. Ir a "Configuración del proyecto" (⚙️)
2. Seleccionar "Configuración de SDK"
3. Descargar archivo `google-services.json` (Android)
4. Descargar archivo `GoogleService-Info.plist` (iOS)

### 6. Configurar Archivos de Configuración

**Android:**
```bash
# Copiar google-services.json a android/app/
cp google-services.json android/app/
```

**iOS:**
```bash
# Copiar GoogleService-Info.plist a ios/Runner/
cp GoogleService-Info.plist ios/Runner/
```

### 7. Configurar Reglas de Firestore

Editar `firebase/firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuarios pueden leer/escribir su propio documento
    match /usuarios/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Misiones: lectura pública, escritura solo para propietario
    match /misiones/{missionId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.usuarioId;
    }
    
    // Progreso: solo propietario
    match /progreso/{progressId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.usuarioId;
    }
  }
}
```

### 8. Configurar Reglas de Storage

Editar `firebase/storage.rules`:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /usuarios/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && 
        request.auth.uid == userId;
    }
  }
}
```

## ⚙️ Configuración de Entorno

### 1. Variables de Entorno

Crear archivo `.env` en la raíz del proyecto:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=tu-proyecto-firebase
FIREBASE_API_KEY=tu-api-key
FIREBASE_APP_ID=tu-app-id

# App Configuration
APP_NAME=Reflection
APP_VERSION=1.0.0
DEBUG_MODE=true
```

### 2. Configurar Android

**android/app/build.gradle:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.tuempresa.reflection"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

**android/app/src/main/AndroidManifest.xml:**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    
    <application
        android:label="Reflection"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <!-- ... -->
    </application>
</manifest>
```

### 3. Configurar iOS

**ios/Runner/Info.plist:**
```xml
<key>CFBundleDisplayName</key>
<string>Reflection</string>
<key>CFBundleIdentifier</key>
<string>com.tuempresa.reflection</string>
```

## 🏃‍♂️ Ejecutar la Aplicación

### 1. Verificar Dispositivos

```bash
flutter devices
```

### 2. Ejecutar en Android

```bash
flutter run -d android
```

### 3. Ejecutar en iOS

```bash
flutter run -d ios
```

### 4. Ejecutar en Web

```bash
flutter run -d chrome
```

### 5. Modo Debug

```bash
flutter run --debug
```

### 6. Modo Release

```bash
flutter run --release
```

## 🔧 Comandos Útiles

### Desarrollo

```bash
# Analizar código
flutter analyze

# Ejecutar tests
flutter test

# Formatear código
dart format .

# Limpiar build
flutter clean

# Obtener dependencias
flutter pub get

# Actualizar dependencias
flutter pub upgrade
```

### Build

```bash
# Build APK
flutter build apk

# Build App Bundle
flutter build appbundle

# Build iOS
flutter build ios

# Build Web
flutter build web
```

## 🐛 Solución de Problemas

### Problemas Comunes

#### 1. Error de Dependencias

```bash
flutter clean
flutter pub get
```

#### 2. Error de Firebase

- Verificar archivos de configuración
- Verificar reglas de Firestore
- Verificar conexión a internet

#### 3. Error de Permisos (Android)

```bash
# Verificar permisos en AndroidManifest.xml
# Asegurar que google-services.json esté en android/app/
```

#### 4. Error de Certificados (iOS)

```bash
# En Xcode, ir a Signing & Capabilities
# Verificar Team y Bundle Identifier
```

#### 5. Error de Hive

```bash
# Regenerar archivos generados
flutter packages pub run build_runner build
```

### Logs de Debug

```bash
# Ver logs detallados
flutter run --verbose

# Ver logs de Firebase
flutter logs
```

### Verificar Configuración

```bash
# Verificar configuración completa
flutter doctor -v

# Verificar configuración de Firebase
firebase projects:list
```

## 📚 Recursos Adicionales

- [Documentación de Flutter](https://flutter.dev/docs)
- [Documentación de Firebase](https://firebase.google.com/docs)
- [Guía de Hive](https://docs.hivedb.dev/)
- [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)

## 🆘 Obtener Ayuda

Si encuentras problemas:

1. Revisar [Issues](https://github.com/tu-usuario/reflection/issues)
2. Crear nuevo issue con detalles del problema
3. Incluir logs de error y pasos para reproducir

---

**¡Listo! Tu entorno de desarrollo está configurado. 🎉** 