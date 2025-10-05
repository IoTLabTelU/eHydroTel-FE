import 'package:freezed_annotation/freezed_annotation.dart';

part 'records_entity.freezed.dart';
part 'records_entity.g.dart';

@freezed
sealed class RecordsEntity with _$RecordsEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RecordsEntity({required DateTime timestamp, required double ph, required double ppm}) = _RecordsEntity;

  factory RecordsEntity.fromJson(Map<String, dynamic> json) => _$RecordsEntityFromJson(json);
}
