import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/application/providers/calibration_provider.dart';
import 'package:hydro_iot/src/devices/presentation/screens/calibration/calibration_steps_screen.dart';
import 'package:hydro_iot/utils/utils.dart';

final LocalNotificationHelper _localNotificationHelper = LocalNotificationHelper();

// ProviderContainer global untuk invalidate provider dari luar widget tree
// (saat notif masuk dari background/terminated). Harus di-assign di main.dart
// sebelum runApp() dipanggil, contoh:
//   fcmProviderContainer = ref dari ProviderScope via ProviderContainer();
ProviderContainer? fcmProviderContainer;

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

      _localNotificationHelper.showNotification(
        DateTime.now().millisecondsSinceEpoch % 100000,
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? 'Some Notification Body',
      );

      // Jika notif dari backend berisi serial kalibrasi, invalidate card
      // supaya tampilan progress langsung ter-update tanpa perlu refresh manual.
      final serial = message.data['serial_number'] as String?;
      if (serial != null) {
        fcmProviderContainer?.invalidate(activeCalibrationSessionProvider(serial));
      }
    });
  }

  void _handleMessageOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message clicked!: ${message.messageId}');
      _routeFromMessage(message);
    });
  }

  void _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App opened from terminated state by a message: ${initialMessage.messageId}');
      _routeFromMessage(initialMessage);
    }
  }

  /// Routing berdasarkan payload notif:
  /// - Jika ada `serial_number` di data payload → langsung ke CalibrationStepsScreen
  ///   (resume kalibrasi tanpa lewat StartCalibrationScreen)
  /// - Fallback ke halaman notifikasi umum
  void _routeFromMessage(RemoteMessage message) {
    final serial = message.data['serial_number'] as String?;
    final context = NavigationService.rootNavigatorKey.currentContext;
    if (context == null) return;

    if (serial != null && serial.isNotEmpty) {
      context.push('/${CalibrationStepsScreen.path}', extra: {'serialNumber': serial});
    } else {
      context.push('/notification');
    }
  }
}
