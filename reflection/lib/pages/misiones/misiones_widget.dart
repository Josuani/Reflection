import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'misiones_model.dart';
import 'widgets/mission_header.dart';
import 'widgets/mission_filters.dart';
import 'widgets/mission_list.dart';

/// Design a missions screen (quest log) with a retro, pixel art interface.
///
/// Display a list of daily and weekly quests, each in its own card or row
/// with pixel-style checkboxes or toggle buttons. Each mission should include
/// a title, short description, progress indicator (e.g. 2/5), and a button to
/// mark as complete. Highlight active or urgent missions with a light blue
/// background. Include filters or tabs for "Available", "In Progress", and
/// "Completed" quests. Use cold tones, clean layout, pixelated 8-bit fonts,
/// and classic RPG interface elements like icons, borders, and status bars.
class MisionesWidget extends StatefulWidget {
  const MisionesWidget({super.key});

  static String routeName = 'Misiones';
  static String routePath = '/Misiones';

  @override
  State<MisionesWidget> createState() => _MisionesWidgetState();
}

class _MisionesWidgetState extends State<MisionesWidget> {
  late MisionesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for missions
  final List<Map<String, dynamic>> _missions = [
    {
      'id': '1',
      'title': 'Daily Reflection',
      'description': 'Take 5 minutes to reflect on your day',
      'progress': 1,
      'total': 1,
      'isCompleted': false,
      'isUrgent': true,
    },
    {
      'id': '2',
      'title': 'Weekly Goals',
      'description': 'Set 3 goals for the upcoming week',
      'progress': 2,
      'total': 3,
      'isCompleted': false,
      'isUrgent': false,
    },
    {
      'id': '3',
      'title': 'Monthly Review',
      'description': 'Review your progress and achievements',
      'progress': 1,
      'total': 1,
      'isCompleted': true,
      'isUrgent': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = MisionesModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleMissionComplete(String missionId) {
    setState(() {
      final mission = _missions.firstWhere((m) => m['id'] == missionId);
      mission['isCompleted'] = true;
      mission['progress'] = mission['total'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 16.0),
                          child: SingleChildScrollView(
                            primary: false,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MissionHeader(),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 16.0, 0.0, 16.0),
                                  child: MissionFilters(
                                    selectedFilter: _model.choiceChipsValue,
                                    onFilterChanged: (val) => setState(() =>
                                        _model.choiceChipsValue = val?.firstOrNull),
                                  ),
                                ),
                                MissionList(
                                  missions: _missions,
                                  onMissionComplete: _handleMissionComplete,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
