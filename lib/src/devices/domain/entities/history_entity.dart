import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_entity.freezed.dart';
part 'history_entity.g.dart';

@freezed
sealed class HistoryEntity with _$HistoryEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory HistoryEntity({
    required DateTime date,
    required String timezone,
    required double phAvg,
    required double ppmAvg,
    required double phMin,
    required double phMax,
    required double ppmMin,
    required double ppmMax,
  }) = _HistoryEntity;

  factory HistoryEntity.fromJson(Map<String, dynamic> json) => _$HistoryEntityFromJson(json);
}
