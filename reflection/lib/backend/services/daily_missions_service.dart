import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reflection/backend/utils/logger.dart';

class DailyMissionsService {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger('DailyMissionsService');

  // Tipos de misiones diarias
  static const List<Map<String, dynamic>> MISSION_TYPES = [
    {
      'type': 'reflection',
      'description': 'Completa una reflexión',
      'xp': 100,
      'stats': {'inteligencia': 1},
    },
    {
      'type': 'streak',
      'description': 'Mantén tu racha',
      'xp': 50,
      'stats': {'fuerza': 1},
    },
    {
      'type': 'achievement',
      'description': 'Desbloquea un logro',
      'xp': 200,
      'stats': {'destreza': 1},
    },
    {
      'type': 'social',
      'description': 'Comparte una reflexión',
      'xp': 150,
      'stats': {'vitalidad': 1},
    },
  ];

  DailyMissionsService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<List<Map<String, dynamic>>> generateDailyMissions(String userId) async {
    try {
      final missions = <Map<String, dynamic>>[];
      final random = DateTime.now().millisecondsSinceEpoch % MISSION_TYPES.length;
      
      // Seleccionar 3 misiones aleatorias
      for (var i = 0; i < 3; i++) {
        final missionType = MISSION_TYPES[(random + i) % MISSION_TYPES.length];
        missions.add({
          ...missionType,
          'completed': false,
          'progress': 0,
          'required': 1,
        });
      }

      // Guardar las misiones en Firestore
      await _firestore.collection('user_progress').doc(userId).update({
        'daily_missions': missions,
        'daily_missions_reset': DateTime.now().toIso8601String(),
      });

      return missions;
    } catch (e, stackTrace) {
      _logger.error('Error generating daily missions', e, stackTrace);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDailyMissions(String userId) async {
    try {
      final doc = await _firestore.collection('user_progress').doc(userId).get();
      if (!doc.exists) return [];

      final data = doc.data()!;
      final missions = List<Map<String, dynamic>>.from(data['daily_missions'] ?? []);
      final lastReset = DateTime.parse(data['daily_missions_reset'] ?? DateTime.now().toIso8601String());

      // Verificar si necesitamos resetear las misiones
      if (DateTime.now().difference(lastReset).inDays >= 1) {
        return generateDailyMissions(userId);
      }

      return missions;
    } catch (e, stackTrace) {
      _logger.error('Error getting daily missions', e, stackTrace);
      return [];
    }
  }

  Future<void> updateMissionProgress(
    String userId,
    String missionType,
    int progress,
  ) async {
    try {
      final missions = await getDailyMissions(userId);
      final updatedMissions = missions.map((mission) {
        if (mission['type'] == missionType) {
          return {
            ...mission,
            'progress': progress,
            'completed': progress >= mission['required'],
          };
        }
        return mission;
      }).toList();

      await _firestore.collection('user_progress').doc(userId).update({
        'daily_missions': updatedMissions,
      });

      // Verificar si todas las misiones están completadas
      final allCompleted = updatedMissions.every((mission) => mission['completed']);
      if (allCompleted) {
        await _awardDailyCompletionRewards(userId);
      }
    } catch (e, stackTrace) {
      _logger.error('Error updating mission progress', e, stackTrace);
    }
  }

  Future<void> _awardDailyCompletionRewards(String userId) async {
    try {
      await _firestore.collection('user_progress').doc(userId).update({
        'xp': FieldValue.increment(500),
        'stats': {
          'fuerza': FieldValue.increment(1),
          'destreza': FieldValue.increment(1),
          'inteligencia': FieldValue.increment(1),
          'vitalidad': FieldValue.increment(1),
        },
        'achievements': FieldValue.arrayUnion(['¡Misiones Diarias Completadas!']),
      });
    } catch (e, stackTrace) {
      _logger.error('Error awarding daily completion rewards', e, stackTrace);
    }
  }
} 