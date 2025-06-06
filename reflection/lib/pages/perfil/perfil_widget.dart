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
import 'perfil_model.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_stats.dart';
import 'widgets/profile_achievements.dart';
import 'widgets/profile_settings.dart';
export 'perfil_model.dart';

/// Design a user profile screen with a retro, pixel art aesthetic.
///
/// Include the player's avatar with an edit option, a visible experience (XP)
/// bar showing the current level, and key stats such as completed quests,
/// achieved goals, active streak, and unlocked achievements. Add personal
/// metrics like willpower and discipline displayed in clean stat cards. Also
/// include editable fields like player name, personal motto, and a theme
/// settings button. Use cool tones, pixelated 8-bit typography, and a clear
/// layout inspired by classic video games.
class PerfilWidget extends StatefulWidget {
  const PerfilWidget({super.key});

  static String routeName = 'Perfil';
  static String routePath = '/Perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for achievements
  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Primera Reflexión',
      'description': 'Completa tu primera reflexión diaria',
      'icon': Icons.star,
      'isUnlocked': true,
      'xpReward': 50,
    },
    {
      'title': 'Guerrero Semanal',
      'description': 'Completa 7 reflexiones diarias seguidas',
      'icon': Icons.local_fire_department,
      'isUnlocked': true,
      'xpReward': 100,
    },
    {
      'title': 'Establecedor de Metas',
      'description': 'Establece y completa 5 metas semanales',
      'icon': Icons.flag,
      'isUnlocked': false,
      'xpReward': 200,
    },
    {
      'title': 'Maestro de la Reflexión',
      'description': 'Completa 30 reflexiones diarias',
      'icon': Icons.emoji_events,
      'isUnlocked': false,
      'xpReward': 500,
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _handleNotificationsChanged(bool value) {
    setState(() {
      _model.notificationsEnabled = value;
    });
  }

  void _handleDarkModeChanged(bool value) {
    setState(() {
      _model.darkModeEnabled = value;
    });
  }

  void _handleLogout() {
    // TODO: Implement logout functionality
    print('Logout pressed');
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ProfileHeader(
                        profileImagePath: 'assets/images/me.jpg',
                        userName: 'John Doe',
                        userEmail: 'john.doe@example.com',
                        level: 5,
                        experience: 1250,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: ProfileStats(
                          completedMissions: 12,
                          totalMissions: 20,
                          streakDays: 7,
                          totalExperience: 1250,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: ProfileAchievements(
                          achievements: _achievements,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: ProfileSettings(
                          notificationsEnabled: _model.notificationsEnabled,
                          darkModeEnabled: _model.darkModeEnabled,
                          onNotificationsChanged: _handleNotificationsChanged,
                          onDarkModeChanged: _handleDarkModeChanged,
                          onLogout: _handleLogout,
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
