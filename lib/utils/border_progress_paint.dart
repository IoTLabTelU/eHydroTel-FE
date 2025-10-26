import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';

class FluidProgressPainter extends CustomPainter {
  final double progress;
  final double waveOffset;
  final bool isFinished;

  FluidProgressPainter({required this.progress, required this.waveOffset, required this.isFinished});

  @override
  void paint(Canvas canvas, Size size) {
    final borderRadius = 21.0;
    final borderWidth = 6.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    // Base light border
    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = ColorValues.green200;

    canvas.drawRRect(rRect, backgroundPaint);

    // Path for border
    final Path customPath = _buildCustomPath(size, borderRadius);
    final pathMetric = customPath.computeMetrics().first;
    final drawLength = pathMetric.length * progress;
    final Path progressPath = pathMetric.extractPath(0, drawLength, startWithMoveTo: true);

    // Gradient shimmer/wave effect
    Paint progressPaint;
    if (!isFinished) {
      progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..shader = LinearGradient(
          colors: const [ColorValues.green500, ColorValues.green300],
          begin: Alignment(-1 + waveOffset * 2, 0),
          end: Alignment(1 + waveOffset * 2, 0),
        ).createShader(rect);
    } else {
      progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth
        ..color = ColorValues.green500;
    }

    canvas.drawPath(progressPath, progressPaint);
  }

  @override
  bool shouldRepaint(FluidProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.waveOffset != waveOffset;

  Path _buildCustomPath(Size size, double radius) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Start: LEFT CENTER
    path.moveTo(0, h / 2);

    // Go down (left edge)
    path.lineTo(0, h - radius);
    path.quadraticBezierTo(0, h, radius + 6, h); // bottom-left curve

    // Go right (bottom edge)
    path.lineTo(w - radius, h);
    path.quadraticBezierTo(w, h, w, h - radius - 6); // bottom-right curve

    // Go up (right edge)
    path.lineTo(w, radius);
    path.quadraticBezierTo(w, 0, w - radius - 6, 0); // top-right curve

    // Go left (top edge)
    path.lineTo(radius, 0);
    path.quadraticBezierTo(0, 0, 0, radius + 6); // top-left curve

    // Close back to starting point (LEFT CENTER)
    path.lineTo(0, h / 2);

    return path;
  }
}
