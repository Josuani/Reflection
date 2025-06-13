import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflection/backend/services/error_monitoring_service.dart';
import 'package:logger/logger.dart';

class LocalProgressService {
  static const String _progressKey = 'user_progress';
  final ErrorMonitoringService _errorService;
  final Logger _logger = Logger('LocalProgressService');

  // Claves para SharedPreferences
  static const String _missionsKey = 'daily_missions';
  static const String _notificationsKey = 'notifications';
  static const String _lastSyncKey = 'last_sync';
  static const String _pendingChangesKey = 'pending_changes';

  LocalProgressService(this._errorService);

  Future<Map<String, dynamic>?> getProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString(_progressKey);
      
      if (progressJson == null) return null;
      
      final progress = json.decode(progressJson) as Map<String, dynamic>;
      return progress;
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      return null;
    }
  }

  Future<void> saveProgress(Map<String, dynamic> progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Asegurarse de que lastUpdated esté presente
      final updatedProgress = Map<String, dynamic>.from(progress);
      updatedProgress['lastUpdated'] = DateTime.now().toIso8601String();
      
      await prefs.setString(_progressKey, json.encode(updatedProgress));
      _logger.i('Progress saved successfully');
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> clearProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_progressKey);
      _logger.i('Progress cleared successfully');
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateProgress(Map<String, dynamic> updates) async {
    try {
      final currentProgress = await getProgress() ?? {};
      final updatedProgress = Map<String, dynamic>.from(currentProgress);
      updatedProgress.addAll(updates);
      updatedProgress['lastUpdated'] = DateTime.now().toIso8601String();
      
      await saveProgress(updatedProgress);
      _logger.i('Progress updated successfully');
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  // Guardar misiones diarias
  Future<void> saveDailyMissions(List<Map<String, dynamic>> missions) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_missionsKey, jsonEncode(missions));
    } catch (e, stackTrace) {
      _logger.error('Error saving daily missions locally', e, stackTrace);
    }
  }

  // Cargar misiones diarias
  Future<List<Map<String, dynamic>>> getDailyMissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final missionsStr = prefs.getString(_missionsKey);
      if (missionsStr == null) return [];
      final List<dynamic> missions = jsonDecode(missionsStr);
      return missions.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      _logger.error('Error loading daily missions locally', e, stackTrace);
      return [];
    }
  }

  // Guardar notificaciones
  Future<void> saveNotifications(List<Map<String, dynamic>> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_notificationsKey, jsonEncode(notifications));
    } catch (e, stackTrace) {
      _logger.error('Error saving notifications locally', e, stackTrace);
    }
  }

  // Cargar notificaciones
  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsStr = prefs.getString(_notificationsKey);
      if (notificationsStr == null) return [];
      final List<dynamic> notifications = jsonDecode(notificationsStr);
      return notifications.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      _logger.error('Error loading notifications locally', e, stackTrace);
      return [];
    }
  }

  // Guardar cambios pendientes
  Future<void> savePendingChanges(Map<String, dynamic> change) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingChanges = await getPendingChanges();
      pendingChanges.add({
        ...change,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await prefs.setString(_pendingChangesKey, jsonEncode(pendingChanges));
    } catch (e, stackTrace) {
      _logger.error('Error saving pending changes', e, stackTrace);
    }
  }

  // Obtener cambios pendientes
  Future<List<Map<String, dynamic>>> getPendingChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final changesStr = prefs.getString(_pendingChangesKey);
      if (changesStr == null) return [];
      final List<dynamic> changes = jsonDecode(changesStr);
      return changes.cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      _logger.error('Error loading pending changes', e, stackTrace);
      return [];
    }
  }

  // Limpiar cambios pendientes
  Future<void> clearPendingChanges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingChangesKey);
    } catch (e, stackTrace) {
      _logger.error('Error clearing pending changes', e, stackTrace);
    }
  }

  // Actualizar última sincronización
  Future<void> _updateLastSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
    } catch (e, stackTrace) {
      _logger.error('Error updating last sync timestamp', e, stackTrace);
    }
  }

  // Obtener última sincronización
  Future<DateTime?> getLastSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastSyncStr = prefs.getString(_lastSyncKey);
      if (lastSyncStr == null) return null;
      return DateTime.parse(lastSyncStr);
    } catch (e, stackTrace) {
      _logger.error('Error getting last sync timestamp', e, stackTrace);
      return null;
    }
  }

  // Verificar si hay cambios pendientes
  Future<bool> hasPendingChanges() async {
    final changes = await getPendingChanges();
    return changes.isNotEmpty;
  }

  // Verificar si necesita sincronización
  Future<bool> needsSync() async {
    final lastSync = await getLastSync();
    if (lastSync == null) return true;
    
    // Sincronizar si han pasado más de 24 horas o hay cambios pendientes
    final hasChanges = await hasPendingChanges();
    return DateTime.now().difference(lastSync).inHours >= 24 || hasChanges;
  }

  // Limpiar todos los datos
  Future<void> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_progressKey);
      await prefs.remove(_missionsKey);
      await prefs.remove(_notificationsKey);
      await prefs.remove(_lastSyncKey);
      await prefs.remove(_pendingChangesKey);
    } catch (e, stackTrace) {
      _logger.error('Error clearing all data', e, stackTrace);
    }
  }
} 