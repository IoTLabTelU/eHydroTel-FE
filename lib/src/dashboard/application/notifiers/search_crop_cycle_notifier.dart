import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/search_crop_cycles_usecase.dart';
import '../state/crop_cycle_state.dart';

class SearchCropCycleNotifier extends StateNotifier<CropCycleState> {
  final SearchCropCyclesUsecase searchCropCyclesUsecase;

  SearchCropCycleNotifier(this.searchCropCyclesUsecase) : super(const CropCycleState());

  Future<void> searchCropCycles(String query) async {
    if (query.trim().isEmpty) {
      state = const CropCycleState();
      return;
    }
    state = const CropCycleState(isLoading: true);
    try {
      final cropCycle = await searchCropCyclesUsecase.call(query);
      state = CropCycleState(items: cropCycle.data);
    } catch (e) {
      state = CropCycleState(error: e);
    }
  }

  void clearSearch() {
    state = const CropCycleState();
  }
}
