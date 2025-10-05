import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydro_iot/src/devices/domain/entities/records_entity.dart';

part 'history_entity.freezed.dart';
part 'history_entity.g.dart';

@freezed
sealed class HistoryEntity with _$HistoryEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HistoryEntity({
    required DateTime time,
    required double phAvg,
    required double ppmAvg,
    required double phMin,
    required double phMax,
    required double ppmMin,
    required double ppmMax,
    required List<RecordsEntity>? records,
  }) = _HistoryEntity;

  factory HistoryEntity.fromJson(Map<String, dynamic> json) => _$HistoryEntityFromJson(json);
}
