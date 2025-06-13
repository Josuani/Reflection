import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import 'package:reflection/components/pixel_avatar.dart';
import 'package:reflection/components/pixel_xp_bar.dart';
import 'package:reflection/providers/user_profile_provider_riverpod.dart';
import 'package:reflection/theme/app_theme.dart';

class Misiones2Widget extends ConsumerStatefulWidget {
  const Misiones2Widget({Key? key}) : super(key: key);

  @override
  ConsumerState<Misiones2Widget> createState() => _Misiones2WidgetState();
}

class _Misiones2WidgetState extends ConsumerState<Misiones2Widget> {
  final List<Map<String, dynamic>> _availableMissions = [];
  final List<Map<String, dynamic>> _inProgressMissions = [];
  final List<Map<String, dynamic>> _completedMissions = [];

  @override
  void initState() {
    super.initState();
    _loadMissions();
  }

  void _loadMissions() {
    // TODO: Implementar carga de misiones
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    
    return userProfileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
      data: (userProfile) {
        if (userProfile == null) {
          return const Center(child: Text('No hay perfil de usuario'));
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Misiones'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceColor.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.accentColor),
                    ),
                    child: Column(
                      children: [
                        PixelAvatar(
                          avatarUrl: userProfile.avatarUrl,
                          size: 64,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          userProfile.displayName ?? 'Sin nombre',
                          style: AppTheme.titleStyle,
                        ),
                        const SizedBox(height: 8),
                        PixelXPBar(
                          xp: userProfile.xp,
                          level: userProfile.level,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildMissionList(_availableMissions, 'disponible'),
                  _buildMissionList(_inProgressMissions, 'en_progreso'),
                  _buildMissionList(_completedMissions, 'completado'),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // TODO: Implementar creación de misión
            },
            backgroundColor: AppTheme.accentColor,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildMissionList(List<Map<String, dynamic>> missions, String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          status == 'disponible'
              ? 'Misiones disponibles'
              : status == 'en_progreso'
                  ? 'Misiones en progreso'
                  : 'Misiones completadas',
          style: AppTheme.titleStyle,
        ),
        const SizedBox(height: 8),
        if (missions.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.accentColor),
            ),
            child: Center(
              child: Text(
                'No hay misiones ${status == 'disponible' ? 'disponibles' : status == 'en_progreso' ? 'en progreso' : 'completadas'}',
                style: AppTheme.bodyStyle,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: missions.length,
            itemBuilder: (context, index) {
              final mission = missions[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mission['title'] ?? '', style: AppTheme.subtitleStyle),
                    const SizedBox(height: 4),
                    Text(mission['description'] ?? '', style: AppTheme.bodyStyle),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (status == 'disponible')
                          TextButton(
                            onPressed: () {
                              // TODO: Implementar aceptar misión
                            },
                            child: const Text('Aceptar'),
                          )
                        else if (status == 'en_progreso')
                          TextButton(
                            onPressed: () {
                              // TODO: Implementar completar misión
                            },
                            child: const Text('Completar'),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        const SizedBox(height: 24),
      ],
    );
  }
}
