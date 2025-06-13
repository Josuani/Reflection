import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflection/providers/user_profile_provider.dart';
import 'package:reflection/theme/app_theme.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userProfile = ref.watch(userProfileProvider);
        if (!userProfile.isOffline) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.orange.withOpacity(0.1),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off,
                color: Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Modo sin conexión',
                style: AppTheme.bodyStyle.copyWith(
                  color: Colors.orange,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => userProfile.syncPendingChanges(),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Sincronizar',
                  style: AppTheme.bodyStyle.copyWith(
                    color: Colors.orange,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 