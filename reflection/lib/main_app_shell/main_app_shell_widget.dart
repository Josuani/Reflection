import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reflection/components/pixel_avatar.dart';
import 'package:reflection/components/connection_status.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/theme/app_theme.dart';

class MainAppShellWidget extends StatelessWidget {
  final Widget child;

  const MainAppShellWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(
                right: BorderSide(
                  color: AppTheme.accentColor,
                  width: 2,
                ),
              ),
            ),
            child: Column(
              children: [
                // Connection status
                const ConnectionStatus(),
                // User profile section
                Consumer<UserProfileProvider>(
                  builder: (context, userProfileProvider, _) {
                    if (userProfileProvider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (userProfileProvider.error != null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Error: ${userProfileProvider.error}',
                              style: AppTheme.bodyStyle.copyWith(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    final user = userProfileProvider.userProfile;
                    if (user == null) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.account_circle_outlined,
                              size: 64,
                              color: AppTheme.accentColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'No hay usuario',
                              style: AppTheme.titleStyle,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implement login navigation
                                context.go('/login');
                              },
                              child: const Text('Iniciar Sesión'),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          PixelAvatar(avatarUrl: user.avatarUrl, size: 64),
                          const SizedBox(height: 8),
                          Text(
                            user.displayName ?? 'Sin nombre',
                            style: AppTheme.titleStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Nivel ${user.level}',
                            style: AppTheme.subtitleStyle,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () => userProfileProvider.signOut(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.withOpacity(0.1),
                              foregroundColor: Colors.red,
                            ),
                            child: const Text('Cerrar Sesión'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(color: AppTheme.accentColor),
                // Navigation items
                _NavigationItem(
                  icon: Icons.home,
                  label: 'Inicio',
                  onTap: () => context.go('/'),
                ),
                _NavigationItem(
                  icon: Icons.assignment,
                  label: 'Misiones',
                  onTap: () => context.go('/misiones'),
                ),
                _NavigationItem(
                  icon: Icons.person,
                  label: 'Perfil',
                  onTap: () => context.go('/perfil'),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentColor),
      title: Text(label, style: AppTheme.bodyStyle),
      onTap: onTap,
      hoverColor: AppTheme.accentColor.withOpacity(0.1),
    );
  }
} 