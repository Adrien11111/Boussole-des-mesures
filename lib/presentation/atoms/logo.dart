import 'package:flutter/material.dart';

/// Boussole : cercle + aiguille (même dessin que l'ancienne app).
class Logo extends StatelessWidget {
  const Logo({super.key, required this.color, this.size = 22});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _LogoPainter(color));
}

class _LogoPainter extends CustomPainter {
  _LogoPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 24;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * k;
    canvas.drawCircle(Offset(12 * k, 12 * k), 10 * k, stroke);
    final needle = Path()
      ..moveTo(15.5 * k, 8.5 * k)
      ..lineTo(13 * k, 13 * k)
      ..lineTo(8.5 * k, 15.5 * k)
      ..lineTo(11 * k, 11 * k)
      ..close();
    canvas.drawPath(needle, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_LogoPainter old) => old.color != color;
}
