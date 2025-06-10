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
import '../home/widgets/home_header.dart';
import '../home/widgets/daily_progress.dart';
import '../home/widgets/quick_actions.dart';
import '../home/widgets/recent_activities.dart';
export 'home_page_model.dart';

/// Explora, reflexiona y crece en tu viaje personal
///
class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  static const String routeName = 'homePage';
  static const String routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        color: theme.primaryBackground,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              children: [
                // Header pixel-art
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    border: Border.all(color: theme.accent2, width: 4),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accent2.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: HomeHeader(
                    userName: 'John Doe',
                    avatarUrl: 'assets/images/me.jpg',
                    level: 7,
                  ),
                ),
                const SizedBox(height: 32),
                // Progreso diario
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.alternate,
                    border: Border.all(color: theme.accent2, width: 3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DailyProgress(
                    completedTasks: 5,
                    totalTasks: 10,
                    streakDays: 7,
                    dailyGoal: 8,
                  ),
                ),
                const SizedBox(height: 32),
                // Acciones rápidas
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.secondaryBackground,
                    border: Border.all(color: theme.accent2, width: 3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: QuickActions(
                    actions: [
                      {
                        'id': 'new_task',
                        'title': 'Nueva tarea',
                        'description': 'Crea una nueva tarea',
                        'icon': Icons.add_task,
                      },
                      {
                        'id': 'view_stats',
                        'title': 'Ver estadísticas',
                        'description': 'Consulta tu progreso',
                        'icon': Icons.bar_chart,
                      },
                    ],
                    onActionPressed: (id) {
                      // TODO: Implementar acción
                    },
                  ),
                ),
                const SizedBox(height: 32),
                // Actividades recientes
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.alternate,
                    border: Border.all(color: theme.accent2, width: 3),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: RecentActivities(
                    activities: [
                      {
                        'title': 'Tarea completada',
                        'description': 'Completaste "Reflexión diaria"',
                        'time': 'hace un momento',
                        'icon': Icons.check_circle,
                      },
                      {
                        'title': 'Nuevo logro',
                        'description': 'Obtuviste la medalla "Madrugador"',
                        'time': 'hace un momento',
                        'icon': Icons.emoji_events,
                      },
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
