import 'dart:io';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydro_iot/pkg.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

// ----------------- Models -----------------
class SensorPoint {
  final DateTime date;
  final double ph;
  final int ppm;

  SensorPoint({required this.date, required this.ph, required this.ppm});
}

// ----------------- History Page -----------------
class SensorHistoryScreen extends StatefulWidget {
  const SensorHistoryScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.ppmMin,
    required this.ppmMax,
    required this.phMin,
    required this.phMax,
  });

  static const String path = 'history';
  final String deviceId;
  final String deviceName;
  final int ppmMin;
  final int ppmMax;
  final double phMin;
  final double phMax;

  @override
  _SensorHistoryScreenState createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends State<SensorHistoryScreen> {
  DateTimeRange? selectedRange;
  PageController _pageController = PageController();

  List<Map<String, dynamic>> sensorDataPH = [];
  List<Map<String, dynamic>> sensorDataPPM = [];

  @override
  void initState() {
    super.initState();
    // Dummy data generator (replace with actual sensor API data)
    generateSampleData();
  }

  void generateSampleData() {
    final now = DateTime.now();
    sensorDataPH = List.generate(12, (index) {
      final time = now.subtract(Duration(hours: 12 - index));
      return {'time': time, 'value': 5.5 + index * 0.05};
    });

    sensorDataPPM = List.generate(12, (index) {
      final time = now.subtract(Duration(hours: 12 - index));
      return {'time': time, 'value': 800 + index * 20};
    });
  }

  Future<void> pickDateRange() async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime.now(),
      initialDateRange: selectedRange,
    );
    if (result != null) {
      setState(() => selectedRange = result);
      // TODO: Filter data according to selected range
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Sensor Data', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [IconButton(onPressed: pickDateRange, icon: const Icon(Icons.date_range_rounded))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _pageController.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  child: const Text('pH History'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () =>
                      _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  child: const Text('PPM History'),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [_buildChart(sensorDataPH, 'pH', 3.2, 6.0), _buildChart(sensorDataPPM, 'PPM', 700, 1200)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<Map<String, dynamic>> data, String label, double min, double max) {
    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    final isHourlyData = _checkIfHourlyData(data);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sensor $label', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true, drawVerticalLine: true),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 || index >= data.length) return const SizedBox();
                            final time = data[index]['time'] as DateTime;
                            final format = isHourlyData ? DateFormat.Hm() : DateFormat.MMMd();
                            return Text(format.format(time), style: const TextStyle(fontSize: 10));
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade400)),
                    minX: 0,
                    maxX: (data.length - 1).toDouble(),
                    minY: min,
                    maxY: max,
                    lineBarsData: [
                      LineChartBarData(
                        spots: data
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), (e.value['value'] as double).toDouble()))
                            .toList(),
                        isCurved: true,
                        color: label == 'pH' ? Colors.green : Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkIfHourlyData(List<Map<String, dynamic>> data) {
    if (data.length < 2) return false;
    final diff = data[1]['time'].difference(data[0]['time']).inHours;
    return diff <= 3; // if data interval less than or equal to 3 hours, show time instead of date
  }
}
