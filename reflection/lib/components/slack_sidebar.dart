import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/services/database_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:go_router/go_router.dart';

class SlackSidebar extends StatefulWidget {
  final List<dynamic> destinations;
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SlackSidebar({
    Key? key,
    required this.destinations,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  State<SlackSidebar> createState() => _SlackSidebarState();
}

class _SlackSidebarState extends State<SlackSidebar> {
  bool _expanded = true;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

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
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
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
    final width = _expanded ? 220.0 : 72.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        border: Border(
          right: BorderSide(color: theme.accent2, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accent2.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header con toggle button
          Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              border: Border(
                bottom: BorderSide(
                  color: theme.accent2.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: _expanded ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
              children: [
                if (_expanded) ...[
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.auto_awesome,
                            color: theme.primary.withOpacity(0.7),
                            size: 16,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Reflection',
                            style: GoogleFonts.pressStart2p(
                              textStyle: theme.headlineSmall.copyWith(
                                color: theme.primary,
                                fontSize: 13.5,
                                height: 1,
                                letterSpacing: 0,
                              ),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        color: theme.primary,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        setState(() {
                          _expanded = false;
                        });
                      },
                    ),
                  ),
                ] else ...[
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: theme.primary,
                        size: 22,
                      ),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        setState(() {
                          _expanded = true;
                        });
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(height: 1),

          // Lista de destinos
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 12),
              itemCount: widget.destinations.length,
              itemBuilder: (context, index) {
                final item = widget.destinations[index];
                final selected = index == widget.selectedIndex;
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _expanded ? 8.0 : 1.0,
                    vertical: 4.0,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onItemSelected(index),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _expanded ? 12 : 2,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? theme.primary.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: selected ? Border.all(
                            color: theme.primary.withOpacity(0.2),
                            width: 1,
                          ) : null,
                          boxShadow: selected ? [
                            BoxShadow(
                              color: theme.primary.withOpacity(0.05),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: _expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              color: selected ? theme.primary : theme.secondaryText,
                              size: 22,
                            ),
                            if (_expanded) ...[
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: theme.titleSmall.copyWith(
                                    color: selected ? theme.primary : theme.secondaryText,
                                    fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Perfil abajo
          Container(
            decoration: BoxDecoration(
              color: theme.secondaryBackground,
              border: Border(
                top: BorderSide(
                  color: theme.accent2.withOpacity(0.1),
                  width: 2,
                ),
              ),
            ),
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _userData?['nombre'] ?? 'Usuario',
                                style: theme.labelLarge.copyWith(
                                  color: theme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Nivel ${_userData?['nivel'] ?? 1}',
                                style: theme.labelSmall.copyWith(
                                  color: theme.secondaryText,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.logout, color: theme.secondaryText, size: 20),
                            tooltip: 'Cerrar sesión',
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            onPressed: () async {
                              await authManager.signOut();
                              if (mounted) {
                                context.go('/LoginReflection');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                    child: Center(
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.logout, color: theme.secondaryText, size: 20),
                          tooltip: 'Cerrar sesión',
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          onPressed: () async {
                            await authManager.signOut();
                            if (mounted) {
                              context.go('/LoginReflection');
                            }
                          },
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
} 