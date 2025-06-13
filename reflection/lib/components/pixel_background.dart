import 'package:flutter/material.dart';

class PixelBackground extends StatelessWidget {
  const PixelBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PixelBackgroundPainter(),
      child: Container(),
    );
  }
}

class PixelBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..style = PaintingStyle.fill;

    // Draw base background
    canvas.drawRect(Offset.zero & size, paint);

    // Draw pixel pattern
    final pixelSize = 8.0;
    final pixelPaint = Paint()
      ..color = const Color(0xFF34495E)
      ..style = PaintingStyle.fill;

    for (var x = 0.0; x < size.width; x += pixelSize * 2) {
      for (var y = 0.0; y < size.height; y += pixelSize * 2) {
        if ((x + y) % (pixelSize * 4) == 0) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, pixelSize, pixelSize),
            pixelPaint,
          );
        }
      }
    }

    // Draw grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF4A90E2).withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var x = 0.0; x < size.width; x += pixelSize * 4) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (var y = 0.0; y < size.height; y += pixelSize * 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 