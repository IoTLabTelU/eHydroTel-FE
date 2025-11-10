import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/application/controllers/history_controller.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../pkg.dart';
import '../../../domain/entities/history_entity.dart';
import '../../widgets/history_record_list.dart';
import '../../widgets/sensor_chart_widget.dart';

enum ChartType { ph, ppm }

class SensorHistoryScreen extends ConsumerStatefulWidget {
  const SensorHistoryScreen({super.key, required this.cropCycleId});

  final String cropCycleId;

  static const String path = 'sensor-history';

  @override
  ConsumerState<SensorHistoryScreen> createState() =>
      _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends ConsumerState<SensorHistoryScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  DateTimeRange? _selectedRange;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _chartTitle(ChartType t) =>
      t == ChartType.ph ? 'PH (Avg / Min / Max)' : 'PPM (Avg / Min / Max)';

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(
      historyControllerProvider(widget.cropCycleId),
    );

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
            onPressed: context.pop,
          ),
        ),
        title: Text(
          local.sensorHistory,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Skeletonizer(
        enabled: historyAsync.isLoading || historyAsync.isRefreshing,
        child: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (raw) {
            if (raw.history == null) {
              return const Center(
                child: Text('No sensor history data available'),
              );
            }

            final history = [...raw.history as List<HistoryEntity>]
              ..sort((a, b) => a.time.compareTo(b.time));

            if (history.isEmpty) {
              return const Center(child: Text('Sensor history is empty'));
            }

            final start = raw.dateRange['start'];
            final end = raw.dateRange['end'];
            final dateRangeStr = (start != null && end != null)
                ? '${DateFormat('dd MMM yyyy').format(start)} → ${DateFormat('dd MMM yyyy').format(end)}'
                : '-';

            Future<void> pickDateRange() async {
              final picked = await showDateRangePicker(
                context: context,
                initialDateRange:
                    _selectedRange ??
                    DateTimeRange(
                      start: DateTime.now().subtract(const Duration(days: 7)),
                      end: DateTime.now(),
                    ),
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime.now(),
                helpText: 'Select date range',
              );

              if (picked != null && mounted) {
                setState(() => _selectedRange = picked);

                // Trigger fetch with new range
                await ref
                    .read(
                      historyControllerProvider(widget.cropCycleId).notifier,
                    )
                    .fetchHistory(
                      cropCycleId: widget.cropCycleId,
                      start: picked.start,
                      end: picked.end,
                    );
              }
            }

            return CustomScrollView(
              slivers: [
                // ==== Header Info Section ====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Device Timezone: ${raw.timezone}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date Range: $dateRangeStr',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),

                        // === Date Range Picker Button ===
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.date_range_rounded,
                              size: 18,
                            ),
                            label: const Text('Select Date Range'),
                            onPressed: pickDateRange,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Text(
                              _chartTitle(
                                _currentPage == 0
                                    ? ChartType.ph
                                    : ChartType.ppm,
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            Text(
                              'Latest: ${DateFormat('yyyy-MM-dd HH:mm').format(history.last.time)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ==== Chart Swipe Section ====
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (idx) =>
                          setState(() => _currentPage = idx),
                      children: [
                        SensorChart(chartType: ChartType.ph, history: history),
                        SensorChart(chartType: ChartType.ppm, history: history),
                      ],
                    ),
                  ),
                ),

                // Dots Indicator
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (i) {
                      final active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: active ? 18 : 10,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // ==== Records List ====
                SliverFillRemaining(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: HistoryRecordList(history: history),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
