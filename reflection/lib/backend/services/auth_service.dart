import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:reflection/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  // Validación de contraseña
  bool isPasswordStrong(String password) {
    return password.length >= 8 &&
           password.contains(RegExp(r'[A-Z]')) &&
           password.contains(RegExp(r'[a-z]')) &&
           password.contains(RegExp(r'[0-9]')) &&
           password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  // Validación de email
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Iniciar sesión
  Future<UserCredential> signIn(String email, String password) async {
    try {
      if (!isValidEmail(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'El correo electrónico no es válido',
        );
      }

      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _logger.e('Error en inicio de sesión', error: e, stackTrace: StackTrace.current);
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No existe una cuenta con este correo electrónico',
          );
        case 'wrong-password':
          throw FirebaseAuthException(
            code: 'wrong-password',
            message: 'La contraseña es incorrecta',
          );
        case 'user-disabled':
          throw FirebaseAuthException(
            code: 'user-disabled',
            message: 'Esta cuenta ha sido deshabilitada',
          );
        default:
          rethrow;
      }
    } catch (e, stackTrace) {
      _logger.e('Error inesperado en inicio de sesión', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Registro de usuario
  Future<UserCredential> signUp(String email, String password) async {
    try {
      if (!isValidEmail(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'El correo electrónico no es válido',
        );
      }

      if (!isPasswordStrong(password)) {
        throw FirebaseAuthException(
          code: 'weak-password',
          message: 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial',
        );
      }

      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _logger.e('Error en registro', error: e, stackTrace: StackTrace.current);
      switch (e.code) {
        case 'email-already-in-use':
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Ya existe una cuenta con este correo electrónico',
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'El correo electrónico no es válido',
          );
        case 'operation-not-allowed':
          throw FirebaseAuthException(
            code: 'operation-not-allowed',
            message: 'El registro con correo electrónico y contraseña no está habilitado',
          );
        default:
          rethrow;
      }
    } catch (e, stackTrace) {
      _logger.e('Error inesperado en registro', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Recuperación de contraseña
  Future<void> resetPassword(String email) async {
    try {
      if (!isValidEmail(email)) {
        throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'El correo electrónico no es válido',
        );
      }

      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      _logger.e('Error en recuperación de contraseña', error: e, stackTrace: StackTrace.current);
      switch (e.code) {
        case 'user-not-found':
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No existe una cuenta con este correo electrónico',
          );
        case 'invalid-email':
          throw FirebaseAuthException(
            code: 'invalid-email',
            message: 'El correo electrónico no es válido',
          );
        default:
          rethrow;
      }
    } catch (e, stackTrace) {
      _logger.e('Error inesperado en recuperación de contraseña', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, stackTrace) {
      _logger.e('Error al cerrar sesión', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // Verificar estado de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obtener usuario actual
  User? get currentUser => _auth.currentUser;

  // Verificar si el usuario está autenticado
  bool get isAuthenticated => currentUser != null;
} 