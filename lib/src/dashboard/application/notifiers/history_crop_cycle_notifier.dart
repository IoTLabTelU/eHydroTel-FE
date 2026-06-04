import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/get_crop_cycles_usecase.dart';
import '../state/crop_cycle_state.dart';

class HistoryCropCycleNotifier extends StateNotifier<CropCycleState> {
  final GetCropCyclesUsecase getCropCyclesUsecase;

  HistoryCropCycleNotifier(this.getCropCyclesUsecase) : super(const CropCycleState());

  Future<void> fetchCropCycles(String status, bool active) async {
    state = const CropCycleState(isLoading: true);
    try {
      final items = await getCropCyclesUsecase.call(status, active);
      state = CropCycleState(items: items.data);
    } catch (e) {
      state = CropCycleState(error: e);
    }
  }
}
