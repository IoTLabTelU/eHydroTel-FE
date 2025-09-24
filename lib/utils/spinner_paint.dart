import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpinnerPainter extends CustomPainter {
  final double t;
  final List<Color> gradientColors;

  SpinnerPainter(this.t, this.gradientColors);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final start = -math.pi / 2; // mulai dari atas biar natural
    final sweep = 2 * math.pi; // 270°

    final colors = [
      ...gradientColors,
      gradientColors.first, // duplikat biar transisi smooth
    ];

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: colors,
        startAngle: 0.0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(2 * math.pi * t),
        center: Alignment.center,
      ).createShader(rect.deflate(8));

    canvas.drawArc(rect.deflate(8), start, sweep, false, stroke);
  }

  @override
  bool shouldRepaint(covariant SpinnerPainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.gradientColors != gradientColors;
}
