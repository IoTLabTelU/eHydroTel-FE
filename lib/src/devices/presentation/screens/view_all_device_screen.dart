import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/utils/utils.dart';

class ViewAllDeviceScreen extends StatefulWidget {
  const ViewAllDeviceScreen({super.key});

  static const String path = 'view';

  @override
  State<ViewAllDeviceScreen> createState() => _ViewAllDeviceScreenState();
}

class _ViewAllDeviceScreenState extends State<ViewAllDeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      children: [
        searchButton(onPressed: () => context.push('/dashboard/search'), context: context, text: 'Search devices...'),
        const SizedBox(height: 20),
        Text('View All Devices', style: Theme.of(context).textTheme.headlineSmall),
        // Add your device list or other widgets here
        const SizedBox(height: 20),
        ...List.generate(10, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: DeviceCard(
              deviceName: 'Meja ${index + 1}',
              deviceId: 'HWTX88${index + 1}',
              isOnline: true,
              ph: 2.2,
              ppm: 850,
              lastUpdated: DateTime.now(),
              ringChart: null,
              onTapDetail: () => context.push(
                '/devices/HWTX88${index + 1}',
                extra: {'deviceId': 'HWTX88${index + 1}', 'deviceName': 'Meja ${index + 1}', 'pH': 2.2, 'ppm': 850},
              ),
              onTapSetting: () => context.push('/devices/HWTX88${index + 1}/settings'),
            ),
          );
        }),
      ],
    );
  }
}
