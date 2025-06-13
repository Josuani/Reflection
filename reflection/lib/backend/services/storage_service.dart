import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:reflection/backend/utils/logger.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int maxImageDimension = 1024;
  static const int imageQuality = 85;
  static const List<String> allowedImageTypes = ['.jpg', '.jpeg', '.png'];
  static const List<String> allowedFileTypes = ['.pdf', '.doc', '.docx', '.txt'];

  final FirebaseStorage _storage;
  final Logger _logger = Logger('StorageService');

  StorageService(this._storage);

  Future<File> _compressImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      
      if (image == null) {
        throw Exception('No se pudo decodificar la imagen');
      }

      // Redimensionar si es necesario
      var resizedImage = image;
      if (image.width > maxImageDimension || image.height > maxImageDimension) {
        resizedImage = img.copyResize(
          image,
          width: image.width > image.height ? maxImageDimension : null,
          height: image.height > image.width ? maxImageDimension : null,
        );
      }

      // Comprimir
      final compressedBytes = img.encodeJpg(resizedImage, quality: imageQuality);
      
      // Guardar en archivo temporal
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/compressed_${path.basename(file.path)}');
      await tempFile.writeAsBytes(compressedBytes);
      
      return tempFile;
    } catch (e, stackTrace) {
      _logger.error('Error comprimiendo imagen', e, stackTrace);
      rethrow;
    }
  }

  bool _isValidFileType(String filePath, List<String> allowedTypes) {
    final extension = path.extension(filePath).toLowerCase();
    return allowedTypes.contains(extension);
  }

  Future<String> uploadFile(File file, String path) async {
    try {
      // Verificar tamaño
      final fileSize = await file.length();
      if (fileSize > maxFileSize) {
        throw Exception('El archivo es demasiado grande. Tamaño máximo: 5MB');
      }

      // Verificar tipo de archivo
      final isImage = _isValidFileType(file.path, allowedImageTypes);
      final isAllowedFile = _isValidFileType(file.path, allowedFileTypes);
      
      if (!isImage && !isAllowedFile) {
        throw Exception('Tipo de archivo no permitido');
      }

      // Comprimir si es imagen
      File fileToUpload = file;
      if (isImage) {
        fileToUpload = await _compressImage(file);
      }

      // Crear referencia
      final ref = _storage.ref().child(path);
      
      // Subir archivo
      final uploadTask = ref.putFile(fileToUpload);
      
      // Monitorear progreso
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        _logger.info('Progreso de subida: ${(progress * 100).toStringAsFixed(1)}%');
      });

      // Esperar a que termine
      final snapshot = await uploadTask;
      
      // Obtener URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      // Limpiar archivo temporal si existe
      if (fileToUpload != file) {
        await fileToUpload.delete();
      }
      
      return downloadUrl;
    } catch (e, stackTrace) {
      _logger.error('Error subiendo archivo', e, stackTrace);
      rethrow;
    }
  }

  Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      if (!_isValidFileType(imageFile.path, allowedImageTypes)) {
        throw Exception('Tipo de imagen no permitido. Use JPG o PNG');
      }
      
      final path = 'profile_images/$userId.jpg';
      return await uploadFile(imageFile, path);
    } catch (e, stackTrace) {
      _logger.error('Error subiendo imagen de perfil', e, stackTrace);
      rethrow;
    }
  }

  Future<String> uploadMissionImage(File imageFile, String missionId) async {
    try {
      if (!_isValidFileType(imageFile.path, allowedImageTypes)) {
        throw Exception('Tipo de imagen no permitido. Use JPG o PNG');
      }
      
      final path = 'mission_images/$missionId.jpg';
      return await uploadFile(imageFile, path);
    } catch (e, stackTrace) {
      _logger.error('Error subiendo imagen de misión', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
    } catch (e, stackTrace) {
      _logger.error('Error eliminando archivo', e, stackTrace);
      rethrow;
    }
  }

  Future<String> getDownloadUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e, stackTrace) {
      _logger.error('Error obteniendo URL de descarga', e, stackTrace);
      rethrow;
    }
  }
} 