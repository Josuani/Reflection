import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reflection/backend/models/user_profile.dart';
import 'package:reflection/providers/user_profile_provider_riverpod.dart';
import 'package:reflection/theme/app_theme.dart';
import 'widgets/pixel_style.dart';
import 'package:reflection/components/pixel_achievements.dart';
import 'package:reflection/components/pixel_avatar.dart';
import 'package:reflection/components/pixel_xp_bar.dart';
import 'package:reflection/pages/perfil/edit_profile_page.dart';
import 'package:reflection/utils/app_utils.dart';

/// Design a user profile screen with a retro, pixel art aesthetic.
///
/// Include the player's avatar with an edit option, a visible experience (XP)
/// bar showing the current level, and key stats such as completed quests,
/// achieved goals, active streak, and unlocked achievements. Add personal
/// metrics like willpower and discipline displayed in clean stat cards. Also
/// include editable fields like player name, personal motto, and a theme
/// settings button. Use cool tones, pixelated 8-bit typography, and a clear
/// layout inspired by classic video games.
class PerfilWidget extends ConsumerStatefulWidget {
  const PerfilWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends ConsumerState<PerfilWidget> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _updateName() async {
    if (_nameController.text.isEmpty) return;
    final userProfileAsync = ref.read(userProfileProvider);
    final currentProfile = userProfileAsync.value;
    if (currentProfile == null) return;
    
    final updatedProfile = currentProfile.copyWith(
      displayName: _nameController.text,
    );
    
    await ref.read(userProfileProvider.notifier).updateProfile(updatedProfile);
  }

  Future<void> _updateDescription() async {
    if (_descriptionController.text.isEmpty) return;
    final userProfileAsync = ref.read(userProfileProvider);
    final currentProfile = userProfileAsync.value;
    if (currentProfile == null) return;
    
    final updatedProfile = currentProfile.copyWith(
      description: _descriptionController.text,
    );
    
    await ref.read(userProfileProvider.notifier).updateProfile(updatedProfile);
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // TODO: Implementar la subida de imagen
      }
    } catch (e) {
      // TODO: Manejar el error
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    
    return userProfileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (userProfile) {
        if (userProfile == null) {
          return const Center(child: Text('No hay perfil de usuario'));
        }
        
        return Scaffold(
          appBar: AppBar(
            title: Text(userProfile.displayName ?? 'Sin nombre'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        PixelAvatar(
                          avatarUrl: userProfile.avatarUrl,
                          size: 120,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userProfile.displayName ?? '',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (userProfile.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      userProfile.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  PixelXPBar(
                    xp: userProfile.xp,
                    level: userProfile.level,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implementar edición de perfil
                    },
                    child: const Text('Editar Perfil'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile profile) {
    return Row(
      children: [
        PixelAvatar(
          avatarUrl: profile.avatarUrl,
          size: 100,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.displayName ?? '',
                style: const TextStyle(
                  fontFamily: 'PressStart2P',
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              if (profile.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  profile.description!,
                  style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              _buildEditButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditProfilePage(),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context, UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        color: Colors.black.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stats',
            style: TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          PixelXPBar(
            xp: profile.xp,
            level: profile.level,
          ),
          const SizedBox(height: 16),
          _buildStatRow('Missions Completed', '${profile.missionsCompleted}'),
          _buildStatRow('Current Streak', '${profile.streak} days'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'PressStart2P',
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context, UserProfile profile) {
    final achievements = profile.achievements.map((id) {
      // TODO: Load achievement details from a service
      return Achievement(
        id: id,
        title: 'Achievement $id',
        description: 'Description for achievement $id',
        isUnlocked: true,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontFamily: 'PressStart2P',
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        PixelAchievements(achievements: achievements),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accentColor, width: 2),
      ),
      child: Column(
        children: [
          Text(value, style: AppTheme.titleStyle),
          const SizedBox(height: 4),
          Text(label, style: AppTheme.subtitleStyle),
        ],
      ),
    );
  }
}
