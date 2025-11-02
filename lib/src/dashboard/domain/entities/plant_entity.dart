import 'package:freezed_annotation/freezed_annotation.dart';

part 'plant_entity.freezed.dart';
part 'plant_entity.g.dart';

@freezed
sealed class PlantEntity with _$PlantEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory PlantEntity({
    required String id,
    required String name,
    @JsonKey(fromJson: _toDouble) required double? phMin,
    @JsonKey(fromJson: _toDouble) required double? phMax,
    @JsonKey(fromJson: _toInt) required int? ppmMin,
    @JsonKey(fromJson: _toInt) required int? ppmMax,
    required String? imageUrl,
    required String? createdBy,
    required bool isGlobal,
    @JsonKey(fromJson: _toInt) required int? expectedDurationDays,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _PlantEntity;

  factory PlantEntity.fromJson(Map<String, dynamic> json) => _$PlantEntityFromJson(json);
}

// Helper converters
double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}
