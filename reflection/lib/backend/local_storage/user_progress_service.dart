import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProgressService {
  static const String _progressKey = 'user_progress';
  static const String _preferencesKey = 'user_preferences';
  
  // Estructura por defecto para el progreso del usuario
  static Map<String, dynamic> get defaultProgress => {
    'level': 1,
    'xp': 0,
    'xpToNextLevel': 100,
    'streak': 0,
    'missions': [],
    'achievements': [],
    'lastUpdated': DateTime.now().toIso8601String(),
  };

  // Estructura por defecto para las preferencias del usuario
  static Map<String, dynamic> get defaultPreferences => {
    'theme': 'light',
    'language': 'es',
    'soundEnabled': true,
    'notificationsEnabled': true,
  };

  /// Guarda el progreso del usuario
  static Future<void> saveProgress(Map<String, dynamic> progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(progress));
  }

  /// Carga el progreso del usuario
  static Future<Map<String, dynamic>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_progressKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return defaultProgress;
  }

  /// Guarda las preferencias del usuario
  static Future<void> savePreferences(Map<String, dynamic> preferences) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferencesKey, jsonEncode(preferences));
  }

  /// Carga las preferencias del usuario
  static Future<Map<String, dynamic>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_preferencesKey);
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return defaultPreferences;
  }

  /// Actualiza el progreso del usuario
  static Future<void> updateProgress({
    int? level,
    int? xp,
    int? xpToNextLevel,
    int? streak,
    List<Map<String, dynamic>>? missions,
    List<Map<String, dynamic>>? achievements,
  }) async {
    final currentProgress = await loadProgress();
    
    if (level != null) currentProgress['level'] = level;
    if (xp != null) currentProgress['xp'] = xp;
    if (xpToNextLevel != null) currentProgress['xpToNextLevel'] = xpToNextLevel;
    if (streak != null) currentProgress['streak'] = streak;
    if (missions != null) currentProgress['missions'] = missions;
    if (achievements != null) currentProgress['achievements'] = achievements;
    
    currentProgress['lastUpdated'] = DateTime.now().toIso8601String();
    
    await saveProgress(currentProgress);
  }

  /// Actualiza las preferencias del usuario
  static Future<void> updatePreferences({
    String? theme,
    String? language,
    bool? soundEnabled,
    bool? notificationsEnabled,
  }) async {
    final currentPreferences = await loadPreferences();
    
    if (theme != null) currentPreferences['theme'] = theme;
    if (language != null) currentPreferences['language'] = language;
    if (soundEnabled != null) currentPreferences['soundEnabled'] = soundEnabled;
    if (notificationsEnabled != null) {
      currentPreferences['notificationsEnabled'] = notificationsEnabled;
    }
    
    await savePreferences(currentPreferences);
  }

  /// Resetea el progreso del usuario a los valores por defecto
  static Future<void> resetProgress() async {
    await saveProgress(defaultProgress);
  }

  /// Resetea las preferencias del usuario a los valores por defecto
  static Future<void> resetPreferences() async {
    await savePreferences(defaultPreferences);
  }

  /// Borra todos los datos del usuario
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_progressKey);
    await prefs.remove(_preferencesKey);
  }
} 