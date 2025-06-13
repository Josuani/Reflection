import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SidebarProfile extends StatelessWidget {
  final bool isExpanded;

  const SidebarProfile({
    Key? key,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final userProfile = ref.watch(userProfileProvider);
        return Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildProfileImage(userProfile?.profileImage),
              if (isExpanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userProfile?.displayName ?? 'Usuario',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (userProfile?.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          userProfile!.description!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const CircleAvatar(
        radius: 20,
        child: Icon(Icons.person, size: 20),
      );
    }

    try {
      if (kIsWeb) {
        // Para web, asumimos que es una URL o base64
        if (imagePath.startsWith('http')) {
          return CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imagePath),
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Error loading network image: $exception');
            },
            child: const Icon(Icons.person, size: 20),
          );
        } else {
          // Base64 para web
          final bytes = base64Decode(imagePath);
          return CircleAvatar(
            radius: 20,
            backgroundImage: MemoryImage(bytes),
            onBackgroundImageError: (exception, stackTrace) {
              debugPrint('Error loading memory image: $exception');
            },
            child: const Icon(Icons.person, size: 20),
          );
        }
      } else {
        // Para móvil/desktop, asumimos que es base64
        final bytes = base64Decode(imagePath);
        return CircleAvatar(
          radius: 20,
          backgroundImage: MemoryImage(bytes),
          onBackgroundImageError: (exception, stackTrace) {
            debugPrint('Error loading memory image: $exception');
          },
          child: const Icon(Icons.person, size: 20),
        );
      }
    } catch (e) {
      debugPrint('Error building profile image: $e');
      return const CircleAvatar(
        radius: 20,
        child: Icon(Icons.person, size: 20),
      );
    }
  }
} 