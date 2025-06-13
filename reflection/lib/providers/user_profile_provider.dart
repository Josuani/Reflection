import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences.dart';
import 'package:reflection/backend/models/user_profile.dart';
import 'package:reflection/backend/services/local_cache_service.dart';
import 'package:reflection/backend/services/user_profile_service.dart';
import 'package:reflection/backend/services/rewards_service.dart';
import 'package:reflection/backend/services/daily_missions_service.dart';
import 'package:reflection/backend/services/progress_notification_service.dart';
import 'package:reflection/backend/services/local_progress_service.dart';
import 'package:reflection/backend/utils/logger.dart';

class UserProfileModel {
  final String? displayName;
  final String? avatarUrl;
  final int level;
  final int xp;
  final Map<String, int> stats;

  UserProfileModel({
    this.displayName,
    this.avatarUrl,
    this.level = 1,
    this.xp = 0,
    Map<String, int>? stats,
  }) : stats = stats ?? {'fuerza': 0, 'destreza': 0, 'inteligencia': 0, 'vitalidad': 0};
}

class UserProfileProvider extends ChangeNotifier {
  final UserProfileService _userProfileService;
  final RewardsService _rewardsService;
  final DailyMissionsService _dailyMissionsService;
  final ProgressNotificationService _notificationService;
  final LocalProgressService _localProgress;
  final Logger _logger = Logger('UserProfileProvider');

  UserProfile? _userProfile;
  bool _isLoading = false;
  bool _isOffline = false;
  String? _error;
  List<Map<String, dynamic>> _dailyMissions = [];
  List<Map<String, dynamic>> _notifications = [];

  UserProfileProvider({
    required UserProfileService userProfileService,
    required RewardsService rewardsService,
    required DailyMissionsService dailyMissionsService,
    required ProgressNotificationService notificationService,
    required LocalProgressService localProgress,
  })  : _userProfileService = userProfileService,
        _rewardsService = rewardsService,
        _dailyMissionsService = dailyMissionsService,
        _notificationService = notificationService,
        _localProgress = localProgress;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String? get error => _error;
  List<Map<String, dynamic>> get dailyMissions => _dailyMissions;
  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> loadUserProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Cargar datos locales primero
      final localProgress = _localProgress.getProgress();
      if (localProgress != null) {
        _userProfile = UserProfile.fromMap(localProgress);
        _dailyMissions = _localProgress.getDailyMissions();
        _notifications = _localProgress.getNotifications();
        notifyListeners();
      }

      // Verificar si necesitamos sincronizar
      if (_localProgress.needsSync()) {
        try {
          // Cargar desde el servidor
          final profile = await _userProfileService.getUserProfile();
          _userProfile = profile;
          _isOffline = false;

          // Guardar localmente
          await _localProgress.saveProgress(profile.toMap());

          // Cargar misiones diarias
          _dailyMissions = await _dailyMissionsService.getDailyMissions(profile.id);
          await _localProgress.saveDailyMissions(_dailyMissions);

          // Cargar notificaciones
          _notifications = await _notificationService.getNotifications(profile.id);
          await _localProgress.saveNotifications(_notifications);

          // Sincronizar cambios pendientes
          await _syncPendingChanges();
        } catch (e) {
          _isOffline = true;
          _logger.warning('Error loading from server, using local data', e);
        }
      }
    } catch (e, stackTrace) {
      _error = 'Error loading user profile';
      _logger.error('Error loading user profile', e, stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Guardar localmente primero
      await _localProgress.saveProgress(profile.toMap());
      _userProfile = profile;

      // Intentar actualizar en el servidor
      try {
        await _userProfileService.updateUserProfile(profile);
        _isOffline = false;
      } catch (e) {
        _isOffline = true;
        // Guardar cambio pendiente
        await _localProgress.savePendingChanges({
          'type': 'profile_update',
          'data': profile.toMap(),
        });
        _logger.warning('Error updating profile on server, saved to local storage', e);
      }
    } catch (e, stackTrace) {
      _error = 'Error updating user profile';
      _logger.error('Error updating user profile', e, stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExperience(int amount) async {
    if (_userProfile == null) return;

    try {
      final oldLevel = _userProfile!.level;
      final newProfile = _userProfile!.copyWith(
        experience: _userProfile!.experience + amount,
      );

      // Verificar si subió de nivel
      if (newProfile.level > oldLevel) {
        await _rewardsService.checkAndAwardLevelRewards(_userProfile!.id, newProfile.level);
        await _notificationService.notifyLevelUp(_userProfile!.id, newProfile.level);
      }

      await updateUserProfile(newProfile);
    } catch (e, stackTrace) {
      _logger.error('Error adding experience', e, stackTrace);
    }
  }

  Future<void> updateStreak() async {
    if (_userProfile == null) return;

    try {
      final oldStreak = _userProfile!.streak;
      final newProfile = _userProfile!.copyWith(
        streak: _userProfile!.streak + 1,
      );

      // Verificar si alcanzó un hito de racha
      if (newProfile.streak > oldStreak) {
        await _rewardsService.checkAndAwardStreakRewards(_userProfile!.id, newProfile.streak);
        await _notificationService.notifyStreakMilestone(_userProfile!.id, newProfile.streak);
      }

      await updateUserProfile(newProfile);
    } catch (e, stackTrace) {
      _logger.error('Error updating streak', e, stackTrace);
    }
  }

  Future<void> updateMissionProgress(String missionType, int progress) async {
    if (_userProfile == null) return;

    try {
      // Actualizar localmente
      _dailyMissions = _dailyMissions.map((mission) {
        if (mission['type'] == missionType) {
          return {
            ...mission,
            'progress': progress,
            'completed': progress >= mission['required'],
          };
        }
        return mission;
      }).toList();
      await _localProgress.saveDailyMissions(_dailyMissions);
      notifyListeners();

      // Intentar actualizar en el servidor
      try {
        await _dailyMissionsService.updateMissionProgress(
          _userProfile!.id,
          missionType,
          progress,
        );
        _isOffline = false;
      } catch (e) {
        _isOffline = true;
        // Guardar cambio pendiente
        await _localProgress.savePendingChanges({
          'type': 'mission_update',
          'data': {
            'missionType': missionType,
            'progress': progress,
          },
        });
        _logger.warning('Error updating mission on server, saved to local storage', e);
      }
    } catch (e, stackTrace) {
      _logger.error('Error updating mission progress', e, stackTrace);
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      // Actualizar localmente
      _notifications = _notifications.map((notification) {
        if (notification['id'] == notificationId) {
          return {...notification, 'read': true};
        }
        return notification;
      }).toList();
      await _localProgress.saveNotifications(_notifications);
      notifyListeners();

      // Intentar actualizar en el servidor
      try {
        await _notificationService.markNotificationAsRead(notificationId);
        _isOffline = false;
      } catch (e) {
        _isOffline = true;
        // Guardar cambio pendiente
        await _localProgress.savePendingChanges({
          'type': 'notification_read',
          'data': {'notificationId': notificationId},
        });
        _logger.warning('Error marking notification as read on server, saved to local storage', e);
      }
    } catch (e, stackTrace) {
      _logger.error('Error marking notification as read', e, stackTrace);
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    if (_userProfile == null) return;

    try {
      // Actualizar localmente
      _notifications = _notifications.map((notification) {
        return {...notification, 'read': true};
      }).toList();
      await _localProgress.saveNotifications(_notifications);
      notifyListeners();

      // Intentar actualizar en el servidor
      try {
        await _notificationService.markAllNotificationsAsRead(_userProfile!.id);
        _isOffline = false;
      } catch (e) {
        _isOffline = true;
        // Guardar cambio pendiente
        await _localProgress.savePendingChanges({
          'type': 'notifications_all_read',
          'data': {'userId': _userProfile!.id},
        });
        _logger.warning('Error marking all notifications as read on server, saved to local storage', e);
      }
    } catch (e, stackTrace) {
      _logger.error('Error marking all notifications as read', e, stackTrace);
    }
  }

  Future<void> syncPendingChanges() async {
    if (_userProfile == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final pendingChanges = _localProgress.getPendingChanges();
      for (final change in pendingChanges) {
        try {
          switch (change['type']) {
            case 'profile_update':
              await _userProfileService.updateUserProfile(
                UserProfile.fromMap(change['data']),
              );
              break;
            case 'mission_update':
              await _dailyMissionsService.updateMissionProgress(
                _userProfile!.id,
                change['data']['missionType'],
                change['data']['progress'],
              );
              break;
            case 'notification_read':
              await _notificationService.markNotificationAsRead(
                change['data']['notificationId'],
              );
              break;
            case 'notifications_all_read':
              await _notificationService.markAllNotificationsAsRead(
                change['data']['userId'],
              );
              break;
          }
        } catch (e) {
          _logger.error('Error syncing change: ${change['type']}', e);
          // Continuar con el siguiente cambio
          continue;
        }
      }

      // Limpiar cambios pendientes
      await _localProgress.clearPendingChanges();
      
      // Recargar datos
      await loadUserProfile();
      
      _isOffline = false;
    } catch (e, stackTrace) {
      _error = 'Error syncing changes';
      _logger.error('Error syncing pending changes', e, stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _syncPendingChanges() async {
    if (!_isOffline) return;
    await syncPendingChanges();
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _localProgress.clearProgress();
      _userProfile = null;
      _isOffline = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error signing out: $e';
      notifyListeners();
    }
  }
} 