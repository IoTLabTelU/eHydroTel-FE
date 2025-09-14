import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/presentation/screens/devices_list.dart';
import 'package:hydro_iot/utils/utils.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  static const String path = 'devices';

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  late List<bool> isOnList = List.generate(devices.length, (_) => true);

  void toggleStart(int index) {
    isOnList[index] = !isOnList[index];
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      children: [
        searchButton(
          onPressed: () => context.push('/dashboard/search'),
          context: context,
          text: 'Search devices...',
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'All Devices',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            ElevatedButton.icon(
              onPressed: () => context.push('/devices/create'),
              label: const Text('Add Device'),
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorValues.iotMainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        // Add your device list or other widgets here
        const SizedBox(height: 20),
        ...List.generate(devices.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: GestureDetector(
              onTap: () => context.push(
                '/devices/HWTX88${index + 1}/view',
                extra: {'deviceName': 'Meja ${index + 1}'},
              ),
              child: DeviceCard(
                deviceName: devices[index]['name'],
                deviceId: devices[index]['id'],
                isOnline: isOnList[index],
                ssid: 'HydroNet',
                lastUpdated: DateTime.now(),
                onTapDetail: () => context.push(
                  '/devices/HWTX88${index + 1}',
                  extra: {
                    'deviceName': devices[index]['name'],
                    'pH': 10.0,
                    'ppm': 850,
                    'deviceDescription':
                        'This is the Description of Meja ${index + 1}',
                  },
                ),
                onTapSetting: () => context.push(
                  '/devices/HWTX88${index + 1}/settings',
                  extra: {
                    'deviceName': 'Meja ${index + 1}',
                    'initialMinPh': 2.2,
                    'initialMaxPh': 7.0,
                    'initialMinPPM': 850.0,
                    'initialMaxPPM': 1000.0,
                  },
                ),
                onTapPower: () {
                  setState(() {
                    toggleStart(index);
                  });
                },
              ),
            ),
          );
        }),
      ],
    );
  }
}
