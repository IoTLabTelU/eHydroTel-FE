import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydro_iot/src/notification/domain/entities/notification_history_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_history_state.freezed.dart';

@freezed
sealed class NotificationHistoryState with _$NotificationHistoryState {
  const factory NotificationHistoryState({
    required bool isLoading,
    required AsyncValue<List<NotificationHistoryEntity>> notifications,
  }) = _NotificationHistoryState;
}
