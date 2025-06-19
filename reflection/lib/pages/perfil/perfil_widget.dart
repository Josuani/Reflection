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
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:reflection/services/database_service.dart';
import 'package:reflection/auth/firebase_auth/auth_util.dart';
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

  static String routeName = 'perfil';
  static String routePath = '/app/home/perfil';

  @override
  State<PerfilWidget> createState() => _PerfilWidgetState();
}

class _PerfilWidgetState extends State<PerfilWidget> {
  late PerfilModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Key _futureKey = UniqueKey();
  int level = 5;
  int experience = 1250;
  int xpToNextLevel = 1500;
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si volvemos de editar perfil, forzamos refresco
    setState(() {
      _futureKey = UniqueKey();
    });
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
    // Aquí deberías limpiar el estado de usuario y navegar al login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sesión cerrada (simulado)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final xpPercent = experience / xpToNextLevel;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              context.go('/app/home');
            },
          ),
          title: Text(
            'Perfil',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
              fontFamily: 'Outfit',
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder(
            key: _futureKey,
            future: DatabaseService().readUsuario(currentUserUid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error al cargar perfil'));
              }
              final userData = snapshot.data?.data() as Map<String, dynamic>?;
              final userName = (userData?['nombre'] ?? '').toString().trim().isEmpty ? 'Sin nombre' : userData?['nombre'];
              final userMotto = (userData?['descripcion'] ?? '').toString().trim().isEmpty ? 'Sin descripción' : userData?['descripcion'];
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header editable (solo visual)
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: theme.headlineMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: theme.headlineMedium.fontStyle,
                                ),
                                color: theme.primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Nivel ${userData?['nivel'] ?? 1}',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.pressStart2p(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                color: theme.secondaryText,
                                fontSize: 14.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Estadísticas y logros
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatCard(label: 'Reflexiones', value: '30', icon: Icons.edit_note, theme: theme),
                          _StatCard(label: 'Metas', value: '5', icon: Icons.flag, theme: theme),
                          _StatCard(label: 'Racha', value: '7', icon: Icons.local_fire_department, theme: theme),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Logros
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Logros desbloqueados', style: theme.titleMedium.copyWith(fontFamily: 'VT323', color: theme.primary)),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _achievements.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, i) {
                            final a = _achievements[i];
                            return _AchievementCard(
                              title: a['title'],
                              description: a['description'],
                              icon: a['icon'],
                              unlocked: a['isUnlocked'],
                              xp: a['xpReward'],
                              theme: theme,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Configuración
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Configuración', style: theme.titleMedium.copyWith(fontFamily: 'VT323', color: theme.primary)),
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: Text('Notificaciones', style: theme.bodyMedium),
                        value: notificationsEnabled,
                        onChanged: (v) => setState(() => notificationsEnabled = v),
                        activeColor: theme.primary,
                      ),
                      SwitchListTile(
                        title: Text('Modo oscuro', style: theme.bodyMedium),
                        value: darkModeEnabled,
                        onChanged: (v) => setState(() => darkModeEnabled = v),
                        activeColor: theme.primary,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.error,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        onPressed: _handleLogout,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final FlutterFlowTheme theme;
  const _StatCard({required this.label, required this.value, required this.icon, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border.all(color: theme.accent2, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.accent2.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: theme.primary, size: 32),
          const SizedBox(height: 8),
          Text(value, style: theme.titleMedium.copyWith(fontFamily: 'VT323', color: theme.primary)),
          const SizedBox(height: 4),
          Text(label, style: theme.bodySmall.copyWith(color: theme.secondaryText)),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final int xp;
  final FlutterFlowTheme theme;
  const _AchievementCard({required this.title, required this.description, required this.icon, required this.unlocked, required this.xp, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      constraints: const BoxConstraints(minHeight: 100, maxHeight: 120),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: unlocked ? theme.accent1 : theme.secondaryBackground,
        border: Border.all(color: unlocked ? theme.primary : theme.accent2, width: 2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.accent2.withOpacity(0.08),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: unlocked ? theme.primary : theme.secondaryText, size: 28),
              const SizedBox(width: 8),
              Text('+${xp}xp', style: theme.bodySmall.copyWith(color: theme.primary)),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              title,
              style: theme.titleSmall.copyWith(fontFamily: 'VT323', color: unlocked ? theme.primaryText : theme.secondaryText, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 4),
          Flexible(
            child: Text(
              description,
              style: theme.bodySmall.copyWith(color: theme.secondaryText, fontSize: 12),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

