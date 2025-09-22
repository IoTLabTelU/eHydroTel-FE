import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydro_iot/src/auth/domain/entities/token_entity.dart';
import 'package:hydro_iot/src/auth/domain/entities/user_entity.dart';

part 'auth_response.freezed.dart';
part 'auth_response.g.dart';

@freezed
sealed class AuthResponse with _$AuthResponse {
  const AuthResponse._();
  const factory AuthResponse({required UserEntity? user, required TokenEntity? tokens}) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => _$AuthResponseFromJson(json);
}
