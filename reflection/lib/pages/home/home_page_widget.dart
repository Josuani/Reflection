import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_model.dart';
import 'widgets/home_header.dart';
import 'widgets/daily_progress.dart';
import 'widgets/recent_activities.dart';
import 'widgets/quick_actions.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for activities
  final List<Map<String, dynamic>> _activities = [
    {
      'title': 'Completed Daily Reflection',
      'description': 'You completed your daily reflection',
      'timestamp': DateTime.now().subtract(Duration(minutes: 30)),
      'icon': Icons.edit_note,
      'xpReward': 50,
    },
    {
      'title': 'New Achievement Unlocked',
      'description': 'Week Warrior - Complete 7 daily reflections',
      'timestamp': DateTime.now().subtract(Duration(hours: 2)),
      'icon': Icons.emoji_events,
      'xpReward': 100,
    },
    {
      'title': 'Mission Completed',
      'description': 'You completed the "Morning Routine" mission',
      'timestamp': DateTime.now().subtract(Duration(hours: 5)),
      'icon': Icons.flag,
      'xpReward': 75,
    },
  ];

  // Mock data for quick actions
  final List<Map<String, dynamic>> _quickActions = [
    {
      'id': 'new_reflection',
      'title': 'New Reflection',
      'description': 'Start your daily reflection',
      'icon': Icons.edit_note,
    },
    {
      'id': 'view_missions',
      'title': 'View Missions',
      'description': 'Check your active missions',
      'icon': Icons.flag,
    },
    {
      'id': 'set_goal',
      'title': 'Set Goal',
      'description': 'Create a new goal',
      'icon': Icons.track_changes,
    },
    {
      'id': 'view_stats',
      'title': 'View Stats',
      'description': 'Check your progress',
      'icon': Icons.bar_chart,
    },
  ];

  @override
  void initState() {
    super.initState();
    print('Entrando a initState de HomePageWidget');
    _model = createModel(context, () => HomePageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleActionPressed(String actionId) {
    switch (actionId) {
      case 'new_reflection':
        // TODO: Navigate to new reflection page
        print('New reflection pressed');
        break;
      case 'view_missions':
        context.pushNamed('misiones2');
        break;
      case 'set_goal':
        // TODO: Navigate to set goal page
        print('Set goal pressed');
        break;
      case 'view_stats':
        // TODO: Navigate to stats page
        print('View stats pressed');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Entrando a build de HomePageWidget');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeHeader(
                        userName: 'John Doe',
                        avatarUrl: 'assets/images/me.jpg',
                        level: 7,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: DailyProgress(
                          completedTasks: 5,
                          totalTasks: 8,
                          streakDays: 7,
                          dailyGoal: 6,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: QuickActions(
                          actions: _quickActions,
                          onActionPressed: _handleActionPressed,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: RecentActivities(
                          activities: _activities,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 