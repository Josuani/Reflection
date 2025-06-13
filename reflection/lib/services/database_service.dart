import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

// Modelos
part 'database_service.g.dart';

enum DraftType { create, update, delete }

@HiveType(typeId: 0)
class Mision extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String titulo;
  
  @HiveField(2)
  final String descripcion;
  
  @HiveField(3)
  final int puntos;
  
  Mision({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.puntos,
  });

  factory Mision.fromMap(String id, Map<String, dynamic> map) {
    return Mision(
      id: id,
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      puntos: map['puntos'] ?? 0,
    );
  }
}

@HiveType(typeId: 1)
class DraftChange extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String tipo;
  
  @HiveField(2)
  final Map<String, dynamic> datos;
  
  @HiveField(3)
  final DateTime timestamp;
  
  DraftChange({
    required this.id,
    required this.tipo,
    required this.datos,
    required this.timestamp,
  });
}

@HiveType(typeId: 2)
class Setting extends HiveObject {
  @HiveField(0)
  final String key;
  
  @HiveField(1)
  final String tema;
  
  @HiveField(2)
  final String idioma;
  
  @HiveField(3)
  final Map<String, dynamic> filtros;
  
  Setting({
    required this.key,
    required this.tema,
    required this.idioma,
    required this.filtros,
  });
}

@HiveType(typeId: 3)
class UIState extends HiveObject {
  @HiveField(0)
  final String key;
  
  @HiveField(1)
  final String ruta;
  
  @HiveField(2)
  final Map<String, dynamic> estado;
  
  @HiveField(3)
  final DateTime ultimaActualizacion;
  
  UIState({
    required this.key,
    required this.ruta,
    required this.estado,
    required this.ultimaActualizacion,
  });
}

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // ————————————————
  // 1. FIRESTORE (REMOTA)
  // ————————————————
  // Usuarios: perfil público, estadísticas (nivel, puntos, avatar)
  final CollectionReference usuariosRef = FirebaseFirestore.instance.collection('usuarios');

  // Misiones y recompensas: definición de cada misión, requisitos, recompensas
  final CollectionReference misionesRef = FirebaseFirestore.instance.collection('misiones');

  // Progreso sincronizado: hitos completados, fecha de logro, logs mínimos
  final CollectionReference progresoRef = FirebaseFirestore.instance.collection('progreso');

  // Configuración global: reglas de negocio (por ejemplo multiplicadores de XP), anuncios o eventos
  final DocumentReference configGlobalRef = FirebaseFirestore.instance.doc('configuracion/global');

  // ————————————————
  // 2. LOCAL (CLIENTE)
  // ————————————————
  late Box<Mision> missionCacheBox;
  late Box<DraftChange> draftChangesBox;
  late Box<Setting> settingsBox;
  late Box<UIState> uiStateBox;

  Future<void> initialize() async {
    // Registrar adaptadores de Hive
    Hive.registerAdapter(MisionAdapter());
    Hive.registerAdapter(DraftChangeAdapter());
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(UIStateAdapter());

    // Inicializar cajas
    missionCacheBox = await Hive.openBox<Mision>('cache_misiones');
    draftChangesBox = await Hive.openBox<DraftChange>('borradores_cambios');
    settingsBox = await Hive.openBox<Setting>('preferencias');
    uiStateBox = await Hive.openBox<UIState>('estado_ui');
  }

  // ──────────────────────────────────────
  // CRUD Firestore (Usuarios, Misiones, Progreso)
  // ──────────────────────────────────────
  // Usuarios
  Future<void> createUsuario(Map<String, dynamic> data) => usuariosRef.add(data);
  Future<DocumentSnapshot> readUsuario(String id) => usuariosRef.doc(id).get();
  Future<void> updateUsuario(String id, Map<String, dynamic> data) async {
    debugPrint('🔄 Actualizando usuario $id con $data');
    await usuariosRef.doc(id).update(data);
    debugPrint('✅ Usuario $id actualizado');
  }
  Future<void> deleteUsuario(String id) => usuariosRef.doc(id).delete();

  // Misiones
  Future<void> createMision(Map<String, dynamic> data) => misionesRef.add(data);
  Future<DocumentSnapshot> readMision(String id) => misionesRef.doc(id).get();
  Future<void> updateMision(String id, Map<String, dynamic> data) => misionesRef.doc(id).update(data);
  Future<void> deleteMision(String id) => misionesRef.doc(id).delete();

  // Progreso
  Future<void> createProgreso(Map<String, dynamic> data) => progresoRef.add(data);
  Future<QuerySnapshot> readProgreso(String usuarioId) => progresoRef.where('usuarioId', isEqualTo: usuarioId).get();
  Future<void> updateProgreso(String id, Map<String, dynamic> data) => progresoRef.doc(id).update(data);
  Future<void> deleteProgreso(String id) => progresoRef.doc(id).delete();

  // ──────────────────────────────────────
  // CRUD Local (Hive Boxes)
  // ──────────────────────────────────────
  // Caché de misiones
  Future<void> cacheMision(Mision m) => missionCacheBox.put(m.id, m);
  Mision? getCachedMision(String id) => missionCacheBox.get(id);
  Future<void> removeCachedMision(String id) => missionCacheBox.delete(id);

  // Borradores
  Future<void> saveDraft(DraftChange d) => draftChangesBox.put(d.id, d);
  DraftChange? getDraft(String id) => draftChangesBox.get(id);
  Future<void> removeDraft(String id) => draftChangesBox.delete(id);

  // Preferencias
  Future<void> saveSetting(Setting s) => settingsBox.put(s.key, s);
  Setting? getSetting(String key) => settingsBox.get(key);

  // Estado UI
  Future<void> saveUIState(UIState s) => uiStateBox.put(s.key, s);
  UIState? getUIState(String key) => uiStateBox.get(key);

  /// Sincroniza los cambios offline pendientes en Hive con Firestore
  Future<void> syncPendingChanges() async {
    final drafts = draftChangesBox.values.toList();
    for (var draft in drafts) {
      switch (draft.tipo) {
        case 'create':
          await misionesRef.add(draft.datos);
          break;
        case 'update':
          await misionesRef.doc(draft.id).update(draft.datos);
          break;
        case 'delete':
          await misionesRef.doc(draft.id).delete();
          break;
      }
      await draftChangesBox.delete(draft.id);
    }
  }

  /// Refresca el caché local de misiones desde Firestore
  Future<void> refreshMissionsCache() async {
    final snapshot = await misionesRef.get();
    final missions = snapshot.docs.map((d) => Mision.fromMap(d.id, d.data() as Map<String, dynamic>)).toList();
    await missionCacheBox.clear();
    for (var m in missions) {
      await missionCacheBox.put(m.id, m);
    }
  }
} 