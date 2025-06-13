import 'dart:convert';
import 'package:shared_preferences.dart';
import 'package:reflection/backend/models/user_profile.dart';
import 'package:reflection/backend/utils/logger.dart';

class LocalCacheService {
  static const String _userProfileKey = 'user_profile';
  static const String _lastSyncKey = 'last_sync';
  static const String _pendingChangesKey = 'pending_changes';
  static const int _maxCacheSize = 5 * 1024 * 1024; // 5MB
  static const int _maxPendingChanges = 100;

  final SharedPreferences _prefs;
  final Logger _logger = Logger('LocalCacheService');

  LocalCacheService(this._prefs);

  // Guardar perfil de usuario localmente
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final profileJson = jsonEncode(profile.toMap());
      if (profileJson.length > _maxCacheSize) {
        _logger.warning('Profile data exceeds maximum cache size');
        return;
      }
      await _prefs.setString(_userProfileKey, profileJson);
      await _prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e, stackTrace) {
      _logger.error('Error saving user profile', e, stackTrace);
      rethrow;
    }
  }

  // Obtener perfil de usuario del caché local
  UserProfile? getUserProfile() {
    try {
      final profileJson = _prefs.getString(_userProfileKey);
      if (profileJson == null) return null;
      
      return UserProfile.fromMap(jsonDecode(profileJson));
    } catch (e, stackTrace) {
      _logger.error('Error parsing cached user profile', e, stackTrace);
      return null;
    }
  }

  // Guardar cambios pendientes
  Future<void> savePendingChanges(Map<String, dynamic> changes) async {
    try {
      final pendingChanges = getPendingChanges();
      if (pendingChanges.length >= _maxPendingChanges) {
        _logger.warning('Maximum pending changes limit reached, removing oldest changes');
        pendingChanges.removeAt(0);
      }
      pendingChanges.add(changes);
      await _prefs.setString(_pendingChangesKey, jsonEncode(pendingChanges));
    } catch (e, stackTrace) {
      _logger.error('Error saving pending changes', e, stackTrace);
      rethrow;
    }
  }

  // Obtener cambios pendientes
  List<Map<String, dynamic>> getPendingChanges() {
    try {
      final changesJson = _prefs.getString(_pendingChangesKey);
      if (changesJson == null) return [];
      
      final List<dynamic> decoded = jsonDecode(changesJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      _logger.error('Error parsing pending changes', e, stackTrace);
      return [];
    }
  }

  // Limpiar cambios pendientes
  Future<void> clearPendingChanges() async {
    try {
      await _prefs.remove(_pendingChangesKey);
    } catch (e, stackTrace) {
      _logger.error('Error clearing pending changes', e, stackTrace);
      rethrow;
    }
  }

  // Obtener última sincronización
  DateTime? getLastSync() {
    try {
      final lastSyncStr = _prefs.getString(_lastSyncKey);
      if (lastSyncStr == null) return null;
      return DateTime.parse(lastSyncStr);
    } catch (e, stackTrace) {
      _logger.error('Error getting last sync time', e, stackTrace);
      return null;
    }
  }

  // Limpiar caché antiguo
  Future<void> clearOldCache() async {
    try {
      final lastSync = getLastSync();
      if (lastSync != null && DateTime.now().difference(lastSync).inDays > 7) {
        await _prefs.remove(_userProfileKey);
        await _prefs.remove(_lastSyncKey);
        _logger.info('Cleared old cache data');
      }
    } catch (e, stackTrace) {
      _logger.error('Error clearing old cache', e, stackTrace);
    }
  }

  // Verificar tamaño del caché
  Future<bool> isCacheSizeExceeded() async {
    try {
      int totalSize = 0;
      for (final key in _prefs.getKeys()) {
        final value = _prefs.getString(key);
        if (value != null) {
          totalSize += value.length;
        }
      }
      return totalSize > _maxCacheSize;
    } catch (e, stackTrace) {
      _logger.error('Error checking cache size', e, stackTrace);
      return false;
    }
  }
} 