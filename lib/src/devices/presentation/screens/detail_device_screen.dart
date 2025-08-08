import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class DetailDeviceScreen extends StatefulWidget {
  const DetailDeviceScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.pH,
    required this.ppm,
    this.deviceDescription,
  });

  final String deviceId;
  final String deviceName;
  final double pH;
  final int ppm;
  final String? deviceDescription;

  @override
  State<DetailDeviceScreen> createState() => _DetailDeviceScreenState();
}

class _DetailDeviceScreenState extends State<DetailDeviceScreen> {
  String get deviceId => widget.deviceId;
  String get deviceName => widget.deviceName;
  double get ph => widget.pH;
  int get ppm => widget.ppm;
  String? get deviceDescription => widget.deviceDescription;

  int random = Random().nextInt(5);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          automaticallyImplyLeading: false,
          title: Text(deviceName),
          expandedHeight: heightQuery(context) * 0.3,
          floating: true,
          snap: true,
          flexibleSpace: FlexibleSpaceBar(background: Image.asset('assets/img/detail_image_$random.jpg', fit: BoxFit.cover)),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeaderCard(),
                SizedBox(height: 16.h),
                _buildSensorInfo(),
                SizedBox(height: 16.h),
                _buildActionButtons(context),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(deviceName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('ID: $deviceId', style: const TextStyle(fontSize: 16, color: Colors.grey)),
          if (deviceDescription != null) ...[
            const SizedBox(height: 8),
            Text(deviceDescription!, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        ],
      ),
    );
  }

  Widget _buildSensorInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSensorCard(icon: Icons.opacity, label: 'pH', value: ph.toStringAsFixed(2), color: Colors.blueAccent),
        _buildSensorCard(icon: Icons.bubble_chart, label: 'PPM', value: ppm.toStringAsFixed(2), color: Colors.deepPurpleAccent),
      ],
    );
  }

  Widget _buildSensorCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          icon: Icon(Icons.refresh, color: ColorValues.whiteColor),
          label: Text('Refresh', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.whiteColor)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          icon: Icon(Icons.delete, color: ColorValues.whiteColor),
          label: Text('Delete', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.whiteColor)),
        ),
      ],
    );
  }
}
