import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reflection/backend/utils/logger.dart';
import 'package:reflection/backend/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProgressService {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger('UserProgressService');
  final SharedPreferences _prefs;

  // Constantes para el sistema de niveles
  static const int BASE_XP = 100;
  static const double XP_MULTIPLIER = 1.5;

  // Claves para SharedPreferences
  static const String _progressKey = 'user_progress';
  static const String _lastSyncKey = 'last_sync';

  UserProgressService({
    required FirebaseFirestore firestore,
    required SharedPreferences prefs,
  })  : _firestore = firestore,
        _prefs = prefs;

  // Cargar progreso (prioriza local)
  Future<Map<String, dynamic>> loadUserProgress(String userId) async {
    try {
      // Primero intentar cargar de local
      final localProgress = _getLocalProgress();
      if (localProgress != null) {
        return localProgress;
      }

      // Si no hay datos locales, intentar cargar de Firebase
      if (userId != 'local_user') {
        final doc = await _firestore.collection('user_progress').doc(userId).get();
        if (doc.exists) {
          final data = doc.data()!;
          final progress = _validateProgressData(data);
          // Guardar en local para futuras consultas
          await _saveLocalProgress(progress);
          return progress;
        }
      }

      // Si no hay datos en ningún lado, crear progreso por defecto
      return _getDefaultProgress();
    } catch (e, stackTrace) {
      _logger.error('Error loading user progress', e, stackTrace);
      return _getDefaultProgress();
    }
  }

  // Guardar progreso (prioriza local)
  Future<void> saveUserProgress(String userId, Map<String, dynamic> progress) async {
    try {
      // Validar y guardar en local primero
      final validatedProgress = _validateProgressData(progress);
      await _saveLocalProgress(validatedProgress);

      // Solo guardar en Firebase si es un usuario autenticado y han pasado más de 24 horas
      if (userId != 'local_user' && _shouldSyncWithFirebase()) {
        await _firestore.collection('user_progress').doc(userId).set({
          'level': validatedProgress['level'],
          'xp': validatedProgress['xp'],
          'streak': validatedProgress['streak'],
          'achievements': validatedProgress['achievements'],
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        await _updateLastSync();
      }
    } catch (e, stackTrace) {
      _logger.error('Error saving user progress', e, stackTrace);
      rethrow;
    }
  }

  // Actualizar progreso (prioriza local)
  Future<void> updateUserProgress(String userId, Map<String, dynamic> updates) async {
    try {
      // Cargar progreso actual
      final currentProgress = await loadUserProgress(userId);
      final updatedProgress = {...currentProgress, ...updates};
      
      // Guardar actualización
      await saveUserProgress(userId, updatedProgress);
    } catch (e, stackTrace) {
      _logger.error('Error updating user progress', e, stackTrace);
      rethrow;
    }
  }

  // Métodos de almacenamiento local
  Future<void> _saveLocalProgress(Map<String, dynamic> progress) async {
    await _prefs.setString(_progressKey, jsonEncode(progress));
  }

  Map<String, dynamic>? _getLocalProgress() {
    final progressStr = _prefs.getString(_progressKey);
    if (progressStr == null) return null;
    try {
      return jsonDecode(progressStr) as Map<String, dynamic>;
    } catch (e) {
      _logger.error('Error parsing local progress', e);
      return null;
    }
  }

  Future<void> _updateLastSync() async {
    await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  bool _shouldSyncWithFirebase() {
    final lastSyncStr = _prefs.getString(_lastSyncKey);
    if (lastSyncStr == null) return true;
    
    final lastSync = DateTime.parse(lastSyncStr);
    return DateTime.now().difference(lastSync).inHours >= 24;
  }

  Map<String, dynamic> _getDefaultProgress() {
    return {
      'level': 1,
      'xp': 0,
      'streak': 0,
      'lastUpdated': DateTime.now().toIso8601String(),
      'achievements': [],
      'missionsCompleted': 0,
    };
  }

  Map<String, dynamic> _validateProgressData(Map<String, dynamic> data) {
    return {
      'level': (data['level'] as int?)?.clamp(1, 100) ?? 1,
      'xp': (data['xp'] as int?)?.clamp(0, 999999) ?? 0,
      'streak': (data['streak'] as int?)?.clamp(0, 999) ?? 0,
      'lastUpdated': data['lastUpdated'] ?? DateTime.now().toIso8601String(),
      'achievements': List<String>.from(data['achievements'] ?? []),
      'missionsCompleted': (data['missionsCompleted'] as int?)?.clamp(0, 999999) ?? 0,
    };
  }

  Future<void> addExperience(String userId, int xpAmount) async {
    try {
      final currentProgress = await loadUserProgress(userId);
      int currentXp = currentProgress['xp'] as int;
      int currentLevel = currentProgress['level'] as int;
      
      currentXp += xpAmount;
      
      // Calcular si el usuario sube de nivel
      while (currentXp >= _getRequiredXpForLevel(currentLevel)) {
        currentXp -= _getRequiredXpForLevel(currentLevel);
        currentLevel++;
      }

      await updateUserProgress(userId, {
        'xp': currentXp,
        'level': currentLevel,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e, stackTrace) {
      _logger.error('Error adding experience', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateStreak(String userId) async {
    try {
      final currentProgress = await loadUserProgress(userId);
      final lastUpdated = currentProgress['lastUpdated'] as Timestamp?;
      final currentStreak = currentProgress['streak'] as int;
      
      if (lastUpdated != null) {
        final lastUpdateDate = lastUpdated.toDate();
        final now = DateTime.now();
        final difference = now.difference(lastUpdateDate).inDays;

        if (difference == 1) {
          // El usuario mantiene su racha
          await updateUserProgress(userId, {
            'streak': currentStreak + 1,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        } else if (difference > 1) {
          // El usuario pierde su racha
          await updateUserProgress(userId, {
            'streak': 1,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e, stackTrace) {
      _logger.error('Error updating streak', e, stackTrace);
      rethrow;
    }
  }

  int _getRequiredXpForLevel(int level) {
    return (BASE_XP * (level * XP_MULTIPLIER)).round();
  }

  Future<void> syncProgressWithProfile(UserProfile profile) async {
    try {
      if (profile.id == null) {
        throw Exception('Profile ID cannot be null');
      }
      
      final progress = await loadUserProgress(profile.id!);
      final updatedProfile = profile.copyWith(
        level: progress['level'] as int,
        xp: progress['xp'] as int,
        streak: progress['streak'] as int,
        achievements: List<String>.from(progress['achievements'] ?? []),
        missionsCompleted: progress['missionsCompleted'] as int,
      );
      
      if (updatedProfile.validate()) {
        await _firestore.collection('user_profiles').doc(profile.id).update(updatedProfile.toMap());
      }
    } catch (e, stackTrace) {
      _logger.error('Error syncing progress with profile', e, stackTrace);
      rethrow;
    }
  }
} 