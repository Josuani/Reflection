import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflection/components/pixel_avatar.dart';
import 'package:reflection/components/pixel_xp_bar.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/theme/app_theme.dart';
import '../home/widgets/home_header.dart';
import '../home/widgets/daily_progress.dart';
import '../home/widgets/quick_actions.dart';
import '../home/widgets/recent_activities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflection/providers/user_profile_provider_riverpod.dart';
export 'home_page_model.dart';

/// Explora, reflexiona y crece en tu viaje personal
///
class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget> {
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
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      PixelAvatar(
                        avatarUrl: userProfile.avatarUrl,
                        size: 60,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userProfile.displayName ?? 'Sin nombre',
                              style: AppTheme.titleStyle,
                            ),
                            const SizedBox(height: 4),
                            PixelXPBar(
                              xp: userProfile.xp,
                              level: userProfile.level,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text('Misiones recientes', style: AppTheme.titleStyle),
                  const SizedBox(height: 8),
                  // TODO: Implementar lista de misiones recientes
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
