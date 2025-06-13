import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflection/pages/perfil/edit_profile_page.dart';
import 'widgets/pixel_style.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);
    final profile = provider.profile;
    final achievements = provider.achievements;
    final themeColor = Color(int.parse(provider.themeColor.replaceFirst('#', '0xff')));
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: profile == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar pixel-art
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: themeColor,
                      child: Icon(Icons.person, size: 48, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),
                    // Nombre y lema
                    Text(profile.displayName, style: PixelStyle.pixelText(fontSize: 24)),
                    if (profile.description != null && profile.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          profile.description!,
                          style: PixelStyle.pixelText(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Barra de XP
                    PixelStyle.pixelProgressBar(
                      progress: (profile.xp % 100) / 100.0,
                      width: 220,
                      height: 18,
                      backgroundColor: Colors.grey[300]!,
                      progressColor: themeColor,
                    ),
                    const SizedBox(height: 8),
                    Text('Nivel ${profile.level}  |  XP: ${profile.xp}', style: PixelStyle.pixelText(fontSize: 14)),
                    const SizedBox(height: 16),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelStyle.pixelCard(
                          child: Column(
                            children: [
                              Text('Racha', style: PixelStyle.pixelText(fontSize: 12)),
                              Text('${profile.streak} días', style: PixelStyle.pixelText(fontSize: 16)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        PixelStyle.pixelCard(
                          child: Column(
                            children: [
                              Text('Misiones', style: PixelStyle.pixelText(fontSize: 12)),
                              Text('${provider.missionsCompleted}', style: PixelStyle.pixelText(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Preferencias
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PixelStyle.pixelCard(
                          child: Column(
                            children: [
                              Text('Idioma', style: PixelStyle.pixelText(fontSize: 12)),
                              Text(provider.language, style: PixelStyle.pixelText(fontSize: 14)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        PixelStyle.pixelCard(
                          child: Column(
                            children: [
                              Text('Sonido', style: PixelStyle.pixelText(fontSize: 12)),
                              Icon(provider.soundEnabled ? Icons.volume_up : Icons.volume_off, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Botón Editar Perfil
                    PixelStyle.pixelButton(
                      text: 'Editar Perfil',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditProfilePage()),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // Grid de logros
                    Text('Logros', style: PixelStyle.pixelText(fontSize: 18)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: achievements.length,
                      itemBuilder: (context, i) {
                        final ach = achievements[i];
                        return PixelStyle.pixelCard(
                          backgroundColor: Colors.amber,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.emoji_events, color: Colors.deepOrange, size: 32),
                              const SizedBox(height: 4),
                              Text(
                                ach,
                                style: PixelStyle.pixelText(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 