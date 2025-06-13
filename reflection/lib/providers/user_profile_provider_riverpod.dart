import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflection/backend/models/user_profile.dart';
import 'package:reflection/backend/services/user_profile_service.dart';
import 'package:reflection/backend/services/local_progress_service.dart';

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>((ref) {
  final userProfileService = UserProfileService();
  final localProgressService = LocalProgressService();
  return UserProfileNotifier(userProfileService, localProgressService);
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileService _userProfileService;
  final LocalProgressService _localProgressService;

  UserProfileNotifier(this._userProfileService, this._localProgressService) : super(const AsyncValue.loading()) {
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      state = const AsyncValue.loading();
      
      // Cargar datos locales primero
      final localProgress = _localProgressService.getProgress();
      if (localProgress != null) {
        state = AsyncValue.data(UserProfile.fromMap(localProgress));
      }

      // Cargar desde el servidor
      final profile = await _userProfileService.getUserProfile();
      state = AsyncValue.data(profile);
      
      // Guardar localmente
      await _localProgressService.saveProgress(profile.toMap());
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      state = const AsyncValue.loading();
      
      // Guardar localmente primero
      await _localProgressService.saveProgress(profile.toMap());
      
      // Actualizar en el servidor
      await _userProfileService.updateUserProfile(profile);
      
      state = AsyncValue.data(profile);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
} 