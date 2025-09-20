import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_crop_cycles_usecase.dart';
import '../state/crop_cycle_state.dart';

class CropCycleNotifier extends StateNotifier<CropCycleState> {
  final GetCropCyclesUsecase getCropCyclesUsecase;

  CropCycleNotifier(this.getCropCyclesUsecase)
    : super(const CropCycleStateInitial());

  Future<void> fetchCropCycles() async {
    state = const CropCycleStateLoading();
    try {
      final response = await getCropCyclesUsecase.call();
      state = CropCycleStateLoaded(response);
    } catch (e) {
      state = CropCycleStateError(e.toString());
    }
  }
}
