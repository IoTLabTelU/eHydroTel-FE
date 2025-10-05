import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/fancy_loading.dart';
import 'package:hydro_iot/core/components/plant_session_card.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';
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

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      children: [
        const SizedBox(height: 20),
        SearchBar(
          hintText: local.searchCropCycles,
          leading: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: const Icon(Icons.search),
          ),
          autoFocus: true,
          keyboardType: TextInputType.text,
          controller: searchController,
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
        _buildSearchResults(searchState),
      ],
    );
  }

  Widget _buildSearchResults(CropCycleState state) {
    final local = AppLocalizations.of(context)!;
    if (state is CropCycleStateInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(local.startTypingToSearch, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    if (state is CropCycleStateLoading) {
      return const Center(child: FancyLoading(title: 'Searching crop cycles...'));
    }

    if (state is CropCycleStateError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Error: ${state.error}',
              style: TextStyle(fontSize: 16, color: Colors.red.shade600),
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
        children: cropCycles.map((cropCycle) {
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
                  'deviceDescription': 'This is the Description of ${cropCycle.device.name}',
                },
              ),
              onStopSession: () {
                showAdaptiveDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Stop Session'),
                      content: const Text('Are you sure you want to stop this session?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Stop')),
                      ],
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
                  'deviceDescription': 'This is the Description of ${cropCycle.device.name}',
                },
              ),
              isStopped: !cropCycle.active,
              onRestartSession: () {},
            ),
          );
        }).toList(),
      );
    }

    return const SizedBox.shrink();
  }
}
