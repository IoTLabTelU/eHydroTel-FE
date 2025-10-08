import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/devices/application/controllers/history_controller.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/export_bottom_sheet_widget.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/history_chart_card_widget.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/history_toolbar_widget.dart';
import 'package:hydro_iot/utils/history_mapper.dart';

import '../../../../../res/res.dart';

class SensorHistoryScreen extends ConsumerStatefulWidget {
  final String deviceName;
  final String deviceId;
  final int ppmMin;
  final int ppmMax;
  final double phMin;
  final double phMax;
  const SensorHistoryScreen({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.ppmMin,
    required this.ppmMax,
    required this.phMin,
    required this.phMax,
  });

  static const String path = 'history';

  @override
  ConsumerState<SensorHistoryScreen> createState() => _SensorHistoryScreenState();
}

class _SensorHistoryScreenState extends ConsumerState<SensorHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _range;
  bool _loading = false;

  // Dummy chart data (replace with provider/backend data)
  List<double> phSeries = [6.5, 6.6, 6.2, 6.4, 6.8, 6.7, 6.5, 6.6, 6.3, 6.4, 6.6, 6.5];
  List<double> ppmSeries = [900, 920, 880, 950, 980, 970, 990, 1000, 960, 940, 930, 950];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: _range ?? DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _refresh() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _loading = false);
  }

  void _openExportSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ExportBottomSheet(onExportCsv: () => _simulateExport('csv'), onExportXlsx: () => _simulateExport('xlsx')),
    );
  }

  void _simulateExport(String ext) async {
    Navigator.pop(context);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const FancyLoadingDialog(title: 'Preparing export...'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    List<DateTime> timestamps = List.generate(
      phSeries.length,
      (index) => DateTime.now().subtract(Duration(hours: (phSeries.length - index) * 2)),
    );
    final history = ref.watch(historyControllerProvider(widget.deviceId));
    // final mappedData = HistoryChartMapper.mapRecordsToSeries(history.asData?.value.);
    // phSeries = mappedData.phSeries;
    // ppmSeries = mappedData.ppmSeries;
    // timestamps = mappedData.timestamps;
    // MASIH PERLU PERBAIKAN, NTAR LANJUT BESOK
    return Scaffold(
      appBar: AppBar(
        title: Text('${local.history} · ${widget.deviceName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _openExportSheet,
            tooltip: 'Export CSV/Excel',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: ColorValues.iotMainColor,
          tabs: const [
            Tab(text: 'pH'),
            Tab(text: 'PPM'),
          ],
        ),
      ),
      body: Column(
        children: [
          HistoryToolbar(
            rangeText: _range == null
                ? local.last7Days
                : '${_range!.start.toString().substring(0, 10)} → ${_range!.end.toString().substring(0, 10)}',
            onPickRange: _pickRange,
            onRefresh: _refresh,
            loading: _loading,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: TabBarView(
                controller: _tabController,
                children: [
                  HistoryChartCard(
                    title: local.phOverTime,
                    subtitle: 'Target ${widget.phMin} - ${widget.phMax}',
                    series: phSeries,
                    yMin: 4,
                    yMax: 8,
                    unit: '',
                    accent: ColorValues.iotNodeMCUColor,
                    timestamps: timestamps,
                  ),
                  HistoryChartCard(
                    title: local.ppmOverTime,
                    subtitle: 'Target ${widget.ppmMin} - ${widget.ppmMax}',
                    series: ppmSeries,
                    yMin: 600,
                    yMax: 1400,
                    unit: ' ppm',
                    accent: ColorValues.iotArduinoColor,
                    timestamps: timestamps,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
