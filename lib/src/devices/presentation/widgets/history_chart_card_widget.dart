import 'package:flutter/material.dart';
import 'package:hydro_iot/utils/sparkline_paint.dart';
import 'package:intl/intl.dart';

import '../../../../res/res.dart';

class HistoryChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<double> series;
  final double yMin;
  final double yMax;
  final String unit;
  final Color accent;
  final List<DateTime> timestamps;

  const HistoryChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.series,
    required this.yMin,
    required this.yMax,
    required this.unit,
    required this.accent,
    required this.timestamps,
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
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 8))],
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
                width: double.infinity,
                height: 180,
                child: SparklineChart(
                  series: series,
                  color: accent,
                  yMin: yMin,
                  yMax: yMax,
                  unit: unit,
                  timestamps: timestamps,
                ),
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
class SparklineChart extends StatefulWidget {
  final List<double> series;
  final double yMin;
  final double yMax;
  final String unit;
  final Color color;
  final List<DateTime> timestamps;

  const SparklineChart({
    super.key,
    required this.series,
    required this.yMin,
    required this.yMax,
    required this.unit,
    required this.color,
    required this.timestamps,
  });

  @override
  State<SparklineChart> createState() => _SparklineChartState();
}

class _SparklineChartState extends State<SparklineChart> {
  int? _hoverIndex;
  Offset? _tapPosition;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return GestureDetector(
          onTapDown: (details) {
            final box = context.findRenderObject() as RenderBox;
            final localPos = box.globalToLocal(details.globalPosition);
            _handleTap(localPos, box.size);
          },
          child: Stack(
            children: [
              // Chart + highlight
              CustomPaint(
                painter: SparklinePainter(
                  series: widget.series,
                  t: t,
                  yMin: widget.yMin,
                  yMax: widget.yMax,
                  color: widget.color,
                  highlightIndex: _hoverIndex,
                ),
                size: const Size(double.infinity, double.infinity),
              ),

              // Tooltip
              if (_hoverIndex != null && _tapPosition != null)
                Positioned(
                  left: _tapPosition!.dx - 35,
                  top: _tapPosition!.dy - 45,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: 1,
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${widget.series[_hoverIndex!].toStringAsFixed(2)}${widget.unit}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              DateFormat('dd/MMM/yy HH:mm').format(widget.timestamps[_hoverIndex!]),
                              style: const TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handleTap(Offset pos, Size size) {
    if (widget.series.isEmpty) return;
    final dxStep = size.width / (widget.series.length - 1);
    int index = (pos.dx / dxStep).round().clamp(0, widget.series.length - 1);

    double normalize(double v) {
      if (widget.yMax - widget.yMin == 0) return 0.5;
      return (v - widget.yMin) / (widget.yMax - widget.yMin);
    }

    final norm = 1 - normalize(widget.series[index]).clamp(0.0, 1.0);
    final y = norm * size.height;

    setState(() {
      _hoverIndex = index;
      _tapPosition = Offset(index * dxStep, y);
    });
  }
}
