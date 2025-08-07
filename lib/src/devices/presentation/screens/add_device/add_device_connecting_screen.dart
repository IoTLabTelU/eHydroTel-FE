import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDeviceConnectingScreen extends StatelessWidget {
  const AddDeviceConnectingScreen({
    super.key,
    required this.isDeviceConnected,
    required this.isDeviceConnecting,
    required this.onConnectPressed,
  });

  final bool isDeviceConnected;
  final bool isDeviceConnecting;
  final VoidCallback onConnectPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.wifi, size: 50.sp, color: ColorValues.iotMainColor),
            const SizedBox(height: 10),
            Text(
              isDeviceConnected
                  ? 'Connected to Device'
                  : isDeviceConnecting
                  ? 'Connecting to Device...'
                  : 'Connect to Device',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorValues.iotMainColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (!isDeviceConnected) ...[
              Text(
                'Please make sure your device is turned on and connected to the same Wi-Fi network.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            !isDeviceConnected && !isDeviceConnecting
                ? SizedBox(
                    width: double.infinity,
                    child: primaryButton(text: 'CONNECT', onPressed: onConnectPressed, context: context),
                  )
                : Text('Found Device: ${isDeviceConnected ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}
