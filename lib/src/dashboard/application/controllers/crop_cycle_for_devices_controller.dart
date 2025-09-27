import 'package:hydro_iot/src/dashboard/application/providers/crop_cycle_providers.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/crop_cycle_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crop_cycle_for_devices_controller.g.dart';

@riverpod
class CropCycleForDevicesController extends _$CropCycleForDevicesController {
  @override
  FutureOr<List<CropCycle>> build(String id) async {
    return fetchCropCycles(id);
  }

  Future<List<CropCycle>> fetchCropCycles(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final cropCycleResponse = await ref.read(cropCycleRepositoryProvider).getCropCyclesForDevices(id);
      return cropCycleResponse.data;
    });
    return state.value ?? [];
  }
}
