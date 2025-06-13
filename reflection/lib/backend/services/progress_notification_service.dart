import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reflection/backend/utils/logger.dart';

class ProgressNotificationService {
  final FirebaseFirestore _firestore;
  final Logger _logger = Logger('ProgressNotificationService');

  ProgressNotificationService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Future<void> notifyLevelUp(String userId, int newLevel) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': 'level_up',
        'title': '¡Nivel Alcanzado!',
        'message': '¡Felicidades! Has alcanzado el nivel $newLevel',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'data': {
          'level': newLevel,
        },
      });
    } catch (e, stackTrace) {
      _logger.error('Error notifying level up', e, stackTrace);
    }
  }

  Future<void> notifyAchievementUnlocked(String userId, String achievement) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': 'achievement',
        'title': '¡Logro Desbloqueado!',
        'message': 'Has desbloqueado el logro: $achievement',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'data': {
          'achievement': achievement,
        },
      });
    } catch (e, stackTrace) {
      _logger.error('Error notifying achievement unlocked', e, stackTrace);
    }
  }

  Future<void> notifyStreakMilestone(String userId, int streak) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': 'streak',
        'title': '¡Racha Alcanzada!',
        'message': 'Has mantenido tu racha por $streak días',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'data': {
          'streak': streak,
        },
      });
    } catch (e, stackTrace) {
      _logger.error('Error notifying streak milestone', e, stackTrace);
    }
  }

  Future<void> notifyDailyMissionsCompleted(String userId) async {
    try {
      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': 'daily_missions',
        'title': '¡Misiones Diarias Completadas!',
        'message': 'Has completado todas tus misiones diarias',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'data': {
          'type': 'daily_missions',
        },
      });
    } catch (e, stackTrace) {
      _logger.error('Error notifying daily missions completed', e, stackTrace);
    }
  }

  Future<void> notifyStatsIncreased(String userId, Map<String, int> stats) async {
    try {
      final increasedStats = stats.entries
          .where((entry) => entry.value > 0)
          .map((entry) => '${entry.key}: +${entry.value}')
          .join(', ');

      await _firestore.collection('notifications').add({
        'userId': userId,
        'type': 'stats',
        'title': '¡Estadísticas Mejoradas!',
        'message': 'Tus estadísticas han aumentado: $increasedStats',
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'data': {
          'stats': stats,
        },
      });
    } catch (e, stackTrace) {
      _logger.error('Error notifying stats increased', e, stackTrace);
    }
  }

  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e, stackTrace) {
      _logger.error('Error getting notifications', e, stackTrace);
      return [];
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'read': true,
      });
    } catch (e, stackTrace) {
      _logger.error('Error marking notification as read', e, stackTrace);
    }
  }

  Future<void> markAllNotificationsAsRead(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('read', isEqualTo: false)
          .get();

      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.update(doc.reference, {'read': true});
      }
      await batch.commit();
    } catch (e, stackTrace) {
      _logger.error('Error marking all notifications as read', e, stackTrace);
    }
  }
} 