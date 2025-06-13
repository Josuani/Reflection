import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:logger/logger.dart';
import 'package:reflection/constants/constants.dart';

class ErrorMonitoringService {
  final Logger _logger = Logger('ErrorMonitoringService');
  bool _isInitialized = false;

  // Inicializar Sentry
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await SentryFlutter.init(
        (options) {
          options.dsn = Constants.sentryDsn;
          options.tracesSampleRate = 1.0;
          options.environment = Constants.environment;
          options.release = Constants.appVersion;
        },
      );
      _isInitialized = true;
      _logger.i('Sentry initialized successfully');
    } catch (e) {
      _logger.e('Failed to initialize Sentry', e);
    }
  }

  // Capturar error
  Future<void> captureError(
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, dynamic>? context,
  }) async {
    try {
      _logger.e('Error captured', error, stackTrace);
      
      if (!_isInitialized) {
        await initialize();
      }

      final scope = Scope();
      if (context != null) {
        scope.setExtra('context', context);
      }

      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
        scope: scope,
      );
    } catch (e) {
      _logger.e('Failed to capture error in Sentry', e);
    }
  }

  // Capturar mensaje
  Future<void> captureMessage(
    String message, {
    Map<String, dynamic>? context,
    SentryLevel level = SentryLevel.info,
  }) async {
    try {
      _logger.i(message, null, context);
      
      if (!_isInitialized) {
        await initialize();
      }

      final scope = Scope();
      if (context != null) {
        scope.setExtra('context', context);
      }

      await Sentry.captureMessage(
        message,
        level: level,
        scope: scope,
      );
    } catch (e) {
      _logger.e('Failed to capture message in Sentry', e);
    }
  }

  // Agregar breadcrumb
  Future<void> addBreadcrumb(
    String message, {
    Map<String, dynamic>? data,
  }) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      Sentry.addBreadcrumb(
        Breadcrumb(
          message: message,
          data: data,
          level: SentryLevel.info,
        ),
      );
    } catch (e) {
      _logger.e('Failed to add breadcrumb', e);
    }
  }

  // Establecer usuario
  Future<void> setUser(String? userId, {String? email, String? username}) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (userId != null) {
        await Sentry.configureScope((scope) {
          scope.setUser(SentryUser(
            id: userId,
            email: email,
            username: username,
          ));
        });
      } else {
        await Sentry.configureScope((scope) {
          scope.setUser(null);
        });
      }
    } catch (e) {
      _logger.e('Failed to set user in Sentry', e);
    }
  }

  // Limpiar usuario
  Future<void> clearUser() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      await Sentry.configureScope((scope) {
        scope.setUser(null);
      });
    } catch (e) {
      _logger.e('Failed to clear user in Sentry', e);
    }
  }
} 