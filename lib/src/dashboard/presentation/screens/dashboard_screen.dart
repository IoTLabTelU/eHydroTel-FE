import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/auth/application/controllers/auth_controller.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/search_crop_cycle_screen.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/dashboard_header_widget.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/session_modal.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/animated_refresh_button_widget.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import '../../application/providers/crop_cycle_providers.dart';
import '../../application/state/crop_cycle_state.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboard';

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  var items = [
    DropdownItem(label: 'All', value: 'All'),
    DropdownItem(label: 'Active Only', value: 'Active'),
    DropdownItem(label: 'Inactive Only', value: 'Inactive'),
  ];
  final controller = MultiSelectController<String>();
  bool isStopped = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cropCycleNotifierProvider.notifier).fetchCropCycles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cropCycleState = ref.watch(cropCycleNotifierProvider);
    final userProvider = ref.watch(authControllerProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          userProvider.when(
            data: (user) => DashboardHeaderWidget(username: user!.name),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: searchButton(
                  onPressed: () =>
                      context.push('/dashboard/${SearchCropCycleScreen.path}'),
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
                    hintText: 'Filter Session',
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
                'Plant Sessions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    useRootNavigator: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SessionModal(onSessionAdded: (p0) {}),
                    ),
                  );
                },
                label: const Text('Add Session'),
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
          const SizedBox(height: 10),

          _buildCropCycleContent(cropCycleState),

          SizedBox(height: heightQuery(context) * 0.3),
        ],
      ),
    );
  }

  Widget _buildCropCycleContent(CropCycleState state) {
    if (state.isLoading) {
      return const Center(child: FancyLoading(title: 'Loading Crop Cycles...'));
    }

    if (state.error != null) {
      return Column(
        children: [
          Center(child: Text('Error: ${state.error}')),
          const SizedBox(height: 10),
          AnimatedRefreshButton(
            onRefresh: () async {
              await ref
                  .read(cropCycleNotifierProvider.notifier)
                  .fetchCropCycles();
            },
            loading: false,
          ),
        ],
      );
    }

    if (state.cropCycleResponse != null &&
        state.cropCycleResponse!.data.isNotEmpty) {
      return Column(
        children: state.cropCycleResponse!.data.map((cropCycle) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PlantSessionCard(
              onDashboard: true,
              deviceName: cropCycle.device.name,
              plantName: cropCycle.plant.name,
              startDate: cropCycle.startedAt,
              totalDays: DateTime.now().difference(cropCycle.startedAt).inDays,
              minPh: cropCycle.phMin,
              maxPh: cropCycle.phMax,
              minPpm: cropCycle.ppmMin.toDouble(),
              maxPpm: cropCycle.ppmMax.toDouble(),
              onHistoryTap: () => context.push(
                '/devices/${cropCycle.device.serialNumber}/history',
                extra: {
                  'deviceName': cropCycle.device.name,
                  'pH': (cropCycle.phMin + cropCycle.phMax) / 2,
                  'ppm': (cropCycle.ppmMin + cropCycle.ppmMax) / 2,
                  'deviceDescription':
                      'This is the Description of ${cropCycle.device.name}',
                },
              ),
              onStopSession: () {
                showAdaptiveDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return alertDialog(
                      context: context,
                      title: 'Stop Session',
                      content: 'Are you sure you want to stop this session?',
                      onConfirm: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              onTap: () => context.push(
                '/devices/${cropCycle.device.serialNumber}',
                extra: {
                  'deviceName': cropCycle.device.name,
                  'pH': (cropCycle.phMin + cropCycle.phMax) / 2,
                  'ppm': (cropCycle.ppmMin + cropCycle.ppmMax) / 2,
                  'deviceDescription':
                      'This is the Description of ${cropCycle.device.name}',
                },
              ),
              isStopped: !cropCycle.active,
              onRestartSession: () {},
            ),
          );
        }).toList(),
      );
    }

    return const Center(child: Text('No Data'));
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
