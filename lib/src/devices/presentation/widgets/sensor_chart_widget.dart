// lib/src/devices/presentation/history/sensor_chart.dart
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/history_entity.dart';
import '../screens/history/sensor_history_screen.dart';

class SensorChart extends StatelessWidget {
  final ChartType chartType;
  final List<HistoryEntity> history;

  const SensorChart({super.key, required this.chartType, required this.history});

  double _valueFor(HistoryEntity h) => chartType == ChartType.ph ? h.phAvg : h.ppmAvg;
  double _minFor(HistoryEntity h) => chartType == ChartType.ph ? h.phMin : h.ppmMin;
  double _maxFor(HistoryEntity h) => chartType == ChartType.ph ? h.phMax : h.ppmMax;

  @override
  Widget build(BuildContext context) {
    final spotsAvg = history.map((h) => FlSpot(h.time.millisecondsSinceEpoch.toDouble(), _valueFor(h))).toList();
    final spotsMin = history.map((h) => FlSpot(h.time.millisecondsSinceEpoch.toDouble(), _minFor(h))).toList();
    final spotsMax = history.map((h) => FlSpot(h.time.millisecondsSinceEpoch.toDouble(), _maxFor(h))).toList();

    final xValues = history.map((h) => h.time.millisecondsSinceEpoch.toDouble()).toList();
    final yValues = <double>[...history.map(_minFor), ...history.map(_valueFor), ...history.map(_maxFor)];

    final minX = xValues.isNotEmpty ? xValues.first : 0.0;
    final maxX = xValues.isNotEmpty ? xValues.last : 1.0;
    double minY = yValues.isNotEmpty ? yValues.reduce((a, b) => a < b ? a : b) : 0.0;
    double maxY = yValues.isNotEmpty ? yValues.reduce((a, b) => a > b ? a : b) : 1.0;

    // Add small padding for visual breathing room
    final yPadding = (maxY - minY) * 0.12;
    if (yPadding == 0) {
      // if all values equal, add fixed padding
      minY -= 1;
      maxY += 1;
    } else {
      minY -= yPadding;
      maxY += yPadding;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: LineChart(
          LineChartData(
            minX: minX,
            maxX: maxX,
            minY: minY,
            maxY: maxY,
            gridData: FlGridData(show: true, drawVerticalLine: true, horizontalInterval: (maxY - minY) / 4),
            titlesData: FlTitlesData(
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxX - minX) / 4,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    final fmt = DateFormat('MM-dd\nHH:mm');
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(fmt.format(dt), textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: (maxY - minY) / 4)),
            ),
            lineBarsData: [
              // Min (dashed thin)
              LineChartBarData(
                spots: spotsMin,
                isCurved: true,
                dotData: const FlDotData(show: false),
                barWidth: 1,
                belowBarData: BarAreaData(show: false),
                dashArray: [4, 4],
                color: Colors.grey,
              ),
              // Max (dashed thin)
              LineChartBarData(
                spots: spotsMax,
                isCurved: true,
                dotData: const FlDotData(show: false),
                barWidth: 1,
                belowBarData: BarAreaData(show: false),
                dashArray: [4, 4],
                color: Colors.grey,
              ),
              // Average (solid, highlighted)
              LineChartBarData(
                spots: spotsAvg,
                isCurved: true,
                dotData: const FlDotData(show: true),
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.25),
                      Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    ],
                  ),
                ),
                color: Theme.of(context).colorScheme.primary,
                preventCurveOverShooting: true,
              ),
            ],
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(16),
                getTooltipItems: (touched) {
                  return touched.map((t) {
                    final dt = DateTime.fromMillisecondsSinceEpoch(t.x.toInt());
                    final text = '${DateFormat('yyyy-MM-dd HH:mm').format(dt)}\n${t.y.toStringAsFixed(2)}';
                    return LineTooltipItem(text, const TextStyle(color: Colors.white, fontSize: 12));
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
