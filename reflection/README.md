# Reflection - Aplicación de Reflexión Personal

## 📋 Descripción General

**Reflection** es una aplicación móvil desarrollada en Flutter que ayuda a los usuarios a desarrollar hábitos saludables a través de un sistema de misiones gamificado. La aplicación combina elementos de reflexión personal, seguimiento de objetivos y recompensas para motivar el crecimiento personal.

## 🎯 Características Principales

### 🏆 Sistema de Misiones
- **Categorías de misiones**: Fuerza física, mente activa, salud y nutrición, economía y finanzas, hábitos de higiene
- **Sistema de puntos**: Cada misión otorga puntos de experiencia (XP)
- **Progreso visual**: Seguimiento del progreso diario y semanal
- **Logros desbloqueables**: Sistema de badges y recompensas

### 🔐 Autenticación
- **Múltiples métodos de login**:
  - Email y contraseña
  - Google Sign-In
  - Apple Sign-In
  - Autenticación anónima
- **Gestión de sesiones** segura
- **Recuperación de contraseña**

### 💾 Almacenamiento
- **Firebase Firestore**: Base de datos en la nube para datos de usuario y misiones
- **Hive**: Almacenamiento local para caché y funcionamiento offline
- **Sincronización automática** entre local y remoto

### 🎨 Interfaz de Usuario
- **Diseño responsive** que se adapta a diferentes tamaños de pantalla
- **Tema claro/oscuro** configurable
- **Animaciones fluidas** con flutter_animate
- **Iconografía pixelada** personalizada

## 🏗️ Arquitectura del Proyecto

### Estructura de Directorios

```
lib/
├── auth/                    # Sistema de autenticación
│   ├── firebase_auth/      # Implementación Firebase Auth
│   ├── auth_manager.dart   # Gestor de autenticación
│   └── base_auth_user_provider.dart
├── backend/                # Lógica de backend
│   └── firebase/          # Configuración y servicios Firebase
├── components/             # Componentes reutilizables
│   ├── sidebar/           # Barra lateral
│   ├── item_de_mision_widget.dart
│   └── list_widget.dart
├── flutter_flow/          # Configuración FlutterFlow
├── main_app_shell/        # Shell principal de la aplicación
├── modales/              # Componentes modales
├── pages/                # Páginas de la aplicación
│   ├── home/             # Página principal
│   ├── misiones/         # Gestión de misiones
│   ├── profile/          # Perfil de usuario
│   ├── configuracion/    # Configuración
│   └── login_reflection/ # Página de login
├── services/             # Servicios de la aplicación
│   └── database_service.dart
├── utils/                # Utilidades y helpers
├── main.dart             # Punto de entrada
└── index.dart            # Exportaciones
```

### Modelos de Datos

#### Mision (Hive Type 0)
```dart
class Mision {
  final String id;
  final String titulo;
  final String descripcion;
  final int puntos;
}
```

#### DraftChange (Hive Type 1)
```dart
class DraftChange {
  final String id;
  final String tipo; // 'create', 'update', 'delete'
  final Map<String, dynamic> datos;
  final DateTime timestamp;
}
```

#### Setting (Hive Type 2)
```dart
class Setting {
  final String key;
  final String tema;
  final String idioma;
  final Map<String, dynamic> filtros;
}
```

#### UIState (Hive Type 3)
```dart
class UIState {
  final String key;
  final String ruta;
  final Map<String, dynamic> estado;
  final DateTime ultimaActualizacion;
}
```

## 🔧 Configuración y Instalación

### Prerrequisitos
- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0
- Firebase project configurado
- Android Studio / VS Code

### Instalación

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd reflection
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Crear proyecto en Firebase Console
   - Habilitar Authentication y Firestore
   - Descargar y configurar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)
   - Configurar reglas de Firestore

4. **Generar código Hive**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 📱 Funcionalidades Detalladas

### Página Principal (Home)
- **Dashboard personalizado** con resumen del progreso
- **Actividades recientes** con timeline
- **Acciones rápidas** para tareas comunes
- **Progreso diario** visual
- **Sincronización automática** de datos

### Sistema de Misiones
- **Creación de misiones** por categorías
- **Seguimiento de progreso** en tiempo real
- **Completado de misiones** con validación
- **Sistema de recompensas** automático
- **Historial de misiones** completadas

### Perfil de Usuario
- **Información personal** editable
- **Estadísticas de progreso**
- **Logros desbloqueados**
- **Configuración de preferencias**

### Configuración
- **Tema de la aplicación** (claro/oscuro)
- **Idioma** (español)
- **Notificaciones**
- **Privacidad y seguridad**

## 🔌 Dependencias Principales

### Firebase
- `firebase_core`: Configuración base de Firebase
- `firebase_auth`: Autenticación de usuarios
- `cloud_firestore`: Base de datos en la nube
- `firebase_performance`: Monitoreo de rendimiento

### UI/UX
- `flutter_animate`: Animaciones fluidas
- `google_fonts`: Tipografías personalizadas
- `cached_network_image`: Caché de imágenes
- `auto_size_text`: Texto adaptable

### Navegación
- `go_router`: Navegación declarativa
- `page_transition`: Transiciones entre páginas

### Almacenamiento
- `hive`: Base de datos local
- `shared_preferences`: Preferencias del usuario
- `sqflite`: Base de datos SQLite (backup)

### Utilidades
- `provider`: Gestión de estado
- `intl`: Internacionalización
- `timeago`: Formato de fechas relativas
- `url_launcher`: Apertura de enlaces

## 🚀 Despliegue

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🔒 Seguridad

- **Autenticación robusta** con Firebase Auth
- **Reglas de Firestore** configuradas para seguridad
- **Validación de datos** en cliente y servidor
- **Encriptación** de datos sensibles
- **Gestión segura** de tokens JWT

## 📊 Monitoreo y Analytics

- **Firebase Performance** para métricas de rendimiento
- **Logs estructurados** para debugging
- **Métricas de uso** anónimas
- **Reportes de errores** automáticos

## 🤝 Contribución

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Para soporte técnico o preguntas sobre el proyecto:
- Crear un issue en GitHub
- Contactar al equipo de desarrollo
- Revisar la documentación de Firebase

## 🔄 Roadmap

### Versión 1.1
- [ ] Notificaciones push
- [ ] Exportación de datos
- [ ] Temas personalizados
- [ ] Integración con wearables

### Versión 1.2
- [ ] Social features
- [ ] Challenges grupales
- [ ] API pública
- [ ] Widgets de home screen

### Versión 2.0
- [ ] IA para recomendaciones
- [ ] Integración con calendario
- [ ] Modo offline completo
- [ ] Multiplataforma (desktop)

---

**Desarrollado con ❤️ usando Flutter y Firebase**
