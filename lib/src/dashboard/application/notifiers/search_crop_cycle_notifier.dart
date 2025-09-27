import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/search_crop_cycles_usecase.dart';
import '../state/crop_cycle_state.dart';

class SearchCropCycleNotifier extends StateNotifier<CropCycleState> {
  final SearchCropCyclesUsecase searchCropCyclesUsecase;

  SearchCropCycleNotifier(this.searchCropCyclesUsecase) : super(const CropCycleStateInitial());

  Future<void> searchCropCycles(String query) async {
    if (query.trim().isEmpty) {
      state = const CropCycleStateInitial();
      return;
    }
    
    state = const CropCycleStateLoading();
    try {
      final response = await searchCropCyclesUsecase.call(query);
      state = CropCycleStateLoaded(response);
    } catch (e) {
      state = CropCycleStateError(e.toString());
    }
  }

  void clearSearch() {
    state = const CropCycleStateInitial();
  }
}
