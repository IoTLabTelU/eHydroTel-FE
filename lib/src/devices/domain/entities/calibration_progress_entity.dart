import 'package:freezed_annotation/freezed_annotation.dart';

part 'calibration_progress_entity.freezed.dart';
part 'calibration_progress_entity.g.dart';

@freezed
sealed class CalibrationProgressEntity with _$CalibrationProgressEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CalibrationProgressEntity({required int current, required int total}) = _CalibrationProgressEntity;

  factory CalibrationProgressEntity.fromJson(Map<String, dynamic> json) => _$CalibrationProgressEntityFromJson(json);
}
