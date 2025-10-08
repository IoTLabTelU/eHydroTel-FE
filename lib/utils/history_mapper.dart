import 'package:hydro_iot/src/devices/domain/entities/history_entity.dart';

class HistoryChartMapper {
  static ({List<double> phSeries, List<double> ppmSeries, List<DateTime> timestamps}) mapRecordsToSeries(
    List<HistoryEntity> history,
  ) {
    final List<double> phSeries = [];
    final List<double> ppmSeries = [];
    final List<DateTime> timestamps = [];

    for (final day in history) {
      for (final record in day.records ?? []) {
        timestamps.add(record.timestamp);
        phSeries.add(record.ph);
        ppmSeries.add(record.ppm);
      }
    }

    return (phSeries: phSeries, ppmSeries: ppmSeries, timestamps: timestamps);
  }
}
