import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reflection/backend/services/error_monitoring_service.dart';
import 'package:reflection/backend/services/local_progress_service.dart';
import 'package:reflection/constants/constants.dart';
import 'package:logger/logger.dart';

class SyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalProgressService _localProgressService;
  final ErrorMonitoringService _errorService;
  final Logger _logger = Logger('SyncService');
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  int _retryCount = 0;

  SyncService(this._localProgressService, this._errorService);

  Future<void> startSync() async {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(Constants.syncInterval, (_) => sync());
    await sync(); // Sincronización inicial
  }

  Future<void> stopSync() async {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final local = await _localProgressService.getProgress();
      if (local == null) {
        await _downloadFromServer();
        return;
      }

      final remote = await _getRemoteProgress();
      if (remote == null) {
        await _uploadToServer(local);
        return;
      }

      final localTimestamp = local['lastUpdated'] as String?;
      final remoteTimestamp = remote['lastUpdated'] as String?;

      if (localTimestamp == null || remoteTimestamp == null) {
        await _handleConflict(local, remote);
        return;
      }

      final localDate = DateTime.parse(localTimestamp);
      final remoteDate = DateTime.parse(remoteTimestamp);

      if (localDate.isAfter(remoteDate)) {
        await _uploadToServer(local);
      } else if (remoteDate.isAfter(localDate)) {
        await _downloadFromServer();
      }
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      await _handleSyncError();
    } finally {
      _isSyncing = false;
    }
  }

  Future<Map<String, dynamic>?> _getRemoteProgress() async {
    try {
      final doc = await _firestore
          .collection('progress')
          .doc(Constants.currentUserId)
          .get();

      return doc.data();
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      return null;
    }
  }

  Future<void> _uploadToServer(Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection('progress')
          .doc(Constants.currentUserId)
          .set(data);
      
      _retryCount = 0;
      _logger.i('Progress uploaded successfully');
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> _downloadFromServer() async {
    try {
      final remote = await _getRemoteProgress();
      if (remote != null) {
        await _localProgressService.saveProgress(remote);
        _retryCount = 0;
        _logger.i('Progress downloaded successfully');
      }
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> _handleConflict(Map<String, dynamic>? local, Map<String, dynamic>? remote) async {
    _logger.w('Conflict detected between local and remote data');
    
    // Por ahora, preferimos los datos locales
    if (local != null) {
      await _uploadToServer(local);
    } else if (remote != null) {
      await _downloadFromServer();
    }
  }

  Future<void> _handleSyncError() async {
    _retryCount++;
    
    if (_retryCount <= Constants.maxRetryAttempts) {
      _logger.w('Retrying sync in ${Constants.retryDelay.inSeconds} seconds (Attempt $_retryCount)');
      await Future.delayed(Constants.retryDelay);
      await sync();
    } else {
      _logger.e('Max retry attempts reached');
      _retryCount = 0;
    }
  }
} 