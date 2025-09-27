import 'package:hydro_iot/src/dashboard/application/providers/crop_cycle_providers.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crop_cycle_controller.g.dart';

@riverpod
class CropCycleController extends _$CropCycleController {
  @override
  FutureOr<void> build() async {}

  Future<void> addCropCycleSession(SessionData sessionData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final res = await ref.read(cropCycleRepositoryProvider).addCropCycle(sessionData);
      if (!res) {
        throw Exception('Failed to add crop cycle session');
      }
    });
  }
}
