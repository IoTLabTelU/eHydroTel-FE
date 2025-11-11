import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/application/controllers/history_controller.dart';
import 'package:hydro_iot/src/devices/data/models/history_model.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/export_bottom_sheet_widget.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../pkg.dart';
import '../../../domain/entities/history_entity.dart';
import '../../../../../utils/file_downloader.dart';

enum ChartType { ph, ppm }

class SensorHistoryScreen extends ConsumerStatefulWidget {
  const SensorHistoryScreen({super.key, required this.cropCycleId});

  final String cropCycleId;

  static const String path = 'sensor-history';

  @override
  ConsumerState<SensorHistoryScreen> createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends ConsumerState<SensorHistoryScreen> {
  DateTimeRange? _selectedRange;

  @override
  void dispose() {
    super.dispose();
  }

  void onExportCsv() async {
    final cropCycleId = widget.cropCycleId;
    final url = '${EndpointStrings.cropcycle}/$cropCycleId/export';
    try {
      final access = await Storage().readAccessToken;
      await FileDownloader.downloadAndOpenFile(
        url: url,
        filename: 'CropCycleHistory_${widget.cropCycleId}',
        headers: {'Authorization': 'Bearer $access'},
        queryParameters: {'format': 'csv'},
        listFormat: ListFormat.csv,
      );
      if (context.mounted) {
        Toast().showSuccessToast(context: context, title: 'Success', description: 'File Downloaded Successfully');
      }
    } catch (e) {
      Toast().showErrorToast(context: context, title: 'Error', description: e.toString());
    }
  }

  void onExportXlsx() async {
    final cropCycleId = widget.cropCycleId;
    final url = '${EndpointStrings.cropcycle}/$cropCycleId/export';
    try {
      final access = await Storage().readAccessToken;
      await FileDownloader.downloadAndOpenFile(
        url: url,
        filename: 'CropCycleHistory_${widget.cropCycleId}',
        headers: {'Authorization': 'Bearer $access'},
        queryParameters: {'format': 'xlsx'},
      );
      if (context.mounted) {
        Toast().showSuccessToast(context: context, title: 'Success', description: 'File Downloaded Successfully');
      }
    } catch (e) {
      Toast().showErrorToast(context: context, title: 'Error', description: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(historyControllerProvider(widget.cropCycleId));

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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          const SizedBox(width: 48),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ExportBottomSheet(onExportCsv: onExportCsv, onExportXlsx: onExportXlsx);
                },
              );
            },
            icon: const Icon(Icons.cloud_upload_outlined),
          ),
        ],
      ),
      body: Skeletonizer(
        enabled: historyAsync.isLoading || historyAsync.isRefreshing,
        child: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (raw) {
            if (raw.history == null) {
              return const Center(child: Text('No sensor history data available'));
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
                    DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now()),
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime.now(),
                helpText: 'Select date range',
              );

              if (picked != null && mounted) {
                setState(() => _selectedRange = picked);

                // Trigger fetch with new range
                await ref
                    .read(historyControllerProvider(widget.cropCycleId).notifier)
                    .fetchHistory(cropCycleId: widget.cropCycleId, start: picked.start, end: picked.end);
              }
            }

            return CustomScrollView(
              slivers: [
                // ==== Header Info Section ====
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Device Timezone: ${raw.timezone}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date Range: $dateRangeStr',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),

                        // === Date Range Picker Button ===
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.date_range_rounded, size: 18),
                            label: const Text('Select Date Range'),
                            onPressed: pickDateRange,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildContent(context, raw)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HistoryModel history) {
    final entries = history.history ?? [];

    if (entries.isEmpty) {
      return const Center(child: Text('No sensor data found for this range.', style: TextStyle(fontSize: 16)));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(historyControllerProvider(widget.cropCycleId).notifier)
            .fetchHistory(cropCycleId: widget.cropCycleId, start: _selectedRange?.start, end: _selectedRange?.end);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        children: [_buildChart(entries), const SizedBox(height: 16), ...entries.map(_buildHistoryCard)],
      ),
    );
  }

  Widget _buildChart(List<HistoryEntity> entries) {
    final dateFormat = DateFormat('MM/dd');

    final phSpots = entries.map((e) => FlSpot(entries.indexOf(e).toDouble(), e.phAvg)).toList();

    final ppmSpots = entries.map((e) => FlSpot(entries.indexOf(e).toDouble(), e.ppmAvg)).toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: LineChart(
          LineChartData(
            minY: 0,
            gridData: const FlGridData(show: true),
            borderData: FlBorderData(show: true),
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index < 0 || index >= entries.length) return const SizedBox();
                    return Text(dateFormat.format(entries[index].date), style: const TextStyle(fontSize: 10));
                  },
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: phSpots,
                isCurved: true,
                color: Colors.blueAccent,
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
              LineChartBarData(
                spots: ppmSpots,
                isCurved: true,
                color: Colors.green,
                barWidth: 3,
                dotData: const FlDotData(show: false),
              ),
            ],
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((barSpot) {
                    final entity = entries[barSpot.spotIndex];
                    final label = barSpot.bar.color == Colors.blueAccent ? 'pH Avg' : 'PPM Avg';
                    return LineTooltipItem(
                      '${dateFormat.format(entity.date)}\n$label: ${barSpot.y.toStringAsFixed(2)}',
                      const TextStyle(color: Colors.white),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(HistoryEntity e) {
    final df = DateFormat('EEEE, dd MMM yyyy');
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(df.format(e.date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_infoItem('pH Avg', e.phAvg), _infoItem('pH Min', e.phMin), _infoItem('pH Max', e.phMax)],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_infoItem('PPM Avg', e.ppmAvg), _infoItem('PPM Min', e.ppmMin), _infoItem('PPM Max', e.ppmMax)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, double value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      Text(value.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}
