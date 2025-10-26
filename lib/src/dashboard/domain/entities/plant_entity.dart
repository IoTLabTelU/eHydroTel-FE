import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_entity.freezed.dart';
part 'plant_entity.g.dart';

@freezed
sealed class PlantEntity with _$PlantEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PlantEntity({
    required String id,
    required String name,
    required double? phMin,
    required double? phMax,
    required int? ppmMin,
    required int? ppmMax,
    required String? imageUrl,
    required String? createdBy,
    required bool isGlobal,
    required int? expectedDurationDays,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlantEntity;

  factory PlantEntity.fromJson(Map<String, dynamic> json) => _$PlantEntityFromJson(json);
}
