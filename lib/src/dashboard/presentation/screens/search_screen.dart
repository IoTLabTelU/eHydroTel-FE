import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/device_card.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/domain/entities/device_entity.dart';
import 'package:hydro_iot/utils/utils.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  static const String path = 'search';

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<DeviceEntity> _filteredDevices = [];
  List<DeviceEntity> _allDevices = [];
  late List<bool> isOnList;

  void toggleStart(int index) {
    setState(() {
      isOnList[index] = !isOnList[index];
    });
  }

  void _filterDevices(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _filteredDevices = [];
      });
      return;
    }

    final filtered = _allDevices.where((device) {
      return device.name.toLowerCase().contains(query.toLowerCase()) ||
          device.serialNumber.toLowerCase().contains(query.toLowerCase()) ||
          (device.ssid?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();

    setState(() {
      _filteredDevices = filtered;
      isOnList = List<bool>.generate(filtered.length, (index) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final devicesAsync = ref.watch(devicesControllerProvider);

    return devicesAsync.when(
      data: (devices) {
        _allDevices = devices;

        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          children: [
            const SizedBox(height: 20),
            SearchBar(
              hintText: 'Search by device name, serial, or SSID...',
              leading: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: const Icon(Icons.search),
              ),
              autoFocus: true,
              keyboardType: TextInputType.text,
              controller: searchController,
              onChanged: (value) {
                _filterDevices(value);
              },
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
                if (searchController.text.isEmpty) {
                  context.pop();
                }
              },
              backgroundColor: const WidgetStateColor.fromMap({
                WidgetState.any: ColorValues.neutral200,
                WidgetState.focused: ColorValues.neutral100,
                WidgetState.hovered: ColorValues.neutral300,
              }),
            ),
            const SizedBox(height: 20),
            _buildSearchResults(),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildSearchResults() {
    if (searchController.text.trim().isEmpty) {
      return const SizedBox();
    }

    if (_filteredDevices.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _filteredDevices.length,
          itemBuilder: (context, index) {
            final device = _filteredDevices[index];
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: GestureDetector(
                onTap: () => context.push(
                  '/devices/${device.serialNumber}/view',
                  extra: {'deviceName': device.name, 'deviceId': device.id},
                ),
                child: DeviceCard(
                  deviceName: device.name,
                  serialNumber: device.serialNumber,
                  isOnline: isOnList[index],
                  ssid: device.ssid ?? 'Unknown SSID',
                  createdAt: device.createdAt,
                  lastUpdated: device.updatedAt,
                  onTapSetting: () => context.push(
                    '/devices/${device.serialNumber}/settings',
                    extra: {
                      'deviceName': device.name,
                      'deviceDescription': device.description,
                      'ssid': device.ssid ?? 'Unknown SSID',
                    },
                  ),
                  onTapPower: () {
                    toggleStart(index);
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
