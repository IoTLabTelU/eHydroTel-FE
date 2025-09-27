import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/presentation/screens/search_device_screen.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  static const String path = 'devices';

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  late List<bool> isOnList;

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
    final devices = ref.watch(devicesControllerProvider);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: searchButton(
                onPressed: () =>
                    context.push('/dashboard/${SearchDeviceScreen.path}'),
                context: context,
              ),
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
                  hintStyle: dmSansSmallText(
                    size: 12,
                    color: ColorValues.whiteColor,
                    weight: FontWeight.w800,
                  ),
                  showClearIcon: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorValues.whiteColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: ColorValues.iotMainColor,
                      width: 3,
                    ),
                  ),
                ),
                dropdownDecoration: const DropdownDecoration(
                  marginTop: 2,
                  maxHeight: 500,
                ),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: const Icon(
                    Icons.check_box,
                    color: Colors.green,
                  ),
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
            Text(
              'All Devices',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
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
        const SizedBox(height: 10),
        devices.when(
          data: (device) {
            if (devices.isLoading) context.pop();
            setState(() {
              isOnList = List<bool>.generate(device.length, (index) => false);
            });
            if (device.isEmpty) {
              return Center(
                child: Text(
                  'No devices found. Please add a device.',
                  style: dmSansSmallText(
                    size: 14,
                    color: ColorValues.whiteColor,
                    weight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return SizedBox(
              height: heightQuery(context) * 0.65,
              child: ListView.builder(
                itemCount: device.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: GestureDetector(
                      onTap: () => context.push(
                        '/devices/${device[index].serialNumber}/view',
                        extra: {
                          'deviceName': device[index].name,
                          'deviceId': device[index].id,
                        },
                      ),
                      child: DeviceCard(
                        deviceName: device[index].name,
                        serialNumber: device[index].serialNumber,
                        isOnline: isOnList[index],
                        ssid: device[index].ssid ?? 'Unknown SSID',
                        createdAt: device[index].createdAt,
                        lastUpdated: device[index].updatedAt,
                        onTapSetting: () => context.push(
                          '/devices/${device[index].serialNumber}/settings',
                          extra: {
                            'deviceName': device[index].name,
                            'deviceDescription': device[index].description,
                            'ssid': device[index].ssid ?? 'Unknown SSID',
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
                },
              ),
            );
          },
          error: (error, stackTrace) {
            context.pop();
            return Center(child: Text('Error: $error'));
          },
          loading: () {
            return const FancyLoading(title: 'Loading devices...');
          },
        ),
      ],
    );
  }
}
