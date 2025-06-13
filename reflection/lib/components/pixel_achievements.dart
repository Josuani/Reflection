import 'package:flutter/material.dart';

class PixelAchievements extends StatelessWidget {
  final List<Achievement> achievements;
  final double size;

  const PixelAchievements({
    Key? key,
    required this.achievements,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _AchievementBadge(
          achievement: achievement,
          size: size,
        );
      },
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final double size;

  const _AchievementBadge({
    Key? key,
    required this.achievement,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: achievement.description,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          border: Border.all(
            color: achievement.isUnlocked ? Colors.yellow : Colors.grey,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Achievement icon
            Center(
              child: Image.asset(
                achievement.isUnlocked
                    ? 'assets/images/achievements/${achievement.id}.png'
                    : 'assets/images/achievements/locked.png',
                width: size * 0.7,
                height: size * 0.7,
                color: achievement.isUnlocked ? null : Colors.grey,
              ),
            ),
            // Lock overlay
            if (!achievement.isUnlocked)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isUnlocked: map['isUnlocked'] as bool? ?? false,
      unlockedAt: map['unlockedAt'] != null
          ? DateTime.parse(map['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
} 