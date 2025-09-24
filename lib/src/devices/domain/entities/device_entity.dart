import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_entity.freezed.dart';
part 'device_entity.g.dart';

@freezed
sealed class DeviceEntity with _$DeviceEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory DeviceEntity({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    required String serialNumber,
    required String adminStatus,
    required String status,
    String? ssid,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _DeviceEntity;

  factory DeviceEntity.fromJson(Map<String, dynamic> json) => _$DeviceEntityFromJson(json);
}
