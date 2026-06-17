import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_step_def_entity.freezed.dart';
part 'calibration_step_def_entity.g.dart';

@freezed
sealed class CalibrationStepDefEntity with _$CalibrationStepDefEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CalibrationStepDefEntity({
    required int index,
    required String action,
    required String phase,
    required bool requiresSoak,
    required String label,
    String? soakKey,
  }) = _CalibrationStepDefEntity;

  factory CalibrationStepDefEntity.fromJson(Map<String, dynamic> json) => _$CalibrationStepDefEntityFromJson(json);
}
