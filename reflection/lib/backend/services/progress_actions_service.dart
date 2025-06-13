import 'package:reflection/backend/services/local_progress_service.dart';
import 'package:reflection/backend/utils/logger.dart';

class ProgressActionsService {
  final LocalProgressService _localProgress;
  final Logger _logger = Logger('ProgressActionsService');

  // Recompensas por acción
  static const Map<String, Map<String, dynamic>> ACTION_REWARDS = {
    'reflection_complete': {
      'xp': 50,
      'stats': {'inteligencia': 1},
      'mission_type': 'reflection',
    },
    'reflection_share': {
      'xp': 25,
      'stats': {'vitalidad': 1},
      'mission_type': 'social',
    },
    'reflection_like': {
      'xp': 10,
      'stats': {'destreza': 1},
    },
    'reflection_comment': {
      'xp': 15,
      'stats': {'fuerza': 1},
    },
    'daily_login': {
      'xp': 20,
      'stats': {'vitalidad': 1},
      'mission_type': 'streak',
    },
    'achievement_unlock': {
      'xp': 100,
      'stats': {'inteligencia': 1, 'fuerza': 1},
      'mission_type': 'achievement',
    },
  };

  ProgressActionsService(this._localProgress);

  Future<void> recordAction(String actionType, {Map<String, dynamic>? additionalData}) async {
    try {
      final reward = ACTION_REWARDS[actionType];
      if (reward == null) {
        _logger.warning('Unknown action type: $actionType');
        return;
      }

      // Obtener progreso actual
      final progress = _localProgress.getProgress();
      if (progress == null) {
        _logger.warning('No progress data found');
        return;
      }

      // Actualizar XP
      final currentXP = progress['experience'] as int;
      final newXP = currentXP + (reward['xp'] as int);
      progress['experience'] = newXP;

      // Actualizar estadísticas
      final stats = Map<String, int>.from(progress['stats'] as Map<String, dynamic>);
      if (reward['stats'] != null) {
        (reward['stats'] as Map<String, dynamic>).forEach((stat, value) {
          stats[stat] = (stats[stat] ?? 0) + (value as int);
        });
      }
      progress['stats'] = stats;

      // Verificar si subió de nivel
      final oldLevel = progress['level'] as int;
      final newLevel = (newXP ~/ 100) + 1;
      if (newLevel > oldLevel) {
        progress['level'] = newLevel;
        progress['level_up'] = true;
      }

      // Actualizar misiones diarias si corresponde
      if (reward['mission_type'] != null) {
        final missions = _localProgress.getDailyMissions();
        final updatedMissions = missions.map((mission) {
          if (mission['type'] == reward['mission_type']) {
            return {
              ...mission,
              'progress': (mission['progress'] as int) + 1,
              'completed': (mission['progress'] as int) + 1 >= (mission['required'] as int),
            };
          }
          return mission;
        }).toList();
        await _localProgress.saveDailyMissions(updatedMissions);
      }

      // Guardar progreso actualizado
      await _localProgress.saveProgress(progress);

      // Guardar cambio pendiente para sincronización
      await _localProgress.savePendingChanges({
        'type': 'progress_action',
        'data': {
          'action': actionType,
          'reward': reward,
          'additional_data': additionalData,
          'timestamp': DateTime.now().toIso8601String(),
        },
      });

      _logger.info('Action recorded: $actionType');
    } catch (e, stackTrace) {
      _logger.error('Error recording action: $actionType', e, stackTrace);
    }
  }

  // Métodos específicos para diferentes tipos de acciones
  Future<void> recordReflectionComplete({
    required String reflectionId,
    required int wordCount,
    required int timeSpent,
  }) async {
    await recordAction('reflection_complete', additionalData: {
      'reflection_id': reflectionId,
      'word_count': wordCount,
      'time_spent': timeSpent,
    });
  }

  Future<void> recordReflectionShare({
    required String reflectionId,
    required String platform,
  }) async {
    await recordAction('reflection_share', additionalData: {
      'reflection_id': reflectionId,
      'platform': platform,
    });
  }

  Future<void> recordReflectionLike({
    required String reflectionId,
    required String likedByUserId,
  }) async {
    await recordAction('reflection_like', additionalData: {
      'reflection_id': reflectionId,
      'liked_by': likedByUserId,
    });
  }

  Future<void> recordReflectionComment({
    required String reflectionId,
    required String commentId,
    required int wordCount,
  }) async {
    await recordAction('reflection_comment', additionalData: {
      'reflection_id': reflectionId,
      'comment_id': commentId,
      'word_count': wordCount,
    });
  }

  Future<void> recordDailyLogin() async {
    await recordAction('daily_login');
  }

  Future<void> recordAchievementUnlock({
    required String achievementId,
    required String achievementName,
  }) async {
    await recordAction('achievement_unlock', additionalData: {
      'achievement_id': achievementId,
      'achievement_name': achievementName,
    });
  }

  // Método para obtener estadísticas de acciones
  Map<String, dynamic> getActionStats() {
    try {
      final progress = _localProgress.getProgress();
      if (progress == null) return {};

      return {
        'total_xp': progress['experience'] as int,
        'current_level': progress['level'] as int,
        'stats': progress['stats'] as Map<String, dynamic>,
        'streak': progress['streak'] as int,
        'achievements': progress['achievements'] as List<dynamic>,
      };
    } catch (e, stackTrace) {
      _logger.error('Error getting action stats', e, stackTrace);
      return {};
    }
  }
} 