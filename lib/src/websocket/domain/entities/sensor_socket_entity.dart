import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_socket_entity.freezed.dart';
part 'sensor_socket_entity.g.dart';

@freezed
sealed class SensorSocketEntity with _$SensorSocketEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SensorSocketEntity({
    required double ph,
    required double ppm,
    required double temperature,
    required DateTime timestamp,
  }) = _SensorSocketEntity;

  factory SensorSocketEntity.fromJson(Map<String, dynamic> json) => _$SensorSocketEntityFromJson(json);
}
