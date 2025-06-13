import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ProfileHeader extends StatelessWidget {
  final String? profileImagePath;
  final VoidCallback onImageTap;

  const ProfileHeader({
    Key? key,
    this.profileImagePath,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GestureDetector(
            onTap: onImageTap,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: _buildProfileImage(),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Usuario',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (profileImagePath != null && profileImagePath!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Descripción del usuario',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem(
                context,
                'Misiones Completadas',
                '${0}/${0}',
              ),
              const SizedBox(width: 24),
              _buildStatItem(
                context,
                'Tasa de Completado',
                '${0.0}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (profileImagePath == null || profileImagePath!.isEmpty) {
      return const Icon(
        Icons.person,
        size: 50,
        color: Colors.grey,
      );
    }

    try {
      if (kIsWeb) {
        // Para web, asumimos que es una URL o base64
        if (profileImagePath!.startsWith('http')) {
          return ClipOval(
            child: Image.network(
              profileImagePath!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          );
        } else {
          // Base64 para web
          final bytes = base64Decode(profileImagePath!);
          return ClipOval(
            child: Image.memory(
              bytes,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          );
        }
      } else {
        // Para móvil/desktop, asumimos que es una ruta de archivo o base64
        if (profileImagePath!.startsWith('/')) {
          return ClipOval(
            child: Image.file(
              File(profileImagePath!),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          );
        } else {
          // Base64 para móvil/desktop
          final bytes = base64Decode(profileImagePath!);
          return ClipOval(
            child: Image.memory(
              bytes,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          );
        }
      }
    } catch (e) {
      return const Icon(
        Icons.person,
        size: 50,
        color: Colors.grey,
      );
    }
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
} 