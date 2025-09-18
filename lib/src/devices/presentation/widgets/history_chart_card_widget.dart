import 'package:flutter/material.dart';
import 'package:hydro_iot/utils/sparkline_paint.dart';

import '../../../../res/res.dart';

class HistoryChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<double> series;
  final double yMin;
  final double yMax;
  final String unit;
  final Color accent;

  const HistoryChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.series,
    required this.yMin,
    required this.yMax,
    required this.unit,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 24,
                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(subtitle, style: const TextStyle(color: ColorValues.neutral500, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 180,
                child: SparklineChart(series: series, color: accent, yMin: yMin, yMax: yMax, unit: unit),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _LegendDot(color: accent, label: 'Actual'),
                  Text(
                    'Avg: ${_avg(series).toStringAsFixed(2)}$unit',
                    style: const TextStyle(color: ColorValues.neutral600),
                  ),
                  Text(
                    'Last: ${series.last.toStringAsFixed(2)}$unit',
                    style: const TextStyle(color: ColorValues.neutral600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _avg(List<double> s) => s.isEmpty ? 0 : s.reduce((a, b) => a + b) / s.length;
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: ColorValues.neutral700)),
      ],
    );
  }
}

// Minimal custom sparkline chart without external packages
class SparklineChart extends StatelessWidget {
  final List<double> series;
  final double yMin;
  final double yMax;
  final String unit;
  final Color color;
  const SparklineChart({
    super.key,
    required this.series,
    required this.yMin,
    required this.yMax,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return CustomPaint(
          painter: SparklinePainter(series: series, t: t, yMin: yMin, yMax: yMax, color: color),
        );
      },
    );
  }
}
