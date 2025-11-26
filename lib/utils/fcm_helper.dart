import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter/widgets.dart';
import 'package:hydro_iot/utils/utils.dart';

final LocalNotificationHelper _localNotificationHelper = LocalNotificationHelper();

class FcmHelper {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final Completer<String?> _tokenCompleter = Completer<String?>();

  Future<void> initializeFCM() async {
    final permissions = await _firebaseMessaging.requestPermission();
    if (permissions.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('FCM permission denied');
      _tokenCompleter.complete(null);
      return;
    }
    final token = await _getFCMToken();
    if (!_tokenCompleter.isCompleted) _tokenCompleter.complete(token);
    if (token != null) await Storage().writeFcmToken(token);
    _listenTokenRefresh();

    _handleForegroundMessages();
    _handleMessageOpenedApp();
    _handleInitialMessage();
  }

  Future<String?> _getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  void _listenTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      if (!_tokenCompleter.isCompleted) {
        _tokenCompleter.complete(newToken);
      }
      await Storage().writeFcmToken(newToken);
    });
  }

  Future<String?> waitForToken() => _tokenCompleter.future;

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received a foreground message: ${message.messageId}');
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }
      _localNotificationHelper.showNotification(
        DateTime.now().millisecondsSinceEpoch % 100000,
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? 'Some Notification Body',
      );
    });
  }

  void _handleMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked!: ${message.messageId}');
      NavigationService.rootNavigatorKey.currentContext?.push('/notification');
    });
  }

  void _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state by a message: ${initialMessage.messageId}');
      NavigationService.rootNavigatorKey.currentContext?.push('/notification');
    }
  }
}
