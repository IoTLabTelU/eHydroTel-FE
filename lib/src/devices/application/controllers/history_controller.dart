import 'package:hydro_iot/src/devices/application/providers/history_provider.dart';
import 'package:hydro_iot/src/devices/data/models/history_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_controller.g.dart';

@riverpod
class HistoryController extends _$HistoryController {
  @override
  FutureOr<HistoryModel> build(String cropCycleId) async {
    return fetchHistory(cropCycleId: cropCycleId);
  }

  Future<HistoryModel> fetchHistory({required String cropCycleId, DateTime? start, DateTime? end}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(historyRepositoryProvider);
      final response = await repository.getCropCycleHistory(cropCycleId: cropCycleId, start: start, end: end);
      return response.data!;
    });
    return state.value!;
  }
}
