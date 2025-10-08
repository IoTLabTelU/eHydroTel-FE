import 'package:flutter/material.dart';

class SparklinePainter extends CustomPainter {
  final List<double> series;
  final double t;
  final double yMin;
  final double yMax;
  final Color color;
  final int? highlightIndex;

  SparklinePainter({
    required this.series,
    required this.t,
    required this.yMin,
    required this.yMax,
    required this.color,
    this.highlightIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (series.isEmpty || series.length < 2) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final fill = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();

    final dxStep = size.width / (series.length - 1);
    double normalize(double v) {
      if (yMax - yMin == 0) return 0.5;
      return (v - yMin) / (yMax - yMin);
    }

    int end = (series.length * t).clamp(2, series.length.toDouble()).toInt();

    for (int i = 0; i < end; i++) {
      final x = i * dxStep;
      final norm = 1 - normalize(series[i]).clamp(0.0, 1.0);
      final y = norm * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // 🎯 Gambar titik highlight kalau index ini dipilih
      if (highlightIndex != null && i == highlightIndex) {
        final circlePaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        final outline = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(Offset(x, y), 5, circlePaint);
        canvas.drawCircle(Offset(x, y), 5, outline);
      }
    }

    fillPath.lineTo(path.getBounds().right, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fill);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter old) =>
      old.t != t || old.series != series || old.highlightIndex != highlightIndex;
}
