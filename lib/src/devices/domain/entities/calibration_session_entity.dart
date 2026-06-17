import 'package:freezed_annotation/freezed_annotation.dart';
import 'device_entity.dart';

part 'calibration_session_entity.freezed.dart';
part 'calibration_session_entity.g.dart';

@freezed
sealed class CalibrationSessionEntity with _$CalibrationSessionEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CalibrationSessionEntity({
    required String id,
    String? deviceId,
    String? userId,
    String? status,
    required String currentStep,
    required int currentStepIndex,
    String? soakStep,
    DateTime? soakStartedAt,
    int? soakDurationSec,
    DateTime? createdAt,
    DateTime? endedAt,
    DeviceEntity? device,
  }) = _CalibrationSessionEntity;

  factory CalibrationSessionEntity.fromJson(Map<String, dynamic> json) => _$CalibrationSessionEntityFromJson(json);
}
