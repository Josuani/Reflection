import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
import 'package:reflection/pages/home/widgets/home_header.dart';
import 'package:reflection/pages/home/widgets/daily_progress.dart';
import 'package:reflection/pages/home/widgets/quick_actions.dart';
import 'package:reflection/pages/home/widgets/recent_activities.dart';
export 'home_page_model.dart';

/// Explora, reflexiona y crece en tu viaje personal
///
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static const String routeName = 'homePage';
  static const String routePath = '/home';

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('HomePageWidget build called'); // Debug print
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: FlutterFlowTheme.of(context).primaryBackground,
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 0.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .accent1,
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primary,
                                width: 2.0,
                              ),
                            ),
                            child: Image.asset(
                              'assets/images/044_error_not_found_page-1024.webp',
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bienvenido!',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.pressStart2p(
                                          fontWeight: FlutterFlowTheme.of(context)
                                              .headlineSmall.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .headlineSmall.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineSmall.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall.fontStyle,
                                      ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Level 7 Adventurer',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.pressStart2p(
                                          fontWeight: FlutterFlowTheme.of(context)
                                              .bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium.fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium.fontStyle,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 0.0),
                      child: Material(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeHeader(userName: 'John Doe'),
                            SizedBox(height: 16.0),
                            DailyProgress(
                              completedTasks: 5,
                              totalTasks: 10,
                              streakDays: 7,
                              dailyGoal: 8,
                            ),
                            SizedBox(height: 16.0),
                            Material(
                              child: QuickActions(
                                actions: [
                                  {
                                    'id': 'new_task',
                                    'title': 'New Task',
                                    'description': 'Create a new task',
                                    'icon': Icons.add_task,
                                  },
                                  {
                                    'id': 'view_stats',
                                    'title': 'View Stats',
                                    'description': 'Check your progress',
                                    'icon': Icons.bar_chart,
                                  },
                                ],
                                onActionPressed: (id) {
                                  // Handle action
                                },
                              ),
                            ),
                            SizedBox(height: 16.0),
                            Material(
                              child: RecentActivities(
                                activities: [
                                  {
                                    'title': 'Completed Task',
                                    'description': 'You completed "Daily Reflection"',
                                    'time': '2 hours ago',
                                    'icon': Icons.check_circle,
                                  },
                                  {
                                    'title': 'New Achievement',
                                    'description': 'You earned "Early Bird" badge',
                                    'time': '5 hours ago',
                                    'icon': Icons.emoji_events,
                                  },
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
