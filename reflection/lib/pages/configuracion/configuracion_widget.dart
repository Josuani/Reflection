import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:reflection/components/pixel_avatar.dart';
import 'package:reflection/components/pixel_xp_bar.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/theme/app_theme.dart';

/// Design a settings page with a retro pixel art interface using cool tones
/// and 8-bit fonts.
///
/// The layout should include sections for user customization and app
/// preferences. Add editable fields for player name and personal motto, a
/// dropdown or toggle for language selection, and a switch to change between
/// light and dark theme. Include toggle buttons for sound and music effects
/// (on/off), and an optional "Reset Progress" button with a warning icon.
/// Style each section with pixel borders, soft blue backgrounds, and classic
/// video game UI elements. Keep the design clean, grid-aligned, and
/// nostalgic.
class ConfiguracionWidget extends StatefulWidget {
  const ConfiguracionWidget({super.key});

  static String routeName = 'Configuracion';
  static String routePath = '/Configuracion';

  @override
  State<ConfiguracionWidget> createState() => _ConfiguracionWidgetState();
}

class _ConfiguracionWidgetState extends State<ConfiguracionWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppTheme.getBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Consumer(
              builder: (context, ref, child) {
                final userProfile = ref.watch(userProfileProvider);
                return Row(
                  children: [
                    if (userProfile != null) ...[
                      PixelAvatar(avatarUrl: userProfile.avatarUrl, size: 32),
                      const SizedBox(width: 8),
                      Text(userProfile.displayName ?? 'Sin nombre', style: AppTheme.titleStyle),
                    ],
                    const SizedBox(width: 8),
                    Text('Configuración', style: AppTheme.titleStyle),
                  ],
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final userProfile = ref.watch(userProfileProvider);
                      if (userProfile == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppTheme.accentColor),
                        ),
                        child: Column(
                          children: [
                            PixelAvatar(avatarUrl: userProfile.avatarUrl, size: 48),
                            const SizedBox(height: 8),
                            Text(userProfile.displayName ?? 'Sin nombre', style: AppTheme.titleStyle),
                            const SizedBox(height: 4),
                            Text('Nivel ${userProfile.level}', style: AppTheme.subtitleStyle),
                            const SizedBox(height: 8),
                            PixelXPBar(xp: userProfile.xp, level: userProfile.level),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Perfil',
                    children: [
                      _buildSettingItem(
                        title: 'Nombre de usuario',
                        subtitle: 'Cambia tu nombre de usuario',
                        onTap: () {
                          // TODO: Implementar cambio de nombre
                        },
                      ),
                      _buildSettingItem(
                        title: 'Avatar',
                        subtitle: 'Cambia tu avatar',
                        onTap: () {
                          // TODO: Implementar cambio de avatar
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Preferencias',
                    children: [
                      _buildSettingItem(
                        title: 'Idioma',
                        subtitle: 'Español',
                        onTap: () {
                          // TODO: Implementar cambio de idioma
                        },
                      ),
                      _buildSettingItem(
                        title: 'Tema oscuro',
                        subtitle: 'Activar/desactivar tema oscuro',
                        onTap: () {
                          // TODO: Implementar cambio de tema
                        },
                      ),
                      _buildSettingItem(
                        title: 'Efectos de sonido',
                        subtitle: 'Activar/desactivar efectos de sonido',
                        onTap: () {
                          // TODO: Implementar efectos de sonido
                        },
                      ),
                      _buildSettingItem(
                        title: 'Música',
                        subtitle: 'Activar/desactivar música de fondo',
                        onTap: () {
                          // TODO: Implementar música
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Cuidado',
                    children: [
                      _buildSettingItem(
                        title: 'Reiniciar progreso',
                        subtitle: 'Eliminar todos los datos del juego',
                        onTap: () {
                          // TODO: Implementar reinicio
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Versión 1.0.0',
                      style: AppTheme.subtitleStyle.copyWith(
                        color: AppTheme.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.titleStyle),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.accentColor),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.subtitleStyle.copyWith(
                      color: isDestructive ? Colors.red : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTheme.bodyStyle,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDestructive ? Colors.red : AppTheme.accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
