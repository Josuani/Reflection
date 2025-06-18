# Guía de Contribución

¡Gracias por tu interés en contribuir al proyecto **Reflection**! Este documento te guiará a través del proceso de contribución.

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Cómo Contribuir](#cómo-contribuir)
- [Configuración del Entorno](#configuración-del-entorno)
- [Estándares de Código](#estándares-de-código)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Tests](#tests)
- [Documentación](#documentación)
- [Reportar Bugs](#reportar-bugs)
- [Solicitar Features](#solicitar-features)
- [Preguntas Frecuentes](#preguntas-frecuentes)

## 🤝 Código de Conducta

### Nuestros Estándares

Como contribuidor, esperamos que:

- **Sé respetuoso**: Trata a todos los miembros de la comunidad con respeto
- **Sé constructivo**: Proporciona feedback constructivo y útil
- **Sé colaborativo**: Trabaja en equipo y comparte conocimiento
- **Sé profesional**: Mantén un comportamiento profesional en todas las interacciones

### Comportamiento Inaceptable

No toleramos:
- Comportamiento abusivo o discriminatorio
- Acoso o intimidación
- Spam o contenido inapropiado
- Violación de privacidad

### Reportar Incidentes

Si experimentas o presencias comportamiento inaceptable, contacta al equipo del proyecto.

## 🚀 Cómo Contribuir

### Tipos de Contribuciones

Aceptamos diferentes tipos de contribuciones:

1. **🐛 Reportar Bugs**
2. **💡 Solicitar Features**
3. **📝 Mejorar Documentación**
4. **🔧 Corregir Bugs**
5. **✨ Implementar Features**
6. **🧪 Escribir Tests**
7. **🎨 Mejorar UI/UX**

### Proceso de Contribución

1. **Fork** el repositorio
2. **Clone** tu fork localmente
3. **Crea** una rama para tu feature
4. **Desarrolla** tu contribución
5. **Tests** tu código
6. **Commit** tus cambios
7. **Push** a tu fork
8. **Crea** un Pull Request

## ⚙️ Configuración del Entorno

### Prerrequisitos

- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- IDE (VS Code, Android Studio)
- Git
- Cuenta de Firebase (para testing)

### Configuración Inicial

```bash
# 1. Fork el repositorio en GitHub

# 2. Clone tu fork
git clone https://github.com/tu-usuario/reflection.git
cd reflection

# 3. Agregar el repositorio original como upstream
git remote add upstream https://github.com/original-owner/reflection.git

# 4. Instalar dependencias
flutter pub get

# 5. Verificar configuración
flutter doctor
flutter analyze
flutter test
```

### Configuración de Firebase para Desarrollo

1. Crear proyecto de Firebase para desarrollo
2. Configurar Authentication, Firestore y Storage
3. Copiar archivos de configuración
4. Actualizar reglas de seguridad

Ver [SETUP.md](SETUP.md) para detalles completos.

## 📝 Estándares de Código

### Convenciones de Nomenclatura

#### Archivos y Directorios
```dart
// ✅ Correcto
lib/
├── pages/
│   ├── home_page_widget.dart
│   └── mission_list_widget.dart
├── components/
│   ├── custom_button.dart
│   └── mission_card.dart
└── services/
    └── database_service.dart

// ❌ Incorrecto
lib/
├── Pages/
│   ├── HomePageWidget.dart
│   └── missionListWidget.dart
```

#### Clases
```dart
// ✅ Correcto
class HomePageWidget extends StatefulWidget
class MissionService
class DatabaseHelper

// ❌ Incorrecto
class homePageWidget extends StatefulWidget
class mission_service
class databaseHelper
```

#### Variables y Métodos
```dart
// ✅ Correcto
String userName;
int missionCount;
Future<void> createMission();
bool isValidEmail;

// ❌ Incorrecto
String user_name;
int missioncount;
Future<void> CreateMission();
bool is_valid_email;
```

### Estilo de Código

#### Formato
```dart
// ✅ Correcto
class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<String> createMission(Map<String, dynamic> data) async {
    final docRef = await _firestore.collection('misiones').add({
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }
}

// ❌ Incorrecto
class MissionService{
final FirebaseFirestore _firestore=FirebaseFirestore.instance;
Future<String> createMission(Map<String,dynamic> data)async{
final docRef=await _firestore.collection('misiones').add({...data,'createdAt':FieldValue.serverTimestamp()});
return docRef.id;
}
}
```

#### Comentarios
```dart
// ✅ Correcto
/// Crea una nueva misión en Firestore
/// 
/// [data] Datos de la misión a crear
/// Returns el ID del documento creado
Future<String> createMission(Map<String, dynamic> data) async {
  // Validar datos antes de crear
  if (data['titulo']?.isEmpty ?? true) {
    throw ArgumentError('El título es requerido');
  }
  
  final docRef = await _firestore.collection('misiones').add({
    ...data,
    'createdAt': FieldValue.serverTimestamp(),
  });
  return docRef.id;
}

// ❌ Incorrecto
// crea mision
Future<String> createMission(Map<String, dynamic> data) async {
  final docRef = await _firestore.collection('misiones').add(data);
  return docRef.id;
}
```

### Linting

Usamos `flutter_lints` para mantener la calidad del código:

```yaml
# analysis_options.yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - avoid_unused_constructor_parameters
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - constant_identifier_names
    - control_flow_in_finally
    - directives_ordering
    - empty_catches
    - empty_constructor_bodies
    - empty_statements
    - hash_and_equals
    - implementation_imports
    - library_names
    - library_prefixes
    - non_constant_identifier_names
    - package_api_docs
    - package_names
    - package_prefixed_library_names
    - prefer_const_constructors
    - prefer_final_fields
    - prefer_is_empty
    - prefer_is_not_empty
    - prefer_typing_uninitialized_variables
    - slash_for_doc_comments
    - test_types_in_equals
    - throw_in_finally
    - type_init_formals
    - unnecessary_brace_in_string_interps
    - unnecessary_getters_setters
    - unnecessary_new
    - unnecessary_null_aware_assignments
    - unnecessary_statements
    - unrelated_type_equality_checks
    - use_rethrow_when_possible
    - valid_regexps
```

## 🔄 Proceso de Desarrollo

### Flujo de Trabajo

```bash
# 1. Actualizar tu fork
git fetch upstream
git checkout main
git merge upstream/main

# 2. Crear rama para feature
git checkout -b feature/nueva-funcionalidad

# 3. Desarrollar
# ... hacer cambios ...

# 4. Verificar código
flutter analyze
flutter test
flutter format .

# 5. Commit
git add .
git commit -m "feat: agregar nueva funcionalidad

- Implementar sistema de notificaciones
- Agregar tests unitarios
- Actualizar documentación"

# 6. Push
git push origin feature/nueva-funcionalidad

# 7. Crear Pull Request
```

### Convenciones de Commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

```bash
# Tipos de commits
feat: nueva funcionalidad
fix: corrección de bug
docs: cambios en documentación
style: cambios de formato (no afectan funcionalidad)
refactor: refactorización de código
test: agregar o modificar tests
chore: cambios en build, configuraciones, etc.

# Ejemplos
feat: agregar sistema de gamificación
fix: corregir error en autenticación
docs: actualizar README con nuevas instrucciones
style: formatear código según estándares
refactor: simplificar lógica de misiones
test: agregar tests para MissionService
chore: actualizar dependencias
```

### Estructura de Pull Request

```markdown
## Descripción
Breve descripción de los cambios realizados.

## Tipo de Cambio
- [ ] Bug fix
- [ ] Nueva funcionalidad
- [ ] Mejora de documentación
- [ ] Refactorización
- [ ] Test

## Cambios Realizados
- Lista de cambios específicos
- Mejoras implementadas
- Problemas resueltos

## Tests
- [ ] Tests unitarios agregados/actualizados
- [ ] Tests de integración ejecutados
- [ ] Tests manuales realizados

## Capturas de Pantalla (si aplica)
Agregar capturas de pantalla para cambios de UI.

## Checklist
- [ ] Código sigue los estándares del proyecto
- [ ] Tests pasan correctamente
- [ ] Documentación actualizada
- [ ] No hay conflictos de merge
```

## 🧪 Tests

### Tipos de Tests

1. **Unit Tests**: Prueban funciones individuales
2. **Widget Tests**: Prueban widgets de Flutter
3. **Integration Tests**: Prueban flujos completos
4. **Golden Tests**: Prueban la apariencia visual

### Estructura de Tests

```
test/
├── unit/                    # Tests unitarios
│   ├── services/
│   │   ├── database_service_test.dart
│   │   └── mission_service_test.dart
│   └── models/
│       └── mission_test.dart
├── widget/                  # Tests de widgets
│   ├── home_page_test.dart
│   └── mission_card_test.dart
├── integration/             # Tests de integración
│   └── app_test.dart
└── golden/                  # Tests visuales
    └── home_page_golden_test.dart
```

### Ejemplo de Test Unitario

```dart
// test/unit/services/mission_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reflection/backend/firebase/mission_service.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('MissionService', () {
    late MissionService missionService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      missionService = MissionService();
    });

    test('should create mission successfully', () async {
      // Arrange
      final missionData = {
        'titulo': 'Test Mission',
        'descripcion': 'Test Description',
        'categoria': 'test',
        'puntos': 10,
      };

      // Act
      final result = await missionService.createMission(missionData);

      // Assert
      expect(result, isA<String>());
      expect(result.isNotEmpty, true);
    });

    test('should throw error for invalid mission data', () async {
      // Arrange
      final invalidData = <String, dynamic>{};

      // Act & Assert
      expect(
        () => missionService.createMission(invalidData),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
```

### Ejecutar Tests

```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/unit/services/mission_service_test.dart

# Tests con coverage
flutter test --coverage

# Tests de integración
flutter test integration_test/
```

## 📚 Documentación

### Documentación de Código

```dart
/// Servicio para gestionar misiones en la aplicación.
/// 
/// Este servicio proporciona métodos para crear, leer, actualizar y eliminar
/// misiones tanto en Firestore como en el caché local.
/// 
/// Ejemplo de uso:
/// ```dart
/// final missionService = MissionService();
/// final missionId = await missionService.createMission({
///   'titulo': 'Mi Misión',
///   'descripcion': 'Descripción de la misión',
///   'categoria': 'fuerza_fisica',
///   'puntos': 50,
/// });
/// ```
class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Crea una nueva misión en Firestore.
  /// 
  /// [missionData] Datos de la misión a crear. Debe incluir:
  /// - titulo: String (requerido)
  /// - descripcion: String (requerido)
  /// - categoria: String (requerido)
  /// - puntos: int (requerido)
  /// 
  /// Returns el ID del documento creado en Firestore.
  /// 
  /// Throws [ArgumentError] si los datos son inválidos.
  /// Throws [FirebaseException] si hay error en Firestore.
  Future<String> createMission(Map<String, dynamic> missionData) async {
    // Validación de datos
    _validateMissionData(missionData);
    
    final docRef = await _firestore.collection('misiones').add({
      ...missionData,
      'status': 'disponible',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    return docRef.id;
  }
  
  /// Valida los datos de una misión.
  /// 
  /// [data] Datos a validar
  /// 
  /// Throws [ArgumentError] si los datos son inválidos.
  void _validateMissionData(Map<String, dynamic> data) {
    if (data['titulo']?.isEmpty ?? true) {
      throw ArgumentError('El título es requerido');
    }
    if (data['descripcion']?.isEmpty ?? true) {
      throw ArgumentError('La descripción es requerida');
    }
    if (data['categoria']?.isEmpty ?? true) {
      throw ArgumentError('La categoría es requerida');
    }
    if (data['puntos'] == null || data['puntos'] <= 0) {
      throw ArgumentError('Los puntos deben ser mayores a 0');
    }
  }
}
```

### Documentación de API

Ver [API.md](API.md) para documentación completa de la API.

### Documentación de Arquitectura

Ver [ARCHITECTURE.md](ARCHITECTURE.md) para detalles de la arquitectura.

## 🐛 Reportar Bugs

### Antes de Reportar

1. Verifica que el bug no haya sido reportado ya
2. Asegúrate de que estás usando la última versión
3. Intenta reproducir el bug en un entorno limpio

### Plantilla de Bug Report

```markdown
## Descripción del Bug
Descripción clara y concisa del problema.

## Pasos para Reproducir
1. Ir a '...'
2. Hacer clic en '...'
3. Desplazarse hacia abajo hasta '...'
4. Ver error

## Comportamiento Esperado
Descripción de lo que debería suceder.

## Comportamiento Actual
Descripción de lo que está sucediendo.

## Capturas de Pantalla
Si aplica, agregar capturas de pantalla.

## Información del Sistema
- OS: [ej. iOS, Android, Web]
- Versión de Flutter: [ej. 3.0.0]
- Versión de la app: [ej. 1.0.0]
- Dispositivo: [ej. iPhone 12, Samsung Galaxy S21]

## Logs
```
// Agregar logs relevantes aquí
```

## Contexto Adicional
Cualquier información adicional sobre el problema.
```

## 💡 Solicitar Features

### Antes de Solicitar

1. Verifica que la feature no haya sido solicitada ya
2. Considera si la feature se alinea con los objetivos del proyecto
3. Piensa en la implementación y el impacto

### Plantilla de Feature Request

```markdown
## Descripción de la Feature
Descripción clara y concisa de la funcionalidad deseada.

## Problema que Resuelve
Explicación del problema que esta feature resolvería.

## Solución Propuesta
Descripción de cómo debería funcionar la feature.

## Alternativas Consideradas
Otras soluciones que has considerado.

## Contexto Adicional
Cualquier información adicional, capturas de pantalla, etc.
```

## ❓ Preguntas Frecuentes

### ¿Cómo puedo empezar a contribuir?

1. Lee esta guía completa
2. Configura tu entorno de desarrollo
3. Busca issues etiquetados como "good first issue"
4. Únete a las discusiones en GitHub

### ¿Qué hago si tengo dudas sobre el código?

1. Revisa la documentación existente
2. Busca en issues y pull requests anteriores
3. Abre una discusión en GitHub
4. Contacta al equipo del proyecto

### ¿Cómo se revisan los pull requests?

1. Al menos un maintainer debe aprobar
2. Todos los tests deben pasar
3. El código debe seguir los estándares
4. La documentación debe estar actualizada

### ¿Puedo contribuir sin experiencia en Flutter?

¡Sí! Hay muchas formas de contribuir:
- Documentación
- Tests
- Reportar bugs
- Sugerir mejoras
- Ayudar con traducciones

### ¿Cómo se manejan los conflictos de merge?

1. Mantén tu rama actualizada con main
2. Resuelve conflictos localmente
3. Solicita ayuda si es necesario
4. No fuerces push sin consultar

## 🎉 Reconocimiento

### Contribuidores

Gracias a todos los que han contribuido al proyecto:

- [Lista de contribuidores](https://github.com/original-owner/reflection/graphs/contributors)

### Cómo Agradecer Contribuciones

- Mencionar en README
- Agregar a lista de contribuidores
- Dar crédito en releases
- Agradecer públicamente

---

**¡Gracias por contribuir a Reflection! 🚀**

Tu contribución ayuda a hacer del desarrollo personal una experiencia más motivadora y efectiva para todos. 