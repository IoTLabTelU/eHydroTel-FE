import 'package:flutter/material.dart';

class SpinnerPainter extends CustomPainter {
  final double t;
  final Color color;
  SpinnerPainter(this.t, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final rect = Offset.zero & size;
    final start = t * 6.28318; // 2π
    final sweep = 6.28318 * 0.6;
    canvas.drawArc(rect.deflate(8), start, sweep, false, stroke);
  }

  @override
  bool shouldRepaint(covariant SpinnerPainter oldDelegate) => oldDelegate.t != t || oldDelegate.color != color;
}
