import 'package:flutter/material.dart';

class SparklinePainter extends CustomPainter {
  final List<double> series;
  final double t; // animation progress 0..1
  final double yMin;
  final double yMax;
  final Color color;
  SparklinePainter({required this.series, required this.t, required this.yMin, required this.yMax, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty) return;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    double dxStep = size.width / (series.length - 1);
    double _normalize(double v) => (v - yMin) / (yMax - yMin);

    for (int i = 0; i < (series.length * t).clamp(1, series.length).toInt(); i++) {
      double x = i * dxStep;
      double norm = 1 - _normalize(series[i]).clamp(0.0, 1.0);
      double y = norm * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    // close fill
    fillPath.lineTo(((series.length - 1) * dxStep * t), size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) => oldDelegate.t != t || oldDelegate.series != series;
}
