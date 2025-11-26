import 'dart:developer';
import 'dart:io';

import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/notification/data/models/register_token_notification_model.dart';
import 'package:hydro_iot/src/notification/domain/entities/notification_history_entity.dart';
import 'package:hydro_iot/src/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepositoryImpl(this._apiClient);
  @override
  Future<Responses<List<NotificationHistoryEntity>>> fetchNotifications() {
    return _apiClient
        .get<List<NotificationHistoryEntity>>(
          Params<List<NotificationHistoryEntity>>(
            path: EndpointStrings.notifHistory,
            fromJson: (json) {
              final data = json['data'] as List;
              log('Data JSON: $data');
              return data.map((e) {
                final test = NotificationHistoryEntity.fromJson(e);
                log('Notification JSON: $test');
                return test;
              }).toList();
            },
          ),
        )
        .then((response) {
          log('Notification fetch response: ${response.data}');
          if (!response.isSuccess) {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
          log('Fetched notifications: ${response.data!}');
          return response;
        });
  }

  @override
  Future<Responses<bool>> softDeleteNotification(String notificationId) {
    return _apiClient
        .delete<bool>(
          Params(
            path: '${EndpointStrings.notif}/$notificationId',
            fromJson: (json) {
              return json['success'] as bool;
            },
          ),
        )
        .then((response) {
          if (response.isSuccess) {
            return response;
          } else {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
        });
  }

  @override
  Future<Responses<RegisterTokenNotificationModel>> registerTokenNotification(String fcmToken) {
    return _apiClient
        .post<RegisterTokenNotificationModel>(
          Params(
            path: EndpointStrings.registerFcmToken,
            fromJson: (json) {
              return RegisterTokenNotificationModel.fromJson(json['data']);
            },
            body: {
              'token': fcmToken,
              'platform': Platform.isAndroid
                  ? 'android'
                  : Platform.isIOS
                  ? 'ios'
                  : 'unknown',
            },
          ),
        )
        .then((response) {
          if (response.isSuccess && response.data != null) {
            return response;
          } else {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
        });
  }
}
