import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/theme/app_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final bool showFullProgress;
  final VoidCallback? onTap;

  const ProgressIndicatorWidget({
    Key? key,
    this.showFullProgress = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.userProfile;
        if (profile == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildLevelBadge(profile.level),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressBar(profile),
                      if (showFullProgress) ...[
                        const SizedBox(height: 8),
                        _buildStats(profile),
                      ],
                    ],
                  ),
                ),
                if (showFullProgress) ...[
                  const SizedBox(width: 12),
                  _buildStreakBadge(profile.streak),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLevelBadge(int level) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          level.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(UserProfile profile) {
    final progress = (profile.experience % 100) / 100;
    final nextLevelXP = 100 - (profile.experience % 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'XP: ${profile.experience}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              'Siguiente: $nextLevelXP',
              style: TextStyle(
                color: AppTheme.secondaryColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildStats(UserProfile profile) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildStatItem('F', profile.stats['fuerza'] ?? 0),
        _buildStatItem('D', profile.stats['destreza'] ?? 0),
        _buildStatItem('I', profile.stats['inteligencia'] ?? 0),
        _buildStatItem('V', profile.stats['vitalidad'] ?? 0),
      ],
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 2),
          Text(
            value.toString(),
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            '$streak',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
} 