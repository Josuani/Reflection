# Reflection - Plataforma de Gamificación para Desarrollo Personal

<div align="center">

![Reflection Logo](assets/images/reflection_icon_clean.png)

**Transforma tus hábitos en misiones, tus logros en recompensas**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-9.0+-orange.svg)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[Características](#características) • [Instalación](#instalación) • [Uso](#uso) • [Arquitectura](#arquitectura) • [Contribuir](#contribuir)

</div>

---

## 📋 Tabla de Contenidos

- [Descripción](#descripción)
- [Características](#características)
- [Capturas de Pantalla](#capturas-de-pantalla)
- [Instalación](#instalación)
- [Configuración](#configuración)
- [Uso](#uso)
- [Arquitectura](#arquitectura)
- [API](#api)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

## 🎯 Descripción

**Reflection** es una aplicación móvil desarrollada en Flutter que transforma el desarrollo personal en una experiencia gamificada. Los usuarios pueden crear y completar "misiones" en diferentes categorías de vida, ganando puntos y desbloqueando logros mientras mejoran sus hábitos.

### 🎮 Concepto Principal

La aplicación se basa en el principio de que **cada hábito positivo es una misión que completar**. Al gamificar el desarrollo personal, los usuarios se mantienen motivados y comprometidos con sus objetivos de mejora continua.

## ✨ Características

### 🎯 Sistema de Misiones
- **5 Categorías Principales:**
  - 🏋️ **Fuerza física** - Ejercicios y actividad física
  - 🧠 **Mente activa** - Lectura, aprendizaje, meditación
  - 🥗 **Salud y nutrición** - Alimentación saludable
  - 💰 **Economía y finanzas** - Ahorro, inversión, presupuesto
  - 🧼 **Hábitos de higiene** - Rutinas de cuidado personal

- **Estados de Misión:**
  - 📋 Disponible
  - 🔄 En progreso
  - ✅ Completado

### 👤 Gestión de Usuarios
- 🔐 Autenticación segura con Firebase
- 📊 Perfiles personalizables
- 📈 Seguimiento de progreso
- 🏆 Sistema de logros y recompensas

### 💾 Almacenamiento Inteligente
- ☁️ **Firestore** para datos remotos
- 📱 **Hive** para caché local
- 🔄 Sincronización automática offline/online
- ⚡ Rendimiento optimizado

### 🎨 Interfaz de Usuario
- 📱 Diseño responsivo
- 🌙 Modo oscuro/claro
- 🎭 Animaciones fluidas
- 🌍 Soporte multiidioma (Español)

## 📱 Capturas de Pantalla

> *Las capturas de pantalla se agregarán aquí*

## 🚀 Instalación

### Prerrequisitos

- [Flutter](https://flutter.dev/docs/get-started/install) 3.0.0 o superior
- [Dart](https://dart.dev/get-dart) 3.0.0 o superior
- [Android Studio](https://developer.android.com/studio) o [VS Code](https://code.visualstudio.com/)
- Cuenta de [Firebase](https://firebase.google.com/)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/reflection.git
   cd reflection
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   ```bash
   # Seguir la guía en docs/SETUP.md
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

Para instrucciones detalladas, consulta [SETUP.md](SETUP.md).

## ⚙️ Configuración

### Variables de Entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
FIREBASE_PROJECT_ID=tu-proyecto-firebase
FIREBASE_API_KEY=tu-api-key
```

### Configuración de Firebase

1. Crear proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Habilitar Authentication, Firestore y Storage
3. Configurar reglas de seguridad
4. Agregar configuración de la aplicación

Ver [DEPLOYMENT.md](DEPLOYMENT.md) para detalles completos.

## 🎮 Uso

### Crear una Nueva Misión

1. Abrir la aplicación
2. Tocar el botón "+" en la pantalla principal
3. Seleccionar una categoría
4. Completar los detalles de la misión
5. Guardar

### Completar Misiones

1. Ir a la sección "Misiones"
2. Seleccionar una misión disponible
3. Marcar como "En progreso"
4. Completar las tareas requeridas
5. Marcar como "Completado"

### Ver Progreso

- **Dashboard principal**: Resumen de actividades recientes
- **Perfil**: Estadísticas detalladas y logros
- **Historial**: Registro completo de misiones completadas

## 🏗️ Arquitectura

### Diagrama de Arquitectura

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Presentation  │    │   Business      │    │   Data Layer    │
│   Layer         │    │   Logic         │    │                 │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Pages         │    │ • Services      │    │ • Firebase      │
│ • Components    │    │ • Models        │    │ • Hive          │
│ • Widgets       │    │ • Providers     │    │ • Local Cache   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### Patrones de Diseño

- **Provider Pattern**: Gestión de estado
- **Repository Pattern**: Acceso a datos
- **Service Layer**: Lógica de negocio
- **Observer Pattern**: Reactividad con streams

### Estructura de Directorios

```
lib/
├── main.dart                 # Punto de entrada
├── pages/                    # Páginas de la aplicación
│   ├── home/                 # Dashboard principal
│   ├── misiones2/            # Gestión de misiones
│   ├── profile/              # Perfil de usuario
│   └── configuracion/        # Configuración
├── components/               # Componentes reutilizables
├── backend/                  # Lógica de backend
│   ├── firebase/             # Servicios de Firebase
│   └── schema/               # Modelos de datos
├── services/                 # Servicios de aplicación
├── auth/                     # Autenticación
└── utils/                    # Utilidades
```

Para más detalles, consulta [ARCHITECTURE.md](ARCHITECTURE.md).

## 🔌 API

### Endpoints Principales

#### Usuarios
```dart
// Crear usuario
POST /usuarios
{
  "nombre": "string",
  "email": "string",
  "avatar": "string"
}

// Obtener usuario
GET /usuarios/{id}

// Actualizar usuario
PUT /usuarios/{id}
{
  "puntos": "number",
  "nivel": "number"
}
```

#### Misiones
```dart
// Crear misión
POST /misiones
{
  "titulo": "string",
  "descripcion": "string",
  "categoria": "string",
  "puntos": "number"
}

// Obtener misiones por estado
GET /misiones?status={status}

// Actualizar estado de misión
PUT /misiones/{id}
{
  "status": "string"
}
```

Para documentación completa, consulta [API.md](API.md).

## 🤝 Contribuir

¡Tus contribuciones son bienvenidas! Por favor, lee [CONTRIBUTING.md](CONTRIBUTING.md) para detalles sobre nuestro código de conducta y el proceso para enviar pull requests.

### Cómo Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Estándares de Código

- Seguir las [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Usar [flutter_lints](https://pub.dev/packages/flutter_lints)
- Escribir tests para nuevas funcionalidades
- Documentar código complejo

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## 🙏 Agradecimientos

- [Flutter](https://flutter.dev/) por el framework
- [Firebase](https://firebase.google.com/) por el backend
- [Hive](https://pub.dev/packages/hive) por el almacenamiento local
- Comunidad de Flutter por las librerías y recursos


<div align="center">

**Hecho con ❤️ usando Flutter**

[⬆ Volver arriba](#reflection---plataforma-de-gamificación-para-desarrollo-personal)

</div> 