import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/calibration_progress_entity.dart';
import '../../domain/entities/calibration_session_entity.dart';
import '../../domain/entities/calibration_timer_entity.dart';

part 'active_calibration_session_model.freezed.dart';
part 'active_calibration_session_model.g.dart';

@freezed
sealed class ActiveCalibrationSessionModel with _$ActiveCalibrationSessionModel {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ActiveCalibrationSessionModel({
    required CalibrationSessionEntity session,
    required CalibrationProgressEntity progress,
    required CalibrationTimerEntity? timer,

    required bool isFinal,
    required,
  }) = _ActiveCalibrationSessionModel;

  factory ActiveCalibrationSessionModel.fromJson(Map<String, dynamic> json) => _$ActiveCalibrationSessionModelFromJson(json);
}
