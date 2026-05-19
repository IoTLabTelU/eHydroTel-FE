import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/application/controllers/history_controller.dart';
import 'package:hydro_iot/src/devices/data/models/history_model.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/export_bottom_sheet_widget.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../pkg.dart';
import '../../../domain/entities/history_entity.dart';

enum ChartType { ph, ppm }

@pragma('vm:entry-point')
void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}

class SensorHistoryScreen extends ConsumerStatefulWidget {
  const SensorHistoryScreen({super.key, required this.cropCycleId});

  final String cropCycleId;

  static const String path = 'sensor-history';

  @override
  ConsumerState<SensorHistoryScreen> createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends ConsumerState<SensorHistoryScreen> {
  DateTimeRange? _selectedRange;
  final ReceivePort _port = ReceivePort();
  // DownloadTaskStatus? _downloadStatus;
  // int _downloadProgress = 0;
  String? _downloadTaskId;
  final TransformationController transformationController = TransformationController();
  bool _isZoomMode = false;

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      log('Download progress: $data');
      _downloadTaskId = data[0];
      // _downloadStatus = DownloadTaskStatus.fromInt(data[1]);
      // _downloadProgress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  void onExportCsv(BuildContext context) async {
    final local = AppLocalizations.of(context)!;
    final cropCycleId = widget.cropCycleId;
    String url = '${EndpointStrings.cropcycle}/$cropCycleId/export?format=csv';
    if (_selectedRange != null) {
      final start = DateFormat('yyyy-MM-dd').format(_selectedRange?.start ?? DateTime.now());
      final end = DateFormat('yyyy-MM-dd').format(_selectedRange?.end ?? DateTime.now());

      url += '&start=$start&end=$end';
    }
    try {
      final access = await Storage().readAccessToken;
      if (context.mounted) {
        Toast().showSuccessToast(context: context, title: local.success, description: local.fileIsBeingDownloaded);
      }
      await FileDownloader.download(
        url: url,
        filename: 'CropCycleHistory_${widget.cropCycleId}.csv',
        headers: {'Authorization': 'Bearer $access'},
      ).then((_) {
        log('Download completed');
        setState(() {});
        FlutterDownloader.open(taskId: _downloadTaskId!);
      });
    } catch (e) {
      if (context.mounted) Toast().showErrorToast(context: context, title: local.error, description: e.toString());
    }
  }

  void onExportXlsx(BuildContext context) async {
    final local = AppLocalizations.of(context)!;
    final cropCycleId = widget.cropCycleId;
    String url = '${EndpointStrings.cropcycle}/$cropCycleId/export?format=xlsx';
    if (_selectedRange != null) {
      final start = DateFormat('yyyy-MM-dd').format(_selectedRange?.start ?? DateTime.now());
      final end = DateFormat('yyyy-MM-dd').format(_selectedRange?.end ?? DateTime.now());

      url += '&start=$start&end=$end';
    }
    try {
      final access = await Storage().readAccessToken;
      if (context.mounted) {
        Toast().showSuccessToast(context: context, title: local.success, description: local.fileIsBeingDownloaded);
      }
      await FileDownloader.download(
        url: url,
        filename: 'CropCycleHistory_${widget.cropCycleId}.xlsx',
        headers: {'Authorization': 'Bearer $access'},
      ).then((_) {
        log('Download completed');
        setState(() {});
        FlutterDownloader.open(taskId: _downloadTaskId!);
      });
    } catch (e) {
      if (context.mounted) Toast().showErrorToast(context: context, title: local.error, description: e.toString());
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
        title: Text(local.sensorHistory, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          const SizedBox(width: 48),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) {
                  return ExportBottomSheet(onExportCsv: () => onExportCsv(ctx), onExportXlsx: () => onExportXlsx(ctx));
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
              return Center(child: Text(local.noSensorDataFound, style: Theme.of(context).textTheme.bodyMedium));
            }

            final start = raw.dateRange['start'];
            final end = raw.dateRange['end'];
            final dateRangeStr = (start != null && end != null)
                ? '${DateFormat('dd MMM yyyy').format(start)} → ${DateFormat('dd MMM yyyy').format(end)}'
                : '-';

            Future<void> pickDateRange() async {
              final picked = await showDateRangePicker(
                context: context,
                initialDateRange: _selectedRange ?? DateTimeRange(start: DateTime.now().subtract(const Duration(days: 7)), end: DateTime.now()),
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime.now(),
                helpText: local.selectDateRange,
              );

              if (picked != null && mounted) {
                setState(() => _selectedRange = picked);

                // Trigger fetch with new range
                await ref
                    .read(historyControllerProvider(widget.cropCycleId).notifier)
                    .fetchHistory(cropCycleId: widget.cropCycleId, start: picked.start, end: picked.end);
              }
            }

            return RefreshIndicator.adaptive(
              notificationPredicate: (_) => !_isZoomMode, // Hanya aktifkan pull-to-refresh saat tidak dalam mode zoom
              onRefresh: () async {
                await ref
                    .read(historyControllerProvider(widget.cropCycleId).notifier)
                    .fetchHistory(cropCycleId: widget.cropCycleId, start: _selectedRange?.start, end: _selectedRange?.end);
              },
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragStart: _isZoomMode
                    ? (_) {
                        Toast().showWarningToast(
                          context: context,
                          title: 'Zoom Mode Aktif!',
                          description: "Scroll terkunci. Matikan 'Mode Zoom' untuk scroll halaman.",
                        );
                      }
                    : null, // Kunci gesture vertical drag saat zoom mode aktif
                child: CustomScrollView(
                  physics: _isZoomMode ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // ==== Header Info Section ====
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${local.deviceTimezone}: ${raw.timezone}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.green900),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${local.dateRange}: $dateRangeStr',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.green900),
                            ),
                            const SizedBox(height: 8),

                            // === Date Range Picker Button ===
                            Align(
                              alignment: Alignment.center,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.date_range_rounded, size: 18),
                                label: Text(local.selectDateRange, style: Theme.of(context).textTheme.bodySmall),
                                onPressed: pickDateRange,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: ColorValues.green700,
                                  side: const BorderSide(color: ColorValues.green200),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  backgroundColor: ColorValues.green50,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: _buildContent(context, raw, transformationController)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 12),
                              child: Text(local.sensorData, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                            ...raw.history?.map(_buildHistoryCard) ?? [],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HistoryModel history, TransformationController transformationController) {
    final local = AppLocalizations.of(context)!;
    final entries = history.history ?? [];

    if (entries.isEmpty) {
      return Center(child: Text(local.noSensorDataFound, style: Theme.of(context).textTheme.bodyMedium));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // ==== BAGIAN TOMBOL TOGGLE MODE ZOOM ====
          Text(
            _isZoomMode ? 'Mode Zoom Aktif (Scroll Terkunci)' : local.swipeForMoreCharts,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: _isZoomMode ? Colors.orange.shade800 : Colors.black),
          ),
          const SizedBox(height: 8),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PageView(
                // Kunci perpindahan halaman chart jika sedang melakukan zoom/pan grafis
                physics: _isZoomMode ? const NeverScrollableScrollPhysics() : const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildChart(entries, ChartType.ph, transformationController),
                  _buildChart(entries, ChartType.ppm, transformationController),
                ],
              ),
            ),
          ),
          ActionChip(
            avatar: Icon(
              _isZoomMode ? Icons.zoom_in_map_rounded : Icons.zoom_out_map_rounded,
              size: 16,
              color: _isZoomMode ? Colors.white : Colors.green,
            ),
            label: Text(
              _isZoomMode ? '${local.finish} Zoom' : 'Zoom Chart',
              style: TextStyle(fontSize: 12, color: _isZoomMode ? Colors.white : Colors.green),
            ),
            backgroundColor: _isZoomMode ? Colors.green : Colors.green.withAlpha(30),
            side: BorderSide(color: Colors.green.withAlpha(50)),
            onPressed: () {
              setState(() {
                _isZoomMode = !_isZoomMode;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<HistoryEntity> entries, ChartType chartType, TransformationController? transformationController) {
    if (entries.isEmpty) return const SizedBox.shrink();

    final dateFormat = DateFormat('dd/MM');
    final values = entries.map((e) => chartType == ChartType.ph ? e.phAvg : e.ppmAvg).toList();
    final spots = List<FlSpot>.generate(values.length, (i) => FlSpot(i.toDouble(), values[i]));

    final minX = 0.0;
    final maxX = (entries.length - 1).toDouble();

    double minY = values.reduce((a, b) => a < b ? a : b);
    double maxY = values.reduce((a, b) => a > b ? a : b);

    if ((maxY - minY).abs() < 0.0001) {
      minY -= 1;
      maxY += 1;
    } else {
      final padding = (maxY - minY) * 0.15; // Beri ruang vertikal sedikit lebih lega
      minY -= padding;
      maxY += padding;
    }

    final yInterval = (maxY - minY) / 4;
    final legendTextStyle = Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend Section
        Row(
          children: [
            Container(width: 12, height: 4, color: chartType == ChartType.ph ? Colors.blueAccent : Colors.green),
            const SizedBox(width: 8),
            Text(chartType == ChartType.ph ? 'pH Avg' : 'PPM Avg', style: legendTextStyle),
            const SizedBox(width: 12),
            Text('min ${values.reduce((a, b) => a < b ? a : b).toStringAsFixed(2)}', style: legendTextStyle.copyWith(color: Colors.grey[600])),
            const SizedBox(width: 8),
            Text('max ${values.reduce((a, b) => a > b ? a : b).toStringAsFixed(2)}', style: legendTextStyle.copyWith(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 12),

        // Chart Container
        Container(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 4, bottom: 8), // Sesuaikan padding agar teks sumbu tak terpotong
          decoration: BoxDecoration(
            color: ColorValues.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColorValues.neutral200),
          ),
          child: AspectRatio(
            aspectRatio: 1.4, // Sedikit disesuaikan agar proporsional saat di-zoom
            child: LineChart(
              transformationConfig: FlTransformationConfig(
                panEnabled: true,
                scaleEnabled: true,
                scaleAxis: FlScaleAxis.horizontal, // KUNCI: Zoom hanya melebar ke samping (X-axis)
                transformationController: transformationController,
              ),
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: yInterval,
                  // Mengurangi kepadatan garis grid agar terlihat bersih
                  getDrawingHorizontalLine: (value) => FlLine(strokeWidth: 0.5, color: Colors.grey.shade200),
                  getDrawingVerticalLine: (value) => FlLine(strokeWidth: 0.5, color: Colors.grey.shade100),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    left: BorderSide(color: Colors.grey.shade300, width: 1),
                    top: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: yInterval,
                      reservedSize: 40,
                      getTitlesWidget: (val, meta) {
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(val.toStringAsFixed(1), style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      // Mengatur interval dinamis berdasarkan jumlah data agar teks tidak tumpang tindih
                      interval: (entries.length / 5).clamp(1.0, double.infinity),
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final idx = value.round().clamp(0, entries.length - 1);
                        if (value % 1 != 0 && value != maxX) return const SizedBox.shrink(); // Hanya tampilkan angka bulat indeks

                        return SideTitleWidget(
                          meta: meta,
                          space: 8,
                          child: Text(
                            dateFormat.format(entries[idx].date),
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.black.withOpacity(0.8),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((s) {
                        final idx = s.spotIndex.clamp(0, entries.length - 1);
                        final e = entries[idx];
                        final label = chartType == ChartType.ph ? 'pH Avg' : 'PPM Avg';
                        return LineTooltipItem(
                          '${DateFormat('dd MMM yyyy').format(e.date)}\n$label: ${s.y.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    curveSmoothness: 0.35,
                    preventCurveOverShooting: true,
                    color: chartType == ChartType.ph ? ColorValues.blueProgress : ColorValues.green600,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: entries.length < 20, // Otomatis sembunyikan titik bulat jika data terlalu padat agar tetap rapi
                      getDotPainter: (spot, dbl, barData, it) => FlDotCirclePainter(
                        radius: 4,
                        color: chartType == ChartType.ph ? ColorValues.blueProgress : ColorValues.green600,
                        strokeWidth: 1.5,
                        strokeColor: Colors.white,
                      ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: (chartType == ChartType.ph ? ColorValues.blueProgress : ColorValues.green600).withOpacity(0.1),
                    ),
                  ),
                ],
                clipData: const FlClipData.all(), // Memotong garis agar tidak tembus keluar border saat di-zoom
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(HistoryEntity e) {
    final df = DateFormat('EEEE, dd MMM yyyy', '${ref.watch(localeProvider).languageCode}_${ref.watch(localeProvider).countryCode ?? ''}');
    return Card(
      color: ColorValues.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: ColorValues.neutral200),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
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
      Text(label, style: Theme.of(context).textTheme.bodySmall),
      Text(value.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}
