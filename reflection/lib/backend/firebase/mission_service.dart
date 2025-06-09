import 'package:cloud_firestore/cloud_firestore.dart';

class MissionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'misiones';

  // Obtener todas las misiones
  Stream<List<Map<String, dynamic>>> getMissions() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
                  final data = doc.data();
                  data['id'] = doc.id;
                  return data;
                })
            .toList());
  }

  // Obtener misiones por estado
  Stream<List<Map<String, dynamic>>> getMissionsByStatus(String status) {
    return _firestore
        .collection(_collection)
        .where('status', isEqualTo: status)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) {
                  final data = doc.data();
                  data['id'] = doc.id;
                  return data;
                })
            .toList());
  }

  // Crear una nueva misión
  Future<String> createMission(Map<String, dynamic> missionData) async {
    final docRef = await _firestore.collection(_collection).add({
      ...missionData,
      'status': 'disponible',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return docRef.id;
  }

  // Actualizar el estado de una misión
  Future<void> updateMissionStatus(String missionId, String newStatus) async {
    await _firestore.collection(_collection).doc(missionId).update({
      'status': newStatus,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Eliminar una misión
  Future<void> deleteMission(String missionId) async {
    await _firestore.collection(_collection).doc(missionId).delete();
  }
} 