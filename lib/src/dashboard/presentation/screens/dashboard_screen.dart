import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/crop_cycle_card.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/dashboard/application/controllers/crop_cycle_controller.dart';
import 'package:hydro_iot/src/dashboard/application/providers/filter_plants_providers.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/search_crop_cycle_screen.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/dashboard_header_widget.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/edit_session_modal.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/new_session_modal.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/status_filter_overlay_widget.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/animated_refresh_button_widget.dart';
import 'package:hydro_iot/utils/utils.dart';
import '../../application/providers/crop_cycle_providers.dart';
import '../../application/state/crop_cycle_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool isStopped = false;

  DeviceStatus? get filterDevices => ref.watch(filterDevicesProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cropCycleNotifierProvider.notifier).fetchCropCycles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final cropCycleState = ref.watch(cropCycleNotifierProvider);
    final userProvider = ref.watch(authControllerProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          userProvider.when(
            data: (user) => DashboardHeaderWidget(username: user!.name.split(' ').first),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('${local.error} $err')),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: searchButton(
                  onPressed: () => context.push('/dashboard/${SearchCropCycleScreen.path}'),
                  context: context,
                  text: '${local.searchSessionOrPlants}...',
                ),
              ),
              const SizedBox(width: 2),
              Flexible(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: filterButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: Colors.transparent,
                        builder: (_) => Dialog(
                          insetPadding: EdgeInsets.only(
                            left: widthQuery(context) * 0.2,
                            bottom: heightQuery(context) * 0.35,
                          ),
                          backgroundColor: Colors.transparent,
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return GestureDetector(
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: StatusFilterPopup(
                                  onStatusSelected: (status) {
                                    ref.read(filterDevicesProvider.notifier).setPlantStatus(status);
                                  },
                                  selectedStatus: ref.watch(filterDevicesProvider),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    context: context,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Flexible(
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: addButton(
                    context: context,
                    onPressed: () {
                      showModalBottomSheet(
                        useRootNavigator: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) => SessionModal(
                          onSessionAdded: (sessionData) {
                            ref.read(cropCycleNotifierProvider.notifier).fetchCropCycles();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildCropCycleContent(cropCycleState),
        ],
      ),
    );
  }

  Widget _buildCropCycleContent(CropCycleState state) {
    final local = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return Center(child: FancyLoading(title: local.loadingCropCycles));
    }

    if (state.error != null) {
      return Column(
        children: [
          Center(child: Text('Error: ${state.error}')),
          const SizedBox(height: 10),
          AnimatedRefreshButton(
            onRefresh: () async {
              await ref.read(cropCycleNotifierProvider.notifier).fetchCropCycles();
            },
            loading: false,
          ),
        ],
      );
    }

    if (state.cropCycleResponse != null && state.cropCycleResponse!.data.isNotEmpty) {
      return Column(
        children: state.cropCycleResponse!.data
            .where((e) {
              if (filterDevices != null) return e.device.status == getDeviceStatusText(filterDevices!);
              return true;
            })
            .map((cropCycle) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CropCycleCard(
                  deviceName: cropCycle.device.name,
                  onEditPressed: () {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => EditSessionModal(
                        cropCycleId: cropCycle.id,
                        device: cropCycle.device.name,
                        plant: cropCycle.plant.name,
                        sessionName: cropCycle.name,
                        phRange: RangeValues(cropCycle.phMin, cropCycle.phMax),
                        ppmRange: RangeValues(cropCycle.ppmMin.toDouble(), cropCycle.ppmMax.toDouble()),
                        onSessionEdited: (sessionData) {
                          ref.read(cropCycleNotifierProvider.notifier).fetchCropCycles();
                        },
                      ),
                    );
                  },
                  cropCycleName: cropCycle.name,
                  cropCycleType: cropCycle.plant.name,
                  plantedAt: cropCycle.startedAt,
                  phValue: 4.5.toString(),
                  ppmValue: 900.toString(),
                  phRangeValue: '${cropCycle.phMin.toStringAsFixed(1)}-${cropCycle.phMax.toStringAsFixed(1)}',
                  ppmRangeValue: '${cropCycle.ppmMin.toStringAsFixed(0)}-${cropCycle.ppmMax.toStringAsFixed(0)}',
                  deviceStatus: cropCycle.device.status,
                  progressDay: DateTime.now().difference(cropCycle.startedAt).inDays,
                  totalDay: cropCycle.expectedEnd != null
                      ? cropCycle.expectedEnd!.difference(cropCycle.startedAt).inDays
                      : 30,
                  onHistoryPressed: () {
                    context.push(
                      '/devices/${cropCycle.device.serialNumber}/history',
                      extra: {
                        'deviceName': cropCycle.device.name,
                        'phMin': cropCycle.phMin,
                        'ppmMin': cropCycle.ppmMin,
                        'phMax': cropCycle.phMax,
                        'ppmMax': cropCycle.ppmMax,
                      },
                    );
                  },
                  onHarvestPressed: () {
                    showAdaptiveDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return alertDialog(
                          context: context,
                          title: 'Harvest',
                          content: 'Are you sure you want to harvest this crops?',
                          onConfirm: () {
                            ref.read(cropCycleControllerProvider.notifier).endCropCycleSession(cropCycle.id);
                          },
                        );
                      },
                    );
                  },
                ),
              );
            })
            .toList(),
      );
    }

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
              local.noCropCyclesFound,
              style: dmSansSmallText(size: 14, weight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


        //  PlantSessionCard(
        //     onDashboard: true,
        //     deviceName: 'Meja 1',
        //     plantName: 'Broccoli',
        //     startDate: DateTime.utc(2025, 8, 30),
        //     totalDays: 30,
        //     minPh: 5.5,
        //     maxPh: 7.0,
        //     minPpm: 800,
        //     maxPpm: 1200,
        //     onHistoryTap: () => context.push(
        //       '/devices/HWTX883/history',
        //       extra: {
        //         'deviceName': 'Meja 1',
        //         'pH': 5.7,
        //         'ppm': 800,
        //         'deviceDescription': 'This is the Description of Meja 1',
        //       },
        //     ),
        //     onStopSession: () {
        //       showAdaptiveDialog(
        //         barrierDismissible: true,
        //         context: context,
        //         builder: (context) {
        //           return alertDialog(
        //             context: context,
        //             title: 'Stop Session',
        //             content: 'Are you sure you want to stop this session?',
        //             onConfirm: () => setState(() {
        //               isStopped = true;
        //             }),
        //           );
        //         },
        //       );
        //     },
        //     onTap: () => context.push(
        //       '/devices/HWTX883',
        //       extra: {
        //         'deviceName': 'Meja 1',
        //         'pH': 5.7,
        //         'ppm': 800,
        //         'deviceDescription': 'This is the Description of Meja 1',
        //       },
        //     ),
        //     isStopped: isStopped,
        //     onRestartSession: () {
        //       setState(() {
        //         isStopped = false;
        //       });
        //     },
        //   ),
