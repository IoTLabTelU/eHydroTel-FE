import 'package:hydro_iot/src/notification/application/providers/notification_provider.dart';
import 'package:hydro_iot/src/notification/domain/entities/notification_history_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_history_controller.g.dart';

@riverpod
class NotificationHistoryController extends _$NotificationHistoryController {
  @override
  FutureOr<List<NotificationHistoryEntity>> build() async {
    return fetchNotifications();
  }

  Future<List<NotificationHistoryEntity>> fetchNotifications() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final response = await ref.read(notificationRepositoryProvider).fetchNotifications();
      if (!response.isSuccess || response.data == null) {
        state = AsyncValue.error(response.message ?? 'Failed to fetch notifications', StackTrace.current);
        throw Exception(response.message ?? 'Failed to fetch notifications');
      }
      state = AsyncValue.data(response.data!);
      return response.data!;
    });
    return state.value ?? [];
  }
}
