import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'reflection_local.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla para misiones diarias
    await db.execute('''
      CREATE TABLE daily_missions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        completed BOOLEAN NOT NULL DEFAULT 0,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        completed_at TIMESTAMP,
        user_id TEXT NOT NULL
      )
    ''');

    // Tabla para seguimiento de progreso
    await db.execute('''
      CREATE TABLE progress_tracking(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mission_id INTEGER NOT NULL,
        progress_value INTEGER NOT NULL DEFAULT 0,
        notes TEXT,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (mission_id) REFERENCES daily_missions (id)
      )
    ''');

    // Tabla para recursos locales
    await db.execute('''
      CREATE TABLE local_resources(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        resource_type TEXT NOT NULL,
        resource_path TEXT NOT NULL,
        user_id TEXT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Métodos para misiones diarias
  Future<int> insertDailyMission(Map<String, dynamic> mission) async {
    Database db = await database;
    return await db.insert('daily_missions', mission);
  }

  Future<List<Map<String, dynamic>>> getDailyMissions(String userId) async {
    Database db = await database;
    return await db.query(
      'daily_missions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<int> updateDailyMission(Map<String, dynamic> mission) async {
    Database db = await database;
    return await db.update(
      'daily_missions',
      mission,
      where: 'id = ?',
      whereArgs: [mission['id']],
    );
  }

  // Métodos para seguimiento de progreso
  Future<int> insertProgress(Map<String, dynamic> progress) async {
    Database db = await database;
    return await db.insert('progress_tracking', progress);
  }

  Future<List<Map<String, dynamic>>> getProgressForMission(int missionId) async {
    Database db = await database;
    return await db.query(
      'progress_tracking',
      where: 'mission_id = ?',
      whereArgs: [missionId],
      orderBy: 'created_at DESC',
    );
  }

  // Métodos para recursos locales
  Future<int> insertLocalResource(Map<String, dynamic> resource) async {
    Database db = await database;
    return await db.insert('local_resources', resource);
  }

  Future<List<Map<String, dynamic>>> getLocalResources(String userId, String resourceType) async {
    Database db = await database;
    return await db.query(
      'local_resources',
      where: 'user_id = ? AND resource_type = ?',
      whereArgs: [userId, resourceType],
      orderBy: 'created_at DESC',
    );
  }

  // Método para limpiar datos antiguos
  Future<void> cleanOldData(int daysToKeep) async {
    Database db = await database;
    final date = DateTime.now().subtract(Duration(days: daysToKeep));
    await db.delete(
      'daily_missions',
      where: 'created_at < ?',
      whereArgs: [date.toIso8601String()],
    );
    await db.delete(
      'progress_tracking',
      where: 'created_at < ?',
      whereArgs: [date.toIso8601String()],
    );
  }
} 