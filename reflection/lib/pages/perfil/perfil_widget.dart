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
  String userName = 'John Doe';
  String userMotto = '¡A por todas!';
  int level = 5;
  int experience = 1250;
  int xpToNextLevel = 1500;
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  File? avatarFile;

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
    // Aquí deberías limpiar el estado de usuario y navegar al login
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sesión cerrada (simulado)')),
    );
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        avatarFile = File(picked.path);
      });
    }
  }

  void _editName() async {
    final controller = TextEditingController(text: userName);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar nombre'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Nombre'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('Guardar')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() => userName = result.trim());
    }
  }

  void _editMotto() async {
    final controller = TextEditingController(text: userMotto);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar lema'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Lema personal'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(onPressed: () => Navigator.pop(context, controller.text), child: Text('Guardar')),
        ],
      ),
    );
    if (result != null && result.trim().isNotEmpty) {
      setState(() => userMotto = result.trim());
    }
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
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header editable
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 44,
                              backgroundImage: avatarFile != null
                                  ? FileImage(avatarFile!)
                                  : const AssetImage('assets/images/me.jpg') as ImageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickAvatar,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: theme.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Icon(Icons.edit, size: 18, color: theme.info),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Text(
                                      userName,
                                      style: theme.headlineSmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 20, color: theme.primary),
                                    tooltip: 'Editar nombre',
                                    onPressed: _editName,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: Text(
                                      userMotto,
                                      style: theme.bodyMedium.copyWith(color: theme.secondaryText),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 18, color: theme.primary),
                                    tooltip: 'Editar lema',
                                    onPressed: _editMotto,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              LinearPercentIndicator(
                                lineHeight: 16,
                                percent: xpPercent.clamp(0, 1),
                                backgroundColor: theme.accent2.withOpacity(0.2),
                                progressColor: theme.primary,
                                barRadius: const Radius.circular(8),
                                center: Text(
                                  'Nivel $level  ${experience}/$xpToNextLevel XP',
                                  style: theme.bodySmall.copyWith(fontFamily: 'VT323', color: theme.primaryText),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
