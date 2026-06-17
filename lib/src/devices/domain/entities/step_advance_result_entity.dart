import 'package:freezed_annotation/freezed_annotation.dart';
import 'calibration_session_entity.dart';
import 'calibration_step_def_entity.dart';

part 'step_advance_result_entity.freezed.dart';
part 'step_advance_result_entity.g.dart';

@freezed
sealed class StepAdvanceResultEntity with _$StepAdvanceResultEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StepAdvanceResultEntity({
    required CalibrationStepDefEntity? nextStep,
    required bool isFinal,
    required CalibrationSessionEntity session,
  }) = _StepAdvanceResultEntity;

  factory StepAdvanceResultEntity.fromJson(Map<String, dynamic> json) => _$StepAdvanceResultEntityFromJson(json);
}
