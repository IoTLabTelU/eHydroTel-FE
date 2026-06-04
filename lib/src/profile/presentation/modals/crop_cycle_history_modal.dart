import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/history_crop_cycle_card.dart';
import 'package:hydro_iot/src/dashboard/application/providers/crop_cycle_providers.dart';
import 'package:hydro_iot/src/dashboard/application/providers/filter_devices_providers.dart';
import 'package:hydro_iot/src/dashboard/application/state/crop_cycle_state.dart';

import '../../../../core/components/animated_refresh_button_widget.dart';
import '../../../../pkg.dart';

class CropCycleHistoryModal extends ConsumerStatefulWidget {
  const CropCycleHistoryModal({super.key});

  @override
  ConsumerState<CropCycleHistoryModal> createState() => _CropCycleHistoryModalState();
}

class _CropCycleHistoryModalState extends ConsumerState<CropCycleHistoryModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyCropCycleNotifierProvider.notifier).fetchCropCycles('finished', false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final state = ref.watch(historyCropCycleNotifierProvider);
    final filterHistory = ref.watch(filterHistoryCropCycleProvider);

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
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(local.cropCycleHistory, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: _buildBody(state, filterHistory, local),
      ),
    );
  }

  Widget _buildBody(CropCycleState state, PlantStatus? filter, AppLocalizations local) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (state.error != null) {
      return _buildError(state.error.toString(), local);
    }

    if (state.items.isEmpty) {
      return _buildEmpty(local);
    }

    return _buildList(state, filter, local);
  }

  Widget _buildError(String message, AppLocalizations local) {
    final errorMessage = message.replaceAll('Exception: ', '');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
              await ref.read(historyCropCycleNotifierProvider.notifier).fetchCropCycles('finished', false);
            },
            loading: false,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations local) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildList(CropCycleState state, PlantStatus? filter, AppLocalizations local) {
    final filtered = state.items.where((e) {
      if (filter != null) return e.status == getPlantStatusText(filter);
      return true;
    }).toList();

    if (filtered.isEmpty) return _buildEmpty(local);

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => SizedBox(height: 8.h),
      itemBuilder: (_, index) {
        final e = filtered[index];
        return HistoryCropCycleCard(
          cropCycleName: e.name,
          cropCycleType: e.plant.name,
          plantedAt: e.startedAt,
          phValue: '-',
          ppmValue: '-',
          phRangeValue: '${e.phMin}-${e.phMax}',
          ppmRangeValue: '${e.ppmMin}-${e.ppmMax}',
          deviceStatus: e.device.status,
          deviceName: e.device.name,
          progressDay: DateTime.now().difference(e.startedAt).inDays,
          totalDay: e.expectedEnd?.difference(e.startedAt).inDays ?? 30,
          onHistoryPressed: () {
            context.push('/sensor-history', extra: {'cropCycleId': e.id});
          },
          harvestedAt: e.expectedEnd ?? DateTime.now(),
        );
      },
    );
  }
}
