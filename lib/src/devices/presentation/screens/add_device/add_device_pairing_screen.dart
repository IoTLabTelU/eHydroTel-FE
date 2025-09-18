import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDevicePairingScreen extends StatelessWidget {
  const AddDevicePairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wifi, size: 100.sp, color: ColorValues.iotMainColor),
              const SizedBox(height: 10),
              Text(
                'Ready to Pair?',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '1. Re-configure your tethering SSID and Password according to the instructions provided on the IoT device.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '2. Make sure your IoT device is turned on.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '3. The IoT device will automatically connect to the hotspot using the configured SSID and Password.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '4. Once your IoT device is connected to the hotspot, it will automatically pair with the app.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
