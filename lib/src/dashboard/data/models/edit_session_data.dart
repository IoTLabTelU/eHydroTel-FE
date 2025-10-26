import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_session_data.freezed.dart';
part 'edit_session_data.g.dart';

@freezed
sealed class EditSessionData with _$EditSessionData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory EditSessionData({
    required String? name,
    required double? phMin,
    required double? phMax,
    required double? ppmMin,
    required double? ppmMax,
  }) = _EditSessionData;

  factory EditSessionData.fromJson(Map<String, dynamic> json) => _$EditSessionDataFromJson(json);
}
