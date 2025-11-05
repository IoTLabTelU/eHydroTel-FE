import 'package:vector_graphics/vector_graphics.dart';
import '../../pkg.dart';
import 'blinking_dot.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String serialNumber;
  final String status;
  final String ssid;
  final VoidCallback onSettingPressed;

  const DeviceCard({
    super.key,
    required this.deviceName,
    required this.serialNumber,
    required this.ssid,
    required this.onSettingPressed,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: ColorValues.whiteColor,
        borderRadius: BorderRadius.circular(31),
        border: Border.all(color: ColorValues.neutral100),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    deviceName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: settingButton(context: context, onPressed: onSettingPressed),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text('Serial : $serialNumber', style: Theme.of(context).textTheme.labelSmall),
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InfoCard(info: ssid, withBlinkingDot: false, iconPath: IconAssets.wifi, title: 'SSID'),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: InfoCard(info: status, withBlinkingDot: true, iconPath: IconAssets.device, title: local.device),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.info,
    required this.withBlinkingDot,
    required this.iconPath,
    required this.title,
  });
  final String title;
  final String info;
  final bool withBlinkingDot;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorValues.neutral100, borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorValues.green400, width: 2),
                  ),
                  child: Center(
                    child: withBlinkingDot
                        ? Stack(
                            children: [
                              VectorGraphic(loader: AssetBytesLoader(iconPath), width: 16, height: 16),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: BlinkingDot(
                                  size: 5,
                                  color: info == getDeviceStatusText(DeviceStatus.active)
                                      ? ColorValues.success700
                                      : info == getDeviceStatusText(DeviceStatus.idle)
                                      ? ColorValues.blueProgress
                                      : ColorValues.danger700,
                                  duration: const Duration(milliseconds: 800),
                                ),
                              ),
                            ],
                          )
                        : VectorGraphic(loader: AssetBytesLoader(iconPath), width: 16, height: 16),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              info,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: withBlinkingDot
                    ? (info == getDeviceStatusText(DeviceStatus.active)
                          ? ColorValues.success700
                          : info == getDeviceStatusText(DeviceStatus.idle)
                          ? ColorValues.blueProgress
                          : ColorValues.danger700)
                    : ColorValues.blackColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
