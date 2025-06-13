import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Reflection';
  static const String appVersion = '1.0.0';
  
  // API Endpoints
  static const String baseUrl = 'https://api.reflection.com';
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userProfileKey = 'user_profile';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);
  
  // Padding Values
  static const double smallPadding = 8.0;
  static const double mediumPadding = 16.0;
  static const double largePadding = 24.0;
  
  // Border Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  
  // Colors
  static const Color primaryColor = Colors.deepPurple;
  static const Color secondaryColor = Colors.purpleAccent;
  static const Color accentColor = Colors.amber;
  
  // Error Messages
  static const String genericError = 'Ha ocurrido un error. Por favor, inténtalo de nuevo.';
  static const String networkError = 'Error de conexión. Por favor, verifica tu conexión a internet.';
  static const String authError = 'Error de autenticación. Por favor, inicia sesión nuevamente.';
} 