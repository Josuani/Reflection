import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reflection/backend/utils/logger.dart';

class RewardsService {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger('RewardsService');

  // Recompensas por nivel
  static const Map<int, Map<String, dynamic>> LEVEL_REWARDS = {
    5: {
      'xp': 500,
      'stats': {'fuerza': 1},
      'achievement': '¡Primer paso!',
    },
    10: {
      'xp': 1000,
      'stats': {'destreza': 1},
      'achievement': '¡En camino!',
    },
    20: {
      'xp': 2000,
      'stats': {'inteligencia': 1},
      'achievement': '¡Experto!',
    },
    30: {
      'xp': 3000,
      'stats': {'vitalidad': 1},
      'achievement': '¡Maestro!',
    },
    50: {
      'xp': 5000,
      'stats': {'fuerza': 2, 'destreza': 2},
      'achievement': '¡Leyenda!',
    },
    100: {
      'xp': 10000,
      'stats': {'fuerza': 5, 'destreza': 5, 'inteligencia': 5, 'vitalidad': 5},
      'achievement': '¡Dios del Progreso!',
    },
  };

  // Recompensas por racha
  static const Map<int, Map<String, dynamic>> STREAK_REWARDS = {
    7: {
      'xp': 1000,
      'achievement': '¡Semana de Éxito!',
    },
    30: {
      'xp': 5000,
      'achievement': '¡Mes de Éxito!',
    },
    100: {
      'xp': 20000,
      'achievement': '¡Centenario!',
    },
    365: {
      'xp': 100000,
      'achievement': '¡Año de Éxito!',
    },
  };

  RewardsService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<Map<String, dynamic>> getLevelReward(int level) async {
    return LEVEL_REWARDS[level] ?? {};
  }

  Future<Map<String, dynamic>> getStreakReward(int streak) async {
    return STREAK_REWARDS[streak] ?? {};
  }

  Future<void> checkAndAwardLevelRewards(String userId, int newLevel) async {
    try {
      final reward = await getLevelReward(newLevel);
      if (reward.isNotEmpty) {
        await _firestore.collection('user_progress').doc(userId).update({
          'xp': FieldValue.increment(reward['xp'] ?? 0),
          'stats': reward['stats'] ?? {},
          'achievements': FieldValue.arrayUnion([reward['achievement']]),
        });
      }
    } catch (e, stackTrace) {
      _logger.error('Error awarding level rewards', e, stackTrace);
    }
  }

  Future<void> checkAndAwardStreakRewards(String userId, int newStreak) async {
    try {
      final reward = await getStreakReward(newStreak);
      if (reward.isNotEmpty) {
        await _firestore.collection('user_progress').doc(userId).update({
          'xp': FieldValue.increment(reward['xp'] ?? 0),
          'achievements': FieldValue.arrayUnion([reward['achievement']]),
        });
      }
    } catch (e, stackTrace) {
      _logger.error('Error awarding streak rewards', e, stackTrace);
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableAchievements(String userId) async {
    try {
      final doc = await _firestore.collection('user_progress').doc(userId).get();
      if (!doc.exists) return [];

      final data = doc.data()!;
      final currentLevel = data['level'] as int;
      final currentStreak = data['streak'] as int;
      final currentAchievements = List<String>.from(data['achievements'] ?? []);

      final availableAchievements = <Map<String, dynamic>>[];

      // Verificar logros por nivel
      for (final entry in LEVEL_REWARDS.entries) {
        if (entry.key <= currentLevel && !currentAchievements.contains(entry.value['achievement'])) {
          availableAchievements.add({
            'type': 'level',
            'requirement': entry.key,
            'reward': entry.value,
          });
        }
      }

      // Verificar logros por racha
      for (final entry in STREAK_REWARDS.entries) {
        if (entry.key <= currentStreak && !currentAchievements.contains(entry.value['achievement'])) {
          availableAchievements.add({
            'type': 'streak',
            'requirement': entry.key,
            'reward': entry.value,
          });
        }
      }

      return availableAchievements;
    } catch (e, stackTrace) {
      _logger.error('Error getting available achievements', e, stackTrace);
      return [];
    }
  }
} 