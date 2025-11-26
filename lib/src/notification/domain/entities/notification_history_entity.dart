import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_history_entity.freezed.dart';
part 'notification_history_entity.g.dart';

@freezed
sealed class NotificationHistoryEntity with _$NotificationHistoryEntity {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory NotificationHistoryEntity({
    required String id,
    required String userId,
    required String title,
    required String body,
    required String? deviceId,
    required String type,
    required String status,
    required int attempts,
    required DateTime? lastAttemptAt,
    required DateTime createdAt,
    required DateTime? deletedAt,
  }) = _NotificationHistoryEntity;

  factory NotificationHistoryEntity.fromJson(Map<String, dynamic> json) => _$NotificationHistoryEntityFromJson(json);
}
