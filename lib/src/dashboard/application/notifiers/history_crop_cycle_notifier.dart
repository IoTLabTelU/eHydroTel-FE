import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/get_crop_cycles_usecase.dart';
import '../state/crop_cycle_state.dart';

class HistoryCropCycleNotifier extends StateNotifier<CropCycleState> {
  final GetCropCyclesUsecase getCropCyclesUsecase;

  HistoryCropCycleNotifier(this.getCropCyclesUsecase) : super(const CropCycleStateInitial());

  Future<void> fetchCropCycles(String status, bool active) async {
    state = const CropCycleStateLoading();
    try {
      final response = await getCropCyclesUsecase.call(status, active);
      state = CropCycleStateLoaded(response);
    } catch (e) {
      state = CropCycleStateError(e.toString());
    }
  }
}
