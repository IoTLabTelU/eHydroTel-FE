import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/src/devices/data/models/history_model.dart';

abstract class HistoryRepository {
  Future<Responses<HistoryModel>> getCropCycleHistory({required String cropCycleId, DateTime? start, DateTime? end});
}
