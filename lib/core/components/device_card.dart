import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:intl/intl.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String deviceId;
  final bool isOnline;
  final double ph;
  final int ppm;
  final DateTime lastUpdated;
  final VoidCallback onTapDetail;
  final VoidCallback onTapSetting;
  final Widget? ringChart; // jika sudah ada

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.isOnline,
    required this.ph,
    required this.ppm,
    required this.lastUpdated,
    required this.onTapDetail,
    required this.onTapSetting,
    this.ringChart,
  });

  Color _getStatusColor() {
    if (!isOnline) return ColorValues.neutral500;
    if (ph < 5.5 || ph > 7.5 || ppm < 700 || ppm > 1200) return ColorValues.danger600;
    if ((ph >= 5.5 && ph < 6) || (ph > 7 && ph <= 7.5)) return ColorValues.warning600;
    return ColorValues.success600;
  }

  String _getStatusText() {
    if (!isOnline) return 'Offline';
    if (ph < 5.5 || ph > 7.5 || ppm < 700 || ppm > 1200) return 'Critical';
    if ((ph >= 5.5 && ph < 6) || (ph > 7 && ph <= 7.5)) return 'Unstable';
    return 'Normal';
  }

  Color _getConnectionColor() => isOnline ? ColorValues.success600 : ColorValues.neutral500;

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusText = _getStatusText();
    final connectionColor = _getConnectionColor();
    final formattedTime = DateFormat.Hm().format(lastUpdated);

    return Card(
      color: ColorValues.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row: Title + Online Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  deviceName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorValues.blackColor),
                ),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: connectionColor),
                    const SizedBox(width: 6),
                    Text(
                      isOnline ? 'Online' : 'Offline',
                      style: TextStyle(color: connectionColor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('ID: $deviceId', style: TextStyle(fontSize: 12, color: ColorValues.neutral500)),
            ),
            const SizedBox(height: 12),

            // Center Row: pH, ppm, chart
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildSensorTile('pH', ph.toStringAsFixed(2)),
                      const SizedBox(height: 8),
                      _buildSensorTile('ppm', ppm.toString()),
                    ],
                  ),
                ),
                if (ringChart != null) ringChart!,
              ],
            ),
            const SizedBox(height: 12),

            // Status + Last updated
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: statusColor, size: 18),
                    const SizedBox(width: 6),
                    Text('Status: $statusText', style: TextStyle(color: statusColor)),
                  ],
                ),
                Text('⏱ $formattedTime', style: TextStyle(fontSize: 12, color: ColorValues.neutral500)),
              ],
            ),

            const Divider(height: 24, color: ColorValues.neutral200),

            // Bottom Row: Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onTapDetail,
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('Detail'),
                  style: TextButton.styleFrom(foregroundColor: ColorValues.iotMainColor),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onTapSetting,
                  icon: const Icon(Icons.settings),
                  label: const Text('Setting'),
                  style: TextButton.styleFrom(foregroundColor: ColorValues.iotArduinoColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(String label, String value) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(fontWeight: FontWeight.w500, color: ColorValues.neutral700),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: ColorValues.blackColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
