import 'package:hydro_iot/pkg.dart';
import 'package:hydro_iot/src/notification/application/providers/notification_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_controller.g.dart';

@riverpod
class NotificationController extends _$NotificationController {
  @override
  void build() {}

  Future<void> registerFcmToken(String? fcmToken) async {
    if (fcmToken == null || fcmToken.isEmpty) {
      debugPrint('FCM Token is null or empty, skipping registration.');
      return;
    }
    final repository = ref.read(notificationRepositoryProvider);
    await repository.registerTokenNotification(fcmToken);
  }

  Future<void> softDeleteNotification(String notificationId) async {
    final repository = ref.read(notificationRepositoryProvider);
    await repository.softDeleteNotification(notificationId);
  }
}
