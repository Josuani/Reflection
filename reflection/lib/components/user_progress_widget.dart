import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/theme/app_theme.dart';

class UserProgressWidget extends StatelessWidget {
  const UserProgressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, provider, child) {
        final profile = provider.userProfile;
        if (profile == null) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(profile),
                const SizedBox(height: 16),
                _buildProgressBar(profile),
                const SizedBox(height: 16),
                _buildStats(profile),
                const SizedBox(height: 16),
                _buildDailyMissions(provider),
                const SizedBox(height: 16),
                _buildNotifications(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(UserProfile profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: profile.avatarUrl != null
              ? NetworkImage(profile.avatarUrl!)
              : null,
          child: profile.avatarUrl == null
              ? Text(
                  profile.displayName[0].toUpperCase(),
                  style: const TextStyle(fontSize: 24),
                )
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Nivel ${profile.level}',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
        ),
        _buildStreakBadge(profile.streak),
      ],
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Siguiente nivel: $nextLevelXP XP',
              style: TextStyle(
                color: AppTheme.secondaryColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
        ),
      ],
    );
  }

  Widget _buildStats(UserProfile profile) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        _buildStatItem('Fuerza', profile.stats['fuerza'] ?? 0),
        _buildStatItem('Destreza', profile.stats['destreza'] ?? 0),
        _buildStatItem('Inteligencia', profile.stats['inteligencia'] ?? 0),
        _buildStatItem('Vitalidad', profile.stats['vitalidad'] ?? 0),
      ],
    );
  }

  Widget _buildStatItem(String name, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakBadge(int streak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.accentColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '$streak días',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyMissions(UserProfileProvider provider) {
    final missions = provider.dailyMissions;
    if (missions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Misiones Diarias',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...missions.map((mission) => _buildMissionItem(mission)),
      ],
    );
  }

  Widget _buildMissionItem(Map<String, dynamic> mission) {
    final progress = mission['progress'] as int;
    final required = mission['required'] as int;
    final completed = mission['completed'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: completed
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? AppTheme.successColor : AppTheme.secondaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mission['description'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress / required,
                  backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completed ? AppTheme.successColor : AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$progress/$required',
            style: TextStyle(
              color: completed ? AppTheme.successColor : AppTheme.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifications(UserProfileProvider provider) {
    final notifications = provider.notifications;
    if (notifications.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Notificaciones',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => provider.markAllNotificationsAsRead(),
              child: const Text('Marcar todas como leídas'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...notifications.map((notification) => _buildNotificationItem(
              notification,
              () => provider.markNotificationAsRead(notification['id']),
            )),
      ],
    );
  }

  Widget _buildNotificationItem(
    Map<String, dynamic> notification,
    VoidCallback onMarkAsRead,
  ) {
    final isRead = notification['read'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead
            ? AppTheme.secondaryColor.withOpacity(0.1)
            : AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            _getNotificationIcon(notification['type'] as String),
            color: isRead ? AppTheme.secondaryColor : AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isRead ? AppTheme.secondaryColor : AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'] as String,
                  style: TextStyle(
                    color: isRead ? AppTheme.secondaryColor : null,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: onMarkAsRead,
              color: AppTheme.primaryColor,
            ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'level_up':
        return Icons.trending_up;
      case 'achievement':
        return Icons.emoji_events;
      case 'streak':
        return Icons.local_fire_department;
      case 'daily_missions':
        return Icons.assignment;
      case 'stats':
        return Icons.fitness_center;
      default:
        return Icons.notifications;
    }
  }
} 