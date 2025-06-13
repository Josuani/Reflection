import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class L10n {
  static const List<Locale> supportedLocales = [
    Locale('es', ''), // Spanish
    Locale('en', ''), // English
  ];

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'es': {
      'app_name': 'Reflection',
      'error_initializing': 'Error al iniciar la aplicación',
      'try_again_later': 'Por favor, intenta nuevamente más tarde',
      'start': 'INICIAR',
      // Add more Spanish translations here
    },
    'en': {
      'app_name': 'Reflection',
      'error_initializing': 'Error initializing application',
      'try_again_later': 'Please try again later',
      'start': 'START',
      // Add more English translations here
    },
  };

  static String getString(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }
} 