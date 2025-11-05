import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/crop_cycle_card.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/src/dashboard/application/providers/filter_devices_providers.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../../../../pkg.dart';
import '../../application/providers/crop_cycle_providers.dart';
import '../../application/state/crop_cycle_state.dart';
import 'dart:async';

class SearchCropCycleScreen extends ConsumerStatefulWidget {
  const SearchCropCycleScreen({super.key});

  static const String path = 'search-crop-cycle';

  @override
  ConsumerState<SearchCropCycleScreen> createState() => _SearchCropCycleScreenState();
}

class _SearchCropCycleScreenState extends ConsumerState<SearchCropCycleScreen> {
  PlantStatus? get filterPlants => ref.watch(filterCropCycleProvider);
  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text.trim();
      if (query.isNotEmpty) {
        ref.read(searchCropCycleNotifierProvider.notifier).searchCropCycles(query);
      } else {
        ref.read(searchCropCycleNotifierProvider.notifier).clearSearch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final searchState = ref.watch(searchCropCycleNotifierProvider);
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
                    text: local.searchSessionOrPlants,
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
      body: searchState is CropCycleStateInitial
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const VectorGraphic(loader: AssetBytesLoader(IconAssets.searchPlant), width: 40, height: 40),
                  const SizedBox(height: 16),
                  Text(
                    local.searchSessionOrPlants,
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
            )
          : searchState is CropCycleStateLoaded && searchState.cropCycleResponse!.data.isEmpty
          ? Center(
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
            )
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              children: [const SizedBox(height: 20), _buildSearchResults(searchState)],
            ),
    );
  }

  Widget _buildSearchResults(CropCycleState state) {
    final local = AppLocalizations.of(context)!;
    if (state is CropCycleStateLoading) {
      return const Center(child: FancyLoading(title: 'Searching crop cycles...'));
    }

    if (state is CropCycleStateError) {
      final errorMessage = (state.error as Exception).toString().replaceAll('Exception: ', '');
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
    }

    if (state is CropCycleStateLoaded) {
      final cropCycles = state.cropCycleResponse!.data;

      if (cropCycles.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: cropCycles
            .where((e) {
              if (filterPlants != null) {
                return e.status == getPlantStatusText(filterPlants!);
              }
              return true;
            })
            .map((cropCycle) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CropCycleCard(
                  deviceName: cropCycle.device.name,
                  onEditPressed: () {},
                  cropCycleName: cropCycle.name,
                  cropCycleType: cropCycle.plant.name,
                  plantedAt: cropCycle.startedAt,
                  phValue: 4.5.toString(),
                  ppmValue: 900.toString(),
                  phRangeValue: '${cropCycle.phMin.toStringAsFixed(1)}-${cropCycle.phMax.toStringAsFixed(1)}',
                  ppmRangeValue: '${cropCycle.ppmMin.toStringAsFixed(0)}-${cropCycle.ppmMax.toStringAsFixed(0)}',
                  deviceStatus: cropCycle.status,
                  progressDay: DateTime.now().difference(cropCycle.startedAt).inDays,
                  totalDay: cropCycle.expectedEnd != null
                      ? cropCycle.expectedEnd!.difference(cropCycle.startedAt).inDays
                      : 30,
                  onHistoryPressed: () {
                    context.push('/sensor-history', extra: {'cropCycleId': cropCycle.id});
                  },
                  onHarvestPressed: () {
                    showAdaptiveDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return alertDialog(
                          context: context,
                          title: local.harvest,
                          content: local.confirmHarvest,
                          onConfirm: () {
                            Navigator.of(context).pop();
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

    return const SizedBox.shrink();
  }
}
