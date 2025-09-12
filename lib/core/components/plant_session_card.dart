import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:intl/intl.dart';

class PlantSessionCard extends StatelessWidget {
  final String deviceName;
  final String deviceId;
  final String plantType;
  final bool isOnline;
  final double ph;
  final int ppm;
  final DateTime plantedAt;
  final VoidCallback onTapDetail;
  final VoidCallback onTapSetting;
  final VoidCallback onTapHistory;
  final Widget? ringChart; // jika sudah ada

  const PlantSessionCard({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.isOnline,
    required this.ph,
    required this.ppm,
    required this.plantedAt,
    required this.onTapDetail,
    required this.onTapSetting,
    this.ringChart,
    required this.onTapHistory,
    required this.plantType,
  });

  Color _getStatusColor() {
    if (!isOnline) return ColorValues.neutral500;
    if (ph < 5.5 || ph > 7.5 || ppm < 700 || ppm > 1200) return ColorValues.danger600;
    return ColorValues.success600;
  }

  String _getStatusText() {
    if (!isOnline) return 'Idle';
    if (ph < 5.5 || ph > 7.5 || ppm < 700 || ppm > 1200) return 'Critical';
    return 'Active';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final daysSincePlanted = DateTime.now().difference(plantedAt).inDays;

    return Card(
      color: ColorValues.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(deviceName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  plantType,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: ColorValues.success700),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Serial: $deviceId', style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: 12),

            // Center Row: pH, ppm, chart
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildSensorTile(context, 'pH', ph.toStringAsFixed(2)),
                      const SizedBox(height: 8),
                      _buildSensorTile(context, 'ppm', ppm.toString()),
                    ],
                  ),
                ),
                if (ringChart != null) ringChart!,
              ],
            ),
            const SizedBox(height: 12),

            // Status + Last updated
            Row(
              children: [
                Icon(Icons.info_outline, color: statusColor, size: 18),
                const SizedBox(width: 6),
                Text('Status: $statusText', style: TextStyle(color: statusColor)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '🌱 $daysSincePlanted day since planted',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  ' Planted at: ${DateFormat.yMMMd().format(plantedAt)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500),
                ),
              ],
            ),
            const Divider(height: 24, color: ColorValues.neutral200),

            // Bottom Row: Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(onPressed: onTapHistory, icon: const Icon(Icons.history), label: const Text('')),
                const Spacer(),
                TextButton.icon(
                  onPressed: onTapDetail,
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('Detail'),
                  style: TextButton.styleFrom(foregroundColor: ColorValues.iotMainColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(BuildContext context, String label, String value) {
    return Row(
      children: [
        Text('$label:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorValues.neutral700)),
        const SizedBox(width: 6),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
