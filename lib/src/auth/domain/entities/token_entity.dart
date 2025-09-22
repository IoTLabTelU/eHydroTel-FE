import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_entity.freezed.dart';
part 'token_entity.g.dart';

@freezed
sealed class TokenEntity with _$TokenEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory TokenEntity({required String accessToken, required String refreshToken, required int expiresIn}) =
      _TokenEntity;

  factory TokenEntity.fromJson(Map<String, dynamic> json) => _$TokenEntityFromJson(json);
}
