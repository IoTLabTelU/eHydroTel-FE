import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
// import 'package:hydro_iot/utils/utils.dart';
import 'package:intl/intl.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String serialNumber;
  final bool isOnline;
  final String ssid;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final VoidCallback onTapSetting;
  final VoidCallback onTapPower;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.serialNumber,
    required this.isOnline,
    required this.ssid,
    required this.lastUpdated,
    required this.onTapSetting,
    required this.onTapPower,
    required this.createdAt,
  });

  String _getStatusText() {
    if (!isOnline) return getDeviceStatusText(DeviceStatus.idle);
    if (ssid.isEmpty) return getDeviceStatusText(DeviceStatus.error);
    return getDeviceStatusText(DeviceStatus.active);
  }

  Color get statusColor {
    if (!isOnline) return ColorValues.neutral500;
    if (ssid.isEmpty) return ColorValues.danger600;
    return ColorValues.success600;
  }

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText();
    String formattedTime(DateTime time) => DateFormat.yMMMd().format(time);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top Row: Title + Online Status
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                deviceName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorValues.blackColor),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Serial: $serialNumber', style: dmSansNormalText(size: 12, color: ColorValues.neutral500)),
            ),
            const SizedBox(height: 12),

            // Center Row: pH, ppm, chart
            _buildSensorTile('SSID', ssid),
            const SizedBox(height: 12),

            // Status + Last updated
            Row(
              children: [
                Icon(Icons.info_outline, color: statusColor, size: 18),
                const SizedBox(width: 6),
                Text('Status: $statusText', style: dmSansSmallText(size: 14, color: statusColor)),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Added at: ${formattedTime(createdAt)}',
                style: dmSansNormalText(size: 12, color: ColorValues.neutral500),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Last updated: ${formattedTime(lastUpdated)}',
                style: dmSansNormalText(size: 12, color: ColorValues.neutral500),
              ),
            ),

            const Divider(height: 24, color: ColorValues.neutral200),

            // Bottom Row: Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onTapSetting,
                  icon: const Icon(Icons.settings),
                  label: const Text('Setting'),
                  style: TextButton.styleFrom(
                    foregroundColor: ColorValues.iotNodeMCUColor,
                    textStyle: dmSansNormalText(weight: FontWeight.w700),
                  ),
                ),
                // _buildPowerButton(context, onTapPower, isOnline),
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
          style: dmSansNormalText(weight: FontWeight.w500, color: ColorValues.neutral700),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: dmSansNormalText(weight: FontWeight.bold, color: ColorValues.blackColor, size: 16),
        ),
      ],
    );
  }

  // Widget _buildPowerButton(BuildContext context, VoidCallback onPressed, bool isOn) {
  //   return GestureDetector(
  //     onTap: onPressed,
  //     child: Padding(
  //       padding: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.1),
  //       child: AnimatedContainer(
  //         padding: EdgeInsets.all(6.r),
  //         height: 50.h,
  //         duration: const Duration(milliseconds: 100),
  //         decoration: BoxDecoration(
  //           color: isOn ? ColorValues.iotMainColor : ColorValues.neutral500,
  //           shape: BoxShape.circle,
  //           boxShadow: [
  //             BoxShadow(
  //               color: isOn
  //                   ? ColorValues.iotMainColor.withValues(alpha: 0.6)
  //                   : ColorValues.neutral500.withValues(alpha: 0.6),
  //               blurRadius: 8,
  //               offset: const Offset(0, 4),
  //             ),
  //           ],
  //         ),
  //         child: Icon(Icons.power_settings_new, color: isOn ? ColorValues.whiteColor : ColorValues.neutral100, size: 30.r),
  //       ),
  //     ),
  //   );
  // }
}
