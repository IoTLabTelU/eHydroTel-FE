import 'package:hydro_iot/core/providers/provider.dart';
import 'package:hydro_iot/src/notification/data/repository/notification_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@riverpod
NotificationRepositoryImpl notificationRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return NotificationRepositoryImpl(apiClient);
}
