import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydro_iot/src/devices/domain/entities/history_entity.dart';

part 'history_model.freezed.dart';
part 'history_model.g.dart';

@freezed
sealed class HistoryModel with _$HistoryModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HistoryModel({
    required String deviceId,
    required String cropCycleId,
    required String timezone,
    required Map<String, DateTime> dateRange,
    required List<HistoryEntity>? history,
  }) = _HistoryModel;

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);
}
