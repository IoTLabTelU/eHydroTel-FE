import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/device_card.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/domain/entities/device_entity.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SearchDeviceScreen extends ConsumerStatefulWidget {
  const SearchDeviceScreen({super.key});

  static const String path = 'search-device';

  @override
  ConsumerState<SearchDeviceScreen> createState() => _SearchDeviceScreenState();
}

class _SearchDeviceScreenState extends ConsumerState<SearchDeviceScreen> {
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
  void initState() {
    super.initState();
    searchController.addListener(() {
      _filterDevices(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final devicesAsync = ref.watch(devicesControllerProvider);

    return devicesAsync.when(
      data: (devices) {
        _allDevices = devices;

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: heightQuery(context) * 0.1,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: ColorValues.green500,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
            leading: null,
            automaticallyImplyLeading: false,
            actionsPadding: EdgeInsets.symmetric(horizontal: 18.w),
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: searchButton(
                        onPressed: () {},
                        context: context,
                        enabled: true,
                        controller: searchController,
                        text: local.searchDevices,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: cancelButton(
                        context: context,
                        onPressed: () {
                          setState(() {
                            searchController.clear();
                            context.pop();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: _buildSearchResults(),
        );
      },
      loading: () => Center(child: FancyLoading(title: local.loadingDevice)),
      error: (error, stack) {
        final errorMessage = (error as Exception).toString().replaceAll('Exception: ', '');
        return Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline_outlined, color: ColorValues.danger600, size: 50),
              Text(
                local.error,
                style: jetBrainsMonoHeadText(color: ColorValues.danger600, size: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                errorMessage,
                style: dmSansSmallText(size: 14, weight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    final local = AppLocalizations.of(context)!;
    if (searchController.text.trim().isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VectorGraphic(loader: AssetBytesLoader(IconAssets.searchPlant), width: 40, height: 40),
            const SizedBox(height: 16),
            Text(
              local.searchDevices,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              local.findAndManage,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorValues.neutral500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_filteredDevices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const VectorGraphic(loader: AssetBytesLoader(IconAssets.notfoundSearch), width: 40, height: 40),
            const SizedBox(height: 16),
            Text(
              local.noResultsFound,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              local.tryAnotherName,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorValues.neutral500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: _filteredDevices.length,
          itemBuilder: (context, index) {
            final device = _filteredDevices[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
              child: DeviceCard(
                deviceName: device.name,
                serialNumber: device.serialNumber,
                ssid: device.ssid ?? 'N/A',
                onSettingPressed: () => context.push(
                  '/settings',
                  extra: {
                    'deviceName': device.name,
                    'deviceDescription': device.description,
                    'serialNumber': device.serialNumber,
                    'addedAt': device.createdAt,
                    'updatedAt': device.updatedAt,
                    'ssid': device.ssid ?? '',
                  },
                ),
                status: device.status,
              ),
            );
          },
        ),
      ],
    );
  }
}
