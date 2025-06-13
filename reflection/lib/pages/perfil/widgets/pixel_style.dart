import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'default_avatar.dart';

class PixelStyle {
  static const double pixelSize = 4.0;
  
  static BoxDecoration pixelBorder({
    Color color = Colors.white,
    double width = 2,
  }) {
    return BoxDecoration(
      border: Border.all(
        color: color,
        width: width,
      ),
      borderRadius: BorderRadius.circular(4),
    );
  }

  static BoxDecoration pixelBackground({
    Color color = Colors.black87,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    );
  }

  static TextStyle pixelText({
    double fontSize = 16,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  static Widget pixelButton({
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.blue,
    Color textColor = Colors.white,
    double fontSize = 16,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        text,
        style: pixelText(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }

  static Widget pixelProgressBar({
    required double progress,
    required double width,
    required double height,
    Color backgroundColor = Colors.grey,
    Color progressColor = Colors.blue,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          Container(
            width: width * progress,
            height: height,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  static Widget pixelCard({
    required Widget child,
    Color backgroundColor = Colors.black87,
    Color borderColor = Colors.white,
    double borderWidth = 2,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: child,
    );
  }

  static Widget pixelAvatar({
    String? imageUrl,
    double size = 100,
    Color borderColor = Colors.white,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: pixelBorder(color: borderColor),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: imageUrl != null
            ? Image.file(
                File(imageUrl),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const DefaultAvatar();
                },
              )
            : const DefaultAvatar(),
      ),
    );
  }
} 