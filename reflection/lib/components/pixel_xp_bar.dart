import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PixelXPBar extends StatelessWidget {
  final int xp;
  final int level;
  final double width;
  final double height;

  const PixelXPBar({
    super.key,
    required this.xp,
    required this.level,
    this.width = 200,
    this.height = 20,
  });

  int get _xpForNextLevel => level * 1000;
  double get _progress => xp / _xpForNextLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.accentColor,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Progress bar
          FractionallySizedBox(
            widthFactor: _progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // XP text
          Center(
            child: Text(
              '$xp / $_xpForNextLevel XP',
              style: AppTheme.bodyStyle.copyWith(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 