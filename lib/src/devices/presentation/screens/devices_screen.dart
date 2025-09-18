import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/presentation/screens/devices_list.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

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

  var items = [
    DropdownItem(label: 'Idle', value: 'Idle'),
    DropdownItem(label: 'Active Only', value: 'Active'),
    DropdownItem(label: 'Critical Only', value: 'Critical'),
  ];
  final controller = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: searchButton(onPressed: () => context.push('/dashboard/search'), context: context),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 6,
              child: MultiDropdown<String>(
                items: items,
                controller: controller,
                enabled: true,
                singleSelect: true,
                fieldDecoration: FieldDecoration(
                  backgroundColor: ColorValues.neutral500,
                  hintText: 'Filter Devices',
                  hintStyle: dmSansSmallText(size: 12, color: ColorValues.whiteColor, weight: FontWeight.w800),
                  showClearIcon: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorValues.whiteColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorValues.iotMainColor, width: 3),
                  ),
                ),
                dropdownDecoration: const DropdownDecoration(marginTop: 2, maxHeight: 500),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                  disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  textColor: ColorValues.blackColor,
                  selectedTextColor: ColorValues.iotMainColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Devices', style: Theme.of(context).textTheme.headlineSmall?.copyWith()),
            ElevatedButton.icon(
              onPressed: () => context.push('/devices/create'),
              label: const Text('Add Device'),
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorValues.iotMainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        // Add your device list or other widgets here
        const SizedBox(height: 10),
        ...List.generate(devices.length, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: GestureDetector(
              onTap: () => context.push('/devices/HWTX88${index + 1}/view', extra: {'deviceName': 'Meja ${index + 1}'}),
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
                    'deviceDescription': 'This is the Description of Meja ${index + 1}',
                  },
                ),
                onTapSetting: () => context.push(
                  '/devices/HWTX88${index + 1}/settings',
                  extra: {
                    'deviceName': 'Meja ${index + 1}',
                    'deviceDescription': 'This is the Description of Meja ${index + 1}',
                    'ssid': 'HydroNet',
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
