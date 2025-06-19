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
import 'package:firebase_auth/firebase_auth.dart';
import '/services/database_service.dart';
import 'home_page_model.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/daily_progress.dart';
import '../home/widgets/quick_actions.dart';
import '../home/widgets/recent_activities.dart';
export 'home_page_model.dart';

/// Explora, reflexiona y crece en tu viaje personal
///
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static const String routeName = 'homePage';
  static const String routePath = '/home';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        final doc = await DatabaseService().readUsuario(userId);
        if (mounted) {
          setState(() {
            _userData = doc.data() as Map<String, dynamic>?;
            _isLoading = false;
          });
        }
        
        // Si no hay datos del usuario, crear un usuario de prueba
        if (_userData == null) {
          await _createTestUser(userId);
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Usuario no autenticado';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar datos: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createTestUser(String userId) async {
    try {
      await DatabaseService().updateUsuario(userId, {
        'nombre': 'Usuario',
        'descripcion': 'Bienvenido a Reflection',
        'nivel': 1,
        'puntos': 0,
        'avatar': 'assets/images/reflection_icon_clean.png',
        'fechaCreacion': DateTime.now().toIso8601String(),
        'ultimaActividad': DateTime.now().toIso8601String(),
      });
      
      // Recargar datos después de crear el usuario
      await _loadUserData();
    } catch (e) {
      print('Error al crear usuario de prueba: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.error),
            SizedBox(height: 16),
            Text('Error: $_errorMessage'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserData,
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

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
                    userName: _userData?['nombre'] ?? 'Usuario',
                    level: _userData?['nivel'] ?? 1,
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
                        'color': Colors.blue,
                      },
                      {
                        'id': 'view_stats',
                        'title': 'Ver estadísticas',
                        'description': 'Consulta tu progreso',
                        'icon': Icons.bar_chart,
                        'color': Colors.green,
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
                        'timestamp': DateTime.now().subtract(Duration(minutes: 5)),
                        'xpReward': 50,
                      },
                      {
                        'title': 'Nuevo logro',
                        'description': 'Obtuviste la medalla "Madrugador"',
                        'time': 'hace un momento',
                        'icon': Icons.emoji_events,
                        'timestamp': DateTime.now().subtract(Duration(hours: 1)),
                        'xpReward': 100,
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
