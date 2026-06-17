import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_timer_entity.freezed.dart';
part 'calibration_timer_entity.g.dart';

@freezed
sealed class CalibrationTimerEntity with _$CalibrationTimerEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CalibrationTimerEntity({
    required String step,
    required DateTime startedAt,
    required int durationSec,
    required DateTime endsAt,
    int? remainingSec,
  }) = _CalibrationTimerEntity;

  factory CalibrationTimerEntity.fromJson(Map<String, dynamic> json) => _$CalibrationTimerEntityFromJson(json);
}
