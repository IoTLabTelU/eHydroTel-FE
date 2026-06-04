import 'package:flutter_riverpod/legacy.dart';
import '../../domain/usecases/get_crop_cycles_usecase.dart';
import '../state/crop_cycle_state.dart';

const _kLimit = 10;

class CropCycleNotifier extends StateNotifier<CropCycleState> {
  final GetCropCyclesUsecase getCropCyclesUsecase;

  int _currentPage = 1;

  CropCycleNotifier(this.getCropCyclesUsecase) : super(const CropCycleState());

  /// Dipanggil saat pertama load atau pull-to-refresh — reset ke page 1
  Future<void> fetchCropCycles(String status, bool active) async {
    state = const CropCycleState(isLoading: true);
    try {
      final items = await getCropCyclesUsecase.call(status, active, page: 1, limit: _kLimit);
      _currentPage = 1;
      state = CropCycleState(items: items.data, hasMore: items.data.length >= _kLimit);
    } catch (e) {
      state = CropCycleState(error: e);
    }
  }

  /// Dipanggil saat scroll mentok bawah
  Future<void> loadMore(String status, bool active) async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = _currentPage + 1;
      final newItems = await getCropCyclesUsecase.call(status, active, page: nextPage, limit: _kLimit);
      _currentPage = nextPage;
      state = state.copyWith(isLoadingMore: false, hasMore: newItems.data.length >= _kLimit, items: [...state.items, ...newItems.data]);
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e);
    }
  }
}
