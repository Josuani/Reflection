import 'package:flutter/material.dart';

class UserProfile {
  // Constantes de validación
  static const int maxLevel = 100;
  static const int maxXp = 1000000;
  static const int maxStreak = 365;
  static const int maxDescriptionLength = 500;
  static const int maxDisplayNameLength = 50;
  static const int maxAchievements = 100;
  static const int maxMissionsCompleted = 10000;
  static const List<String> supportedLanguages = ['es', 'en'];
  static const List<String> defaultStats = ['fuerza', 'destreza', 'inteligencia', 'vitalidad'];
  static const Map<String, int> defaultStatValues = {
    'fuerza': 0,
    'destreza': 0,
    'inteligencia': 0,
    'vitalidad': 0
  };

  final String? id;
  final String? displayName;
  final String? description;
  final String? avatarUrl;
  final int xp;
  final int level;
  final Map<String, dynamic>? preferences;
  final DateTime? lastUpdated;
  final String? profileImage;
  final List<String> achievements;
  final int missionsCompleted;
  final String themeColor;
  final String language;
  final bool soundEnabled;
  final int streak;
  final Map<String, int> stats;

  UserProfile({
    this.id,
    this.displayName,
    this.description,
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.preferences,
    this.lastUpdated,
    this.profileImage,
    List<String>? achievements,
    this.missionsCompleted = 0,
    this.themeColor = '#673ab7',
    this.language = 'es',
    this.soundEnabled = true,
    this.streak = 0,
    Map<String, int>? stats,
  }) : 
    lastUpdated = lastUpdated ?? DateTime.now(),
    preferences = preferences ?? {},
    stats = stats ?? Map.from(defaultStatValues),
    achievements = achievements ?? [];

  UserProfile copyWith({
    String? id,
    String? displayName,
    String? description,
    String? avatarUrl,
    int? xp,
    int? level,
    Map<String, dynamic>? preferences,
    DateTime? lastUpdated,
    String? profileImage,
    List<String>? achievements,
    int? missionsCompleted,
    String? themeColor,
    String? language,
    bool? soundEnabled,
    int? streak,
    Map<String, int>? stats,
  }) {
    return UserProfile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      preferences: preferences ?? this.preferences,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      profileImage: profileImage ?? this.profileImage,
      achievements: achievements ?? this.achievements,
      missionsCompleted: missionsCompleted ?? this.missionsCompleted,
      themeColor: themeColor ?? this.themeColor,
      language: language ?? this.language,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      streak: streak ?? this.streak,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'description': description,
      'avatarUrl': avatarUrl,
      'xp': xp,
      'level': level,
      'preferences': preferences,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'profileImage': profileImage,
      'achievements': achievements,
      'missionsCompleted': missionsCompleted,
      'themeColor': themeColor,
      'language': language,
      'soundEnabled': soundEnabled,
      'streak': streak,
      'stats': stats,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String?,
      displayName: map['displayName'] as String?,
      description: map['description'] as String?,
      avatarUrl: map['avatarUrl'] as String?,
      xp: map['xp'] as int? ?? 0,
      level: map['level'] as int? ?? 1,
      preferences: map['preferences'] as Map<String, dynamic>?,
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated'] as String)
          : null,
      profileImage: map['profileImage'] as String?,
      achievements: List<String>.from(map['achievements'] ?? []),
      missionsCompleted: map['missionsCompleted'] as int? ?? 0,
      themeColor: map['themeColor'] as String? ?? '#673ab7',
      language: map['language'] as String? ?? 'es',
      soundEnabled: map['soundEnabled'] as bool? ?? true,
      streak: map['streak'] as int? ?? 0,
      stats: Map<String, int>.from(map['stats'] ?? {}),
    );
  }

  bool validate() {
    if (id?.isEmpty ?? true) return false;
    if (displayName != null && (displayName!.isEmpty || displayName!.length > maxDisplayNameLength)) return false;
    if (description != null && description!.length > maxDescriptionLength) return false;
    if (level < 1 || level > maxLevel) return false;
    if (xp < 0 || xp > maxXp) return false;
    if (streak < 0 || streak > maxStreak) return false;
    if (missionsCompleted < 0 || missionsCompleted > maxMissionsCompleted) return false;
    if (achievements.length > maxAchievements) return false;
    if (!_isValidHexColor(themeColor)) return false;
    if (!supportedLanguages.contains(language)) return false;
    if (!_validateStats()) return false;
    return true;
  }

  bool _validateStats() {
    // Verificar que todas las estadísticas por defecto estén presentes
    for (final stat in defaultStats) {
      if (!stats.containsKey(stat)) return false;
      if (stats[stat]! < 0) return false;
    }
    return true;
  }

  bool _isValidHexColor(String color) {
    if (color.isEmpty) return false;
    if (color[0] != '#') return false;
    if (color.length != 7) return false;
    try {
      int.parse(color.substring(1), radix: 16);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.displayName == displayName &&
        other.description == description &&
        other.avatarUrl == avatarUrl &&
        other.xp == xp &&
        other.level == level &&
        mapEquals(other.preferences, preferences) &&
        other.lastUpdated == lastUpdated &&
        other.profileImage == profileImage &&
        listEquals(other.achievements, achievements) &&
        other.missionsCompleted == missionsCompleted &&
        other.themeColor == themeColor &&
        other.language == language &&
        other.soundEnabled == soundEnabled &&
        other.streak == streak &&
        mapEquals(other.stats, stats);
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      displayName,
      description,
      avatarUrl,
      xp,
      level,
      Object.hashAll(preferences?.entries ?? []),
      lastUpdated,
      profileImage,
      Object.hashAll(achievements),
      missionsCompleted,
      themeColor,
      language,
      soundEnabled,
      streak,
      Object.hashAll(stats.entries),
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, displayName: $displayName, level: $level, xp: $xp)';
  }
} 