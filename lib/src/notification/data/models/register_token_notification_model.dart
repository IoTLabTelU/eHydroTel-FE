import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_token_notification_model.freezed.dart';
part 'register_token_notification_model.g.dart';

@freezed
sealed class RegisterTokenNotificationModel with _$RegisterTokenNotificationModel {
  const factory RegisterTokenNotificationModel({
    required String id,
    required String userId,
    required String token,
    required String platform,
  }) = _RegisterTokenNotificationModel;

  factory RegisterTokenNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterTokenNotificationModelFromJson(json);
}
