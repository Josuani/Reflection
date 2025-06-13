import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import 'auth_service.dart';
import 'daily_missions_service.dart';
import 'error_monitoring_service.dart';
import 'local_cache_service.dart';
import 'local_progress_service.dart';
import 'progress_actions_service.dart';
import 'progress_notification_service.dart';
import 'rewards_service.dart';
import 'storage_service.dart';
import 'sync_service.dart';
import 'user_profile_service.dart';
import 'user_progress_service.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  late final SharedPreferences _prefs;
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final Logger _logger;

  // Servicios
  late final AuthService authService;
  late final DailyMissionsService dailyMissionsService;
  late final ErrorMonitoringService errorService;
  late final LocalCacheService localCache;
  late final LocalProgressService localProgress;
  late final ProgressActionsService progressActions;
  late final ProgressNotificationService notifications;
  late final RewardsService rewards;
  late final StorageService storage;
  late final SyncService sync;
  late final UserProfileService userProfile;
  late final UserProgressService userProgress;

  Future<void> initialize() async {
    // Inicializar dependencias base
    _prefs = await SharedPreferences.getInstance();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _logger = Logger();

    // Inicializar servicios
    errorService = ErrorMonitoringService();
    localCache = LocalCacheService(_prefs);
    localProgress = LocalProgressService(errorService);
    storage = StorageService(_firestore);
    
    // Servicios que dependen de otros servicios
    authService = AuthService(_auth, _firestore, errorService);
    dailyMissionsService = DailyMissionsService(_firestore, localProgress, errorService);
    progressActions = ProgressActionsService(localProgress, errorService);
    notifications = ProgressNotificationService(_firestore, localProgress, errorService);
    rewards = RewardsService(_firestore, localProgress, errorService);
    sync = SyncService(localProgress, errorService, _firestore);
    userProfile = UserProfileService(_firestore, localCache, errorService);
    userProgress = UserProgressService(_firestore, localProgress, errorService);

    _logger.i('Todos los servicios han sido inicializados correctamente');
  }

  Future<void> dispose() async {
    // Limpiar recursos si es necesario
    await _prefs.clear();
    _logger.i('Servicios limpiados correctamente');
  }
} 