import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/dashboard/application/providers/filter_devices_providers.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/presentation/screens/search_device_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';

import '../../../../core/components/filter_button_overlay.dart';
import '../../../../pkg.dart';
import '../../../../core/components/screen_header.dart';
import '../../../../core/components/animated_refresh_button_widget.dart';

class DevicesScreen extends ConsumerStatefulWidget {
  const DevicesScreen({super.key});

  static const String path = 'devices';

  @override
  ConsumerState<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends ConsumerState<DevicesScreen> {
  DeviceStatus? get filterDevices => ref.watch(filterDevicesProvider);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filterDevicesProvider.notifier).setDeviceStatus(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final devices = ref.watch(devicesControllerProvider);
    final userProvider = ref.watch(authControllerProvider);
    return Skeletonizer(
      enabled: devices.isLoading,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: userProvider.when(
                data: (user) => ScreenHeader(
                  username: user!.name.split(' ')[0],
                  plantAsset: IconAssets.device,
                  line1: local.keepYourDevices,
                  line2: local.connected,
                ),
                loading: () => const SizedBox.shrink(),
                error: (err, _) => Center(child: Text('${local.error} $err')),
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            floating: false,
            automaticallyImplyLeading: false,
            backgroundColor: ColorValues.whiteColor,
            forceMaterialTransparency: true,
            toolbarHeight: 42.h,
            collapsedHeight: 42.h,
            title: Skeleton.shade(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: searchButton(
                      onPressed: () => context.push('/dashboard/${SearchDeviceScreen.path}'),
                      context: context,
                      text: '${local.searchDevices}...',
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Flexible(child: FilterButtonWithOverlay()),
                  const SizedBox(width: 2),
                  Flexible(
                    child: SizedBox(
                      width: 40.w,
                      height: 40.h,
                      child: addButton(
                        context: context,
                        onPressed: () {
                          context.push('/create/scan');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Skeleton.leaf(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    devices.when(
                      data: (device) {
                        if (device.isEmpty) {
                          return SizedBox(
                            height: heightQuery(context) * 0.65,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning_amber, color: ColorValues.warning600, size: 50),
                                  Text(
                                    local.warning,
                                    style: jetBrainsMonoHeadText(color: ColorValues.warning600, size: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    local.noDevicesFound,
                                    style: dmSansSmallText(size: 14, weight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Column(
                          children: device
                              .where((e) {
                                if (filterDevices != null) return e.status == getDeviceStatusText(filterDevices!);
                                return true;
                              })
                              .map((e) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: DeviceCard(
                                    deviceName: e.name,
                                    serialNumber: e.serialNumber,
                                    ssid: e.ssid ?? 'N/A',
                                    status: e.status,
                                    onSettingPressed: () {
                                      context.push(
                                        '/settings',
                                        extra: {
                                          'deviceName': e.name,
                                          'deviceDescription': e.description,
                                          'serialNumber': e.serialNumber,
                                          'addedAt': DateFormat('dd MMM yyyy').format(e.createdAt),
                                          'updatedAt': DateFormat('dd MMM yyyy').format(e.updatedAt),
                                        },
                                      );
                                    },
                                  ),
                                );
                              })
                              .toList(),
                        );
                      },
                      error: (err, stk) {
                        final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
                        return Column(
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
                            const SizedBox(height: 10),
                            AnimatedRefreshButton(
                              onRefresh: () async {
                                await ref.read(devicesControllerProvider.notifier).fetchDevices();
                              },
                              loading: false,
                            ),
                          ],
                        );
                      },
                      loading: () {
                        return const SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: heightQuery(context) * 0.15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
