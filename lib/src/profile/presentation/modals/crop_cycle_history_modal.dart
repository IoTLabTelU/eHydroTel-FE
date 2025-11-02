import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/history_crop_cycle_card.dart';
import 'package:hydro_iot/src/dashboard/application/providers/crop_cycle_providers.dart';

import '../../../../core/components/animated_refresh_button_widget.dart';
import '../../../../pkg.dart';

class CropCycleHistoryModal extends ConsumerStatefulWidget {
  const CropCycleHistoryModal({super.key});

  @override
  ConsumerState<CropCycleHistoryModal> createState() => _CropCycleHistoryModalState();
}

class _CropCycleHistoryModalState extends ConsumerState<CropCycleHistoryModal> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final cropCycleHistory = ref.watch(cropCycleNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          decoration: BoxDecoration(
            color: ColorValues.whiteColor,
            shape: BoxShape.circle,
            border: Border.all(color: ColorValues.neutral200),
          ),
          margin: EdgeInsets.only(left: 16.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorValues.blackColor),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        title: Text(
          local.cropCycleHistory,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: cropCycleHistory.error != null ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: cropCycleHistory.error != null
                ? [
                    const Icon(Icons.error_outline_outlined, color: ColorValues.danger600, size: 50),
                    Text(
                      local.error,
                      style: jetBrainsMonoHeadText(color: ColorValues.danger600, size: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      cropCycleHistory.error!,
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
                  ]
                : cropCycleHistory.cropCycleResponse != null && cropCycleHistory.cropCycleResponse!.data.isNotEmpty
                ? cropCycleHistory.cropCycleResponse!.data.map((e) {
                    return HistoryCropCycleCard(
                      cropCycleName: e.name,
                      cropCycleType: e.plant.name,
                      plantedAt: e.startedAt,
                      phValue: 4.5.toString(),
                      ppmValue: 900.toString(),
                      phRangeValue: '${e.phMin}-${e.phMax}',
                      ppmRangeValue: '${e.ppmMin}-${e.ppmMax}',
                      deviceStatus: e.device.status,
                      deviceName: e.device.name,
                      progressDay: DateTime.now().difference(e.startedAt).inDays,
                      totalDay: e.expectedEnd?.difference(e.startedAt).inDays ?? 30,
                      onHistoryPressed: () {
                        context.push(
                          '/devices/${e.device.serialNumber}/history',
                          extra: {
                            'deviceName': e.device.name,
                            'phMin': e.phMin,
                            'ppmMin': e.ppmMin,
                            'phMax': e.phMax,
                            'ppmMax': e.ppmMax,
                          },
                        );
                      },
                      harvestedAt: e.expectedEnd ?? DateTime.now(),
                    );
                  }).toList()
                : [
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
      ),
    );
  }
}
