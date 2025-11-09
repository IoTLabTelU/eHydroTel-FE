import 'package:hydro_iot/src/dashboard/application/providers/crop_cycle_providers.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/crop_cycle_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crop_cycle_for_dashboard_controller.g.dart';

@riverpod
class CropCycleForDashboardController extends _$CropCycleForDashboardController {
  String status = 'ongoing';
  bool active = true;

  @override
  FutureOr<List<CropCycle>> build() async {
    return fetchCropCycles();
  }

  Future<List<CropCycle>> fetchCropCycles() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final cropCycleResponse = await ref.read(cropCycleRepositoryProvider).getCropCyclesForDashboard(status, active);
      return cropCycleResponse.data;
    });
    return state.value ?? [];
  }
}
