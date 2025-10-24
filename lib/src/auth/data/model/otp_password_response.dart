import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_password_response.freezed.dart';
part 'otp_password_response.g.dart';

@freezed
sealed class OtpPasswordResponse with _$OtpPasswordResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OtpPasswordResponse({required String resetToken}) = _OtpPasswordResponse;

  factory OtpPasswordResponse.fromJson(Map<String, dynamic> json) => _$OtpPasswordResponseFromJson(json);
}
