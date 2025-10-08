import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/dashboard/application/controllers/crop_cycle_for_devices_controller.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/crop_cycle_entity.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/session_modal.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/animated_refresh_button_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class ViewAllPlantSessionScreen extends ConsumerStatefulWidget {
  final String deviceId;
  final String deviceName;
  final String serialNumber;

  const ViewAllPlantSessionScreen({super.key, required this.deviceId, required this.deviceName, required this.serialNumber});

  static const String path = 'view';

  @override
  ConsumerState<ViewAllPlantSessionScreen> createState() => _ViewAllPlantSessionScreenState();
}

class _ViewAllPlantSessionScreenState extends ConsumerState<ViewAllPlantSessionScreen> {
  bool isStopped = false;
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final cropCycles = ref.watch(cropCycleForDevicesControllerProvider(widget.deviceId));

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(local.allSessions, style: Theme.of(context).textTheme.headlineSmall?.copyWith()),
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                  useRootNavigator: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: SessionModal(onSessionAdded: (p0) {}),
                  ),
                );
              },
              label: Text(local.addSession),
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorValues.iotMainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'on ${widget.deviceName}',
          style: dmSansHeadText(
            color: Theme.brightnessOf(context) == Brightness.dark ? ColorValues.neutral100 : ColorValues.neutral600,
          ),
        ),
        // Add your device list or other widgets here
        const SizedBox(height: 10),
        cropCycles.when(
          data: (data) => _buildCropCycleContent(data),
          loading: () => Center(child: FancyLoading(title: local.loadingCropCycles)),
          error: (error, stackTrace) => Column(
            children: [
              Center(child: Text('${local.error}: $error')),
              const SizedBox(height: 10),
              AnimatedRefreshButton(
                onRefresh: () => ref.refresh(cropCycleForDevicesControllerProvider(widget.deviceId).future),
                loading: false,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCropCycleContent(List<CropCycle>? data) {
    final local = AppLocalizations.of(context)!;
    if (data != null && data.isNotEmpty) {
      return Column(
        children: data.map((cropCycle) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PlantSessionCard(
              onDashboard: false,
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
                  'phMin': cropCycle.phMin,
                  'ppmMin': cropCycle.ppmMin,
                  'phMax': cropCycle.phMax,
                  'ppmMax': cropCycle.ppmMax,
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
              onTap: () {},
              // onTap: () => context.push(
              //   '/devices/${cropCycle.device.serialNumber}',
              //   extra: {
              //     'deviceName': cropCycle.device.name,
              //     'pH': (cropCycle.phMin + cropCycle.phMax) / 2,
              //     'ppm': (cropCycle.ppmMin + cropCycle.ppmMax) / 2,
              //     'deviceDescription': 'This is the Description of ${cropCycle.device.name}',
              //   },
              // ),
              isStopped: !cropCycle.active,
              onRestartSession: () {},
            ),
          );
        }).toList(),
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
