import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:flutter/foundation.dart';

class SentryConfig {
  static const String dsn = 'TU_DSN_DE_SENTRY'; // Reemplazar con tu DSN real
  static const double tracesSampleRate = 1.0;
  static const String environment = kDebugMode ? 'development' : 'production';
  static const String release = '1.0.0';

  static Future<void> initialize() async {
    try {
      await SentryFlutter.init(
        (options) {
          options.dsn = dsn;
          options.tracesSampleRate = tracesSampleRate;
          options.environment = environment;
          options.release = release;
          options.enableAutoSessionTracking = true;
          options.attachStacktrace = true;
          options.debug = kDebugMode;
          options.beforeSend = (event, {hint}) {
            // Filtrar eventos de desarrollo si no estamos en modo debug
            if (!kDebugMode && environment == 'development') {
              return null;
            }
            return event;
          };
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Error initializing Sentry: $e\n$stackTrace');
      // No relanzamos el error para evitar que la app falle si Sentry no está disponible
    }
  }

  static Future<void> captureException(
    dynamic exception,
    dynamic stackTrace, {
    Map<String, dynamic>? extra,
  }) async {
    try {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          if (extra != null) {
            scope.setExtras(extra);
          }
        },
      );
    } catch (e) {
      debugPrint('Error capturing exception in Sentry: $e');
    }
  }
} 