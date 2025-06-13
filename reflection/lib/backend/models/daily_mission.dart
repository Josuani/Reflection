class DailyMission {
  final int? id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String userId;
  int progress;

  DailyMission({
    this.id,
    required this.title,
    this.description,
    this.completed = false,
    DateTime? createdAt,
    this.completedAt,
    required this.userId,
    this.progress = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'user_id': userId,
    };
  }

  factory DailyMission.fromMap(Map<String, dynamic> map) {
    return DailyMission(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      completed: map['completed'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      userId: map['user_id'] as String,
      progress: map['progress'] as int? ?? 0,
    );
  }

  DailyMission copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? completedAt,
    String? userId,
    int? progress,
  }) {
    return DailyMission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      userId: userId ?? this.userId,
      progress: progress ?? this.progress,
    );
  }
} 