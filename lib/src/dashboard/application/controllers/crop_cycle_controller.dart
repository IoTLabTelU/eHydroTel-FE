import 'package:hydro_iot/src/dashboard/application/providers/crop_cycle_providers.dart';
import 'package:hydro_iot/src/dashboard/data/models/edit_session_data.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crop_cycle_controller.g.dart';

@riverpod
class CropCycleController extends _$CropCycleController {
  @override
  FutureOr<void> build() async {}

  Future<void> addCropCycleSession(SessionData sessionData) async {
    if (!ref.mounted) return;
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      await ref.read(cropCycleRepositoryProvider).addCropCycle(sessionData);
    });

    if (!ref.mounted) return;
    state = result;
  }

  Future<void> updateCropCycleSession(
    String id,
    EditSessionData sessionData,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(cropCycleRepositoryProvider)
          .updateCropCycle(id, sessionData);
    });
  }

  Future<void> deleteCropCycleSession(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(cropCycleRepositoryProvider).deleteCropCycle(id);
    });
  }

  Future<void> endCropCycleSession(String id) async {
    if (!ref.mounted) return;
    state = const AsyncValue.loading();

    final result = await AsyncValue.guard(() async {
      await ref.read(cropCycleRepositoryProvider).endCropCycle(id);
    });

    if (!ref.mounted) return;
    state = result;
  }
}
