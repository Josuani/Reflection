import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<String> saveImage(XFile image, String userId) async {
    if (kIsWeb) {
      // En web, guardar la imagen como base64 en SharedPreferences
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_image_base64_$userId', base64Image);
      return 'base64';
    } else {
      final localPath = await _localPath;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(image.path)}';
      final savedPath = path.join(localPath, 'images', userId, fileName);
      
      // Crear directorio si no existe
      await Directory(path.dirname(savedPath)).create(recursive: true);
      
      // Copiar la imagen al almacenamiento local
      final savedFile = await File(image.path).copy(savedPath);
      
      // Guardar referencia en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedImages = prefs.getStringList('saved_images_$userId') ?? [];
      savedImages.add(savedPath);
      await prefs.setStringList('saved_images_$userId', savedImages);
      
      return savedFile.path;
    }
  }

  Future<String?> getUserImage(String userId) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('user_image_base64_$userId');
    } else {
      final prefs = await SharedPreferences.getInstance();
      final savedImages = prefs.getStringList('saved_images_$userId') ?? [];
      
      if (savedImages.isNotEmpty) {
        return savedImages.first;
      } else {
        return null;
      }
    }
  }

  Future<List<File>> getUserImages(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedImages = prefs.getStringList('saved_images_$userId') ?? [];
    
    return savedImages
        .map((path) => File(path))
        .where((file) => file.existsSync())
        .toList();
  }

  Future<void> deleteImage(String imagePath, String userId) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
      
      // Actualizar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedImages = prefs.getStringList('saved_images_$userId') ?? [];
      savedImages.remove(imagePath);
      await prefs.setStringList('saved_images_$userId', savedImages);
    }
  }

  Future<void> clearUserImages(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedImages = prefs.getStringList('saved_images_$userId') ?? [];
    
    for (final imagePath in savedImages) {
      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    
    await prefs.remove('saved_images_$userId');
  }

  Future<String> saveFile(File file, String userId, String fileType) async {
    final localPath = await _localPath;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final savedPath = path.join(localPath, fileType, userId, fileName);
    
    // Crear directorio si no existe
    await Directory(path.dirname(savedPath)).create(recursive: true);
    
    // Copiar el archivo al almacenamiento local
    final savedFile = await file.copy(savedPath);
    
    // Guardar referencia en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final savedFiles = prefs.getStringList('saved_${fileType}_$userId') ?? [];
    savedFiles.add(savedPath);
    await prefs.setStringList('saved_${fileType}_$userId', savedFiles);
    
    return savedFile.path;
  }

  Future<List<String>> getUserFiles(String userId, String fileType) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('saved_${fileType}_$userId') ?? [];
  }

  Future<void> deleteFile(String filePath, String userId, String fileType) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      
      // Actualizar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final savedFiles = prefs.getStringList('saved_${fileType}_$userId') ?? [];
      savedFiles.remove(filePath);
      await prefs.setStringList('saved_${fileType}_$userId', savedFiles);
    }
  }

  Future<void> clearUserFiles(String userId, String fileType) async {
    final prefs = await SharedPreferences.getInstance();
    final savedFiles = prefs.getStringList('saved_${fileType}_$userId') ?? [];
    
    for (final filePath in savedFiles) {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    
    await prefs.remove('saved_${fileType}_$userId');
  }
} 