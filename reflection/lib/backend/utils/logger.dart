import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;
import 'package:sentry_flutter/sentry_flutter.dart';

class Logger {
  final String _name;
  final _loggingInstance = logging.Logger('Logger');
  static bool _isInitialized = false;

  Logger(this._name) {
    if (!_isInitialized) {
      _initializeLogging();
    }
  }

  void _initializeLogging() {
    logging.Logger.root.level = logging.Level.ALL;
    logging.Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print('${record.level.name}: ${record.time}: ${record.message}');
        if (record.error != null) {
          print('Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          print('Stack trace: ${record.stackTrace}');
        }
      }
    });
    _isInitialized = true;
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _loggingInstance.info('[$_name] $message', error, stackTrace);
    if (error != null) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: message,
          category: 'info',
          level: SentryLevel.info,
        ),
      );
    }
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _loggingInstance.warning('[$_name] $message', error, stackTrace);
    if (error != null) {
      Sentry.addBreadcrumb(
        Breadcrumb(
          message: message,
          category: 'warning',
          level: SentryLevel.warning,
        ),
      );
    }
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _loggingInstance.severe('[$_name] $message', error, stackTrace);
    if (error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: message,
      );
    }
  }

  void severe(String message, [Object? error, StackTrace? stackTrace]) {
    _loggingInstance.severe('[$_name] $message', error, stackTrace);
    if (error != null) {
      Sentry.captureException(
        error,
        stackTrace: stackTrace,
        hint: message,
      );
    }
  }

  void debug(String message) {
    if (kDebugMode) {
      _loggingInstance.fine('[$_name] DEBUG: $message');
    }
  }

  void performance(String message, [Duration? duration]) {
    if (kDebugMode) {
      final durationStr = duration != null ? ' (${duration.inMilliseconds}ms)' : '';
      _loggingInstance.info('[$_name] PERFORMANCE: $message$durationStr');
    }
  }
} 