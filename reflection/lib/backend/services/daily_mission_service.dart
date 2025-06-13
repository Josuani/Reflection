import '../local_database/database_helper.dart';
import '../models/daily_mission.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences.dart';
import 'dart:convert';

class DailyMissionService {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferences _prefs;

  static const String _missionsKey = 'daily_missions';
  static const String _lastSyncKey = 'missions_last_sync';

  DailyMissionService(this._prefs);

  // Crear una nueva misión
  Future<DailyMission> createMission(DailyMission mission) async {
    // Guardar en base de datos local
    final id = await _dbHelper.insertDailyMission(mission.toMap());
    final localMission = mission.copyWith(id: id);

    // Guardar en SharedPreferences para acceso rápido
    await _saveMissionsToLocal([localMission]);

    // Solo guardar en Firebase si es usuario autenticado y han pasado 24 horas
    if (_auth.currentUser != null && _shouldSyncWithFirebase()) {
      await _firestore.collection('daily_missions').add({
        ...mission.toMap(),
        'id': id,
        'synced': true,
      });
      await _updateLastSync();
    }

    return localMission;
  }

  // Obtener todas las misiones del usuario
  Future<List<DailyMission>> getUserMissions() async {
    // Primero intentar cargar de local
    final localMissions = _getMissionsFromLocal();
    if (localMissions.isNotEmpty) {
      return localMissions;
    }

    // Si no hay datos locales, intentar cargar de Firebase
    if (_auth.currentUser != null) {
      final missions = await _dbHelper.getDailyMissions(_auth.currentUser!.uid);
      final parsedMissions = missions.map((map) => DailyMission.fromMap(map)).toList();
      
      // Guardar en local para futuras consultas
      await _saveMissionsToLocal(parsedMissions);
      
      return parsedMissions;
    }

    return [];
  }

  // Actualizar una misión
  Future<void> updateMission(DailyMission mission) async {
    // Actualizar en base de datos local
    await _dbHelper.updateDailyMission(mission.toMap());
    
    // Actualizar en SharedPreferences
    final missions = _getMissionsFromLocal();
    final updatedMissions = missions.map((m) => 
      m.id == mission.id ? mission : m
    ).toList();
    await _saveMissionsToLocal(updatedMissions);

    // Solo actualizar en Firebase si es usuario autenticado y han pasado 24 horas
    if (_auth.currentUser != null && _shouldSyncWithFirebase()) {
      final missionDoc = await _firestore
          .collection('daily_missions')
          .where('id', isEqualTo: mission.id)
          .get();

      if (missionDoc.docs.isNotEmpty) {
        await missionDoc.docs.first.reference.update({
          ...mission.toMap(),
          'synced': true,
        });
        await _updateLastSync();
      }
    }
  }

  // Actualizar el progreso de una misión
  Future<void> updateMissionProgress(int missionId, int progress) async {
    final userId = _auth.currentUser?.uid ?? 'local_user';
    
    // Actualizar progreso en base de datos local
    await _dbHelper.insertProgress({
      'mission_id': missionId,
      'progress_value': progress,
      'created_at': DateTime.now().toIso8601String(),
    });

    // Actualizar en SharedPreferences
    final missions = _getMissionsFromLocal();
    final updatedMissions = missions.map((mission) {
      if (mission.id == missionId) {
        return mission.copyWith(progress: progress);
      }
      return mission;
    }).toList();
    await _saveMissionsToLocal(updatedMissions);

    // Solo actualizar en Firebase si es usuario autenticado y han pasado 24 horas
    if (_auth.currentUser != null && _shouldSyncWithFirebase()) {
      final missionDoc = await _firestore
          .collection('daily_missions')
          .where('id', isEqualTo: missionId)
          .get();

      if (missionDoc.docs.isNotEmpty) {
        await missionDoc.docs.first.reference.update({
          'progress': progress,
          'last_updated': FieldValue.serverTimestamp(),
        });
        await _updateLastSync();
      }
    }
  }

  // Obtener el progreso de una misión
  Future<List<Map<String, dynamic>>> getMissionProgress(int missionId) async {
    return await _dbHelper.getProgressForMission(missionId);
  }

  // Sincronizar misiones con Firestore
  Future<void> syncMissions() async {
    if (_auth.currentUser == null) return;

    final userId = _auth.currentUser!.uid;
    
    // Obtener misiones locales no sincronizadas
    final localMissions = await _dbHelper.getDailyMissions(userId);
    
    // Obtener misiones de Firestore
    final firestoreMissions = await _firestore
        .collection('daily_missions')
        .where('user_id', isEqualTo: userId)
        .get();

    // Crear un mapa de misiones de Firestore por ID
    final firestoreMissionsMap = {
      for (var doc in firestoreMissions.docs)
        doc.data()['id'] as int: doc
    };

    // Sincronizar cada misión local
    for (final localMission in localMissions) {
      final missionId = localMission['id'] as int;
      final firestoreDoc = firestoreMissionsMap[missionId];

      if (firestoreDoc == null) {
        // La misión no existe en Firestore, crearla
        await _firestore.collection('daily_missions').add({
          ...localMission,
          'synced': true,
        });
      } else {
        // La misión existe, actualizar si es necesario
        final firestoreData = firestoreDoc.data();
        if (firestoreData['last_updated'] != null &&
            DateTime.parse(localMission['created_at'] as String)
                .isAfter(firestoreData['last_updated'].toDate())) {
          await firestoreDoc.reference.update({
            ...localMission,
            'synced': true,
          });
        }
      }
    }
  }

  // Limpiar datos antiguos
  Future<void> cleanOldData(int daysToKeep) async {
    await _dbHelper.cleanOldData(daysToKeep);
  }

  // Métodos de almacenamiento local
  Future<void> _saveMissionsToLocal(List<DailyMission> missions) async {
    final missionsJson = missions.map((m) => m.toMap()).toList();
    await _prefs.setString(_missionsKey, jsonEncode(missionsJson));
  }

  List<DailyMission> _getMissionsFromLocal() {
    final missionsStr = _prefs.getString(_missionsKey);
    if (missionsStr == null) return [];
    
    try {
      final List<dynamic> missionsJson = jsonDecode(missionsStr);
      return missionsJson
          .map((json) => DailyMission.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error parsing local missions: $e');
      return [];
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
} 