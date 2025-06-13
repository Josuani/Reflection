import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:reflection/backend/models/user_profile.dart';
import 'package:reflection/backend/services/user_progress_service.dart';
import 'package:reflection/backend/utils/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:reflection/backend/services/storage_service.dart';
import 'package:reflection/backend/services/error_monitoring_service.dart';
import 'package:reflection/constants/constants.dart';

class UserProfileService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final UserProgressService _progressService;
  final Logger _logger = Logger('UserProfileService');
  final ImagePicker _imagePicker = ImagePicker();
  final StorageService _storageService = StorageService();
  final ErrorMonitoringService _errorService = ErrorMonitoringService();

  UserProfileService({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required UserProgressService progressService,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage,
        _progressService = progressService;

  Future<UserProfile> getUserProfile() async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(Constants.currentUserId)
          .get();

      if (!doc.exists) {
        // Crear un perfil por defecto si no existe
        final defaultProfile = UserProfile(
          id: Constants.currentUserId,
          displayName: 'Usuario',
          xp: 0,
          level: 1,
        );
        await _firestore
            .collection('users')
            .doc(Constants.currentUserId)
            .set(defaultProfile.toMap());
        return defaultProfile;
      }

      return UserProfile.fromMap(doc.data()!);
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(Constants.currentUserId)
          .update(profile.toMap());
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      final downloadUrl = await _storageService.uploadProfileImage(imagePath);
      final profile = await getUserProfile();
      final updatedProfile = profile.copyWith(avatarUrl: downloadUrl);
      await updateUserProfile(updatedProfile);
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<void> addXP(int amount) async {
    try {
      final profile = await getUserProfile();
      final newXP = profile.xp + amount;
      final newLevel = (newXP ~/ 100) + 1; // Cada 100 XP sube un nivel
      
      final updatedProfile = profile.copyWith(
        xp: newXP,
        level: newLevel,
      );
      
      await updateUserProfile(updatedProfile);
    } catch (e, stackTrace) {
      _errorService.captureError(e, stackTrace);
      rethrow;
    }
  }

  Future<UserProfile> loadUserProfile(String userId) async {
    if (userId == 'local_user') {
      return _loadLocalUserProfile();
    }
    return _loadRemoteUserProfile(userId);
  }

  Future<UserProfile> _loadLocalUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('local_user_profile');
      if (jsonString != null) {
        final map = jsonDecode(jsonString) as Map<String, dynamic>;
        return UserProfile.fromMap(map);
      }
      return _createDefaultLocalProfile();
    } catch (e, stackTrace) {
      _logger.severe('Error loading local user profile', e, stackTrace);
      return _createDefaultLocalProfile();
    }
  }

  Future<UserProfile> _loadRemoteUserProfile(String userId) async {
    try {
      final doc = await _firestore.collection('user_profiles').doc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        final profile = UserProfile.fromMap(data);
        
        // Sincronizar con el progreso
        await _progressService.syncProgressWithProfile(profile);
        
        return profile;
      }
      return _createDefaultRemoteProfile(userId);
    } catch (e, stackTrace) {
      _logger.severe('Error loading remote user profile', e, stackTrace);
      return _createDefaultRemoteProfile(userId);
    }
  }

  UserProfile _createDefaultLocalProfile() {
    return UserProfile(
      id: 'local_user',
      displayName: 'Usuario',
      description: 'Bienvenido a Reflection',
    );
  }

  UserProfile _createDefaultRemoteProfile(String userId) {
    return UserProfile(
      id: userId,
      displayName: _auth.currentUser?.displayName ?? 'Usuario',
      description: 'Bienvenido a Reflection',
    );
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    if (profile.id == 'local_user') {
      await _saveLocalUserProfile(profile);
    } else {
      await _saveRemoteUserProfile(profile);
    }
  }

  Future<void> _saveLocalUserProfile(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('local_user_profile', jsonEncode(profile.toMap()));
    } catch (e, stackTrace) {
      _logger.severe('Error saving local user profile', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _saveRemoteUserProfile(UserProfile profile) async {
    try {
      await _firestore.collection('user_profiles').doc(profile.id).set(profile.toMap());
      await _progressService.syncProgressWithProfile(profile);
    } catch (e, stackTrace) {
      _logger.severe('Error saving remote user profile', e, stackTrace);
      rethrow;
    }
  }

  Future<String?> pickAndUploadProfileImage(String userId) async {
    try {
      final hasPermission = await requestGalleryPermission();
      if (!hasPermission) {
        throw Exception('No permission to access gallery');
      }

      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      if (userId == 'local_user') {
        return pickedFile.path;
      }

      final ref = _storage.ref().child('profile_images/$userId.jpg');
      await ref.putFile(File(pickedFile.path));
      final downloadUrl = await ref.getDownloadURL();
      
      await _firestore.collection('user_profiles').doc(userId).update({
        'profileImage': downloadUrl,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } catch (e, stackTrace) {
      _logger.severe('Error picking and uploading profile image', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateDisplayName(String userId, String displayName) async {
    try {
      if (userId == 'local_user') {
        final profile = await loadUserProfile(userId);
        final updated = profile.copyWith(displayName: displayName);
        await saveUserProfile(updated);
      } else {
        await _firestore.collection('user_profiles').doc(userId).update({
          'displayName': displayName,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        await _auth.currentUser?.updateDisplayName(displayName);
      }
    } catch (e, stackTrace) {
      _logger.severe('Error updating display name', e, stackTrace);
      rethrow;
    }
  }

  Future<void> updateDescription(String userId, String description) async {
    try {
      if (userId == 'local_user') {
        final profile = await loadUserProfile(userId);
        final updated = profile.copyWith(description: description);
        await saveUserProfile(updated);
      } else {
        await _firestore.collection('user_profiles').doc(userId).update({
          'description': description,
          'lastUpdated': FieldValue.serverTimestamp(),
        });
      }
    } catch (e, stackTrace) {
      _logger.severe('Error updating description', e, stackTrace);
      rethrow;
    }
  }

  Future<bool> requestGalleryPermission() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.photos.request();
      return status.isGranted;
    } catch (e) {
      _logger.severe('Error requesting gallery permission', e);
      return false;
    }
  }

  Widget getProfileImage(String? imageUrl, {double size = 100}) {
    if (imageUrl == null) {
      return CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.grey[300],
        child: Icon(Icons.person, size: size * 0.6, color: Colors.grey[600]),
      );
    }

    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: size / 2,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey[300],
          child: const CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.error, size: size * 0.6, color: Colors.red),
        ),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundImage: FileImage(File(imageUrl)),
    );
  }
} 