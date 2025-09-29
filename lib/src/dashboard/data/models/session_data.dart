import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_data.freezed.dart';
part 'session_data.g.dart';

@freezed
sealed class SessionData with _$SessionData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SessionData({
    required String deviceId,
    required String plantId,
    required String name,
    required double phMin,
    required double phMax,
    required double ppmMin,
    required double ppmMax,
    required int expectedEnd,
  }) = _SessionData;

  factory SessionData.fromJson(Map<String, dynamic> json) =>
      _$SessionDataFromJson(json);
}
