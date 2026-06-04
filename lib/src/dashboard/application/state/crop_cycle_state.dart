import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/crop_cycle_entity.dart';

part 'crop_cycle_state.freezed.dart';

@freezed
sealed class CropCycleState with _$CropCycleState {
  const factory CropCycleState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(true) bool hasMore,
    @Default([]) List<CropCycle> items,
    Object? error,
  }) = _CropCycleState;

  const CropCycleState._();

  bool get isEmpty => !isLoading && error == null && items.isEmpty;
  bool get hasData => items.isNotEmpty;
}
