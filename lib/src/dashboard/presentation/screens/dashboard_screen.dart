import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/crop_cycle_card.dart';
import 'package:hydro_iot/core/components/filter_button_overlay.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/dashboard/application/controllers/crop_cycle_controller.dart';
import 'package:hydro_iot/src/dashboard/application/providers/filter_plants_providers.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/search_crop_cycle_screen.dart';
import 'package:hydro_iot/core/components/screen_header.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/edit_session_modal.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/new_session_modal.dart';
import 'package:hydro_iot/core/components/animated_refresh_button_widget.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../application/providers/crop_cycle_providers.dart';
import '../../application/state/crop_cycle_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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

    return Skeletonizer(
      enabled: cropCycleState.isLoading || userProvider.isLoading,
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: userProvider.when(
                data: (user) => ScreenHeader(
                  username: user!.name.split(' ')[0],
                  plantAsset: IconAssets.plant,
                  line1: local.letsgrow,
                  line2: local.amazing,
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
                      onPressed: () => context.push('/dashboard/${SearchCropCycleScreen.path}'),
                      context: context,
                      text: '${local.searchSessionOrPlants}...',
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
                    _buildCropCycleContent(cropCycleState),
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

  Widget _buildCropCycleContent(CropCycleState state) {
    final local = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const SizedBox.shrink();
    }

    if (state.error != null) {
      return Column(
        children: [
          const Icon(Icons.error_outline_outlined, color: ColorValues.danger600, size: 50),
          Text(
            local.error,
            style: jetBrainsMonoHeadText(color: ColorValues.danger600, size: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            state.error!,
            style: dmSansSmallText(size: 14, weight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

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
                padding: EdgeInsets.only(bottom: 10.h),
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
