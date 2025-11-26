import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/notification/data/models/register_token_notification_model.dart';
import 'package:hydro_iot/src/notification/domain/entities/notification_history_entity.dart';

abstract class NotificationRepository {
  Future<Responses<List<NotificationHistoryEntity>>> fetchNotifications();
  Future<Responses<bool>> softDeleteNotification(String notificationId);
  Future<Responses<RegisterTokenNotificationModel>> registerTokenNotification(String fcmToken);
}
