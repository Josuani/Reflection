import 'package:flutter/material.dart';
import 'mission_card.dart';

class MissionList extends StatelessWidget {
  final List<Map<String, dynamic>> missions;
  final Function(String) onMissionComplete;

  const MissionList({
    Key? key,
    required this.missions,
    required this.onMissionComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: missions.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final mission = missions[index];
        return MissionCard(
          title: mission['title'] ?? '',
          description: mission['description'] ?? '',
          progress: mission['progress'] ?? 0,
          total: mission['total'] ?? 1,
          isCompleted: mission['isCompleted'] ?? false,
          isUrgent: mission['isUrgent'] ?? false,
          onComplete: () => onMissionComplete(mission['id']),
        );
      },
    );
  }
} 