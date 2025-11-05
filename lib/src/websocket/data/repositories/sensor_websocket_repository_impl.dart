import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hydro_iot/core/config/config.dart';
import 'package:hydro_iot/core/providers/websocket_provider.dart';
import 'package:hydro_iot/src/websocket/domain/repositories/sensor_websocket_repository.dart';
import 'package:hydro_iot/utils/storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SensorWebsocketRepositoryImpl implements SensorWebsocketRepository {
  final SensorWebsocket _websocket;
  SensorWebsocketRepositoryImpl(this._websocket) {
    _init();
  }

  WebSocketChannel? channel;
  bool isDisposed = false;
  bool isSubscribed = false;
  StreamController<Map<String, dynamic>> sensorDataController = StreamController<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get sensorDataStream => sensorDataController.stream;

  void _init() async {
    channel = await _websocket.connect();
    _subscribe();
    _listen();
  }

  void _subscribe() {
    if (isDisposed) return;
    if (isSubscribed || channel == null) return;
    //TODO: Replace with actual device serial number
    final message = 'device:serialNumber:sensor';
    isSubscribed = true;
    channel!.sink.add(message);
  }

  void _listen() {
    if (isDisposed || channel == null) return;
    channel!.stream.listen(
      (data) {
        final json = jsonDecode(data);
        sensorDataController.add(json);
      },
      onError: (cancel) async {
        try {
          final r = await Dio().post(
            '${BaseConfigs.baseUrl}/auth/refresh-token',
            data: {'refresh_token': await Storage().readRefreshToken},
          );
          final data = r.data['data'] as Map<String, dynamic>;
          await Storage().writeTokens(
            accessToken: data['access_token'],
            refreshToken: data['refresh_token'],
            expiresInSeconds: data['expires_in'],
          );
        } catch (e) {
          throw Exception('Failed to refresh token: $e');
        } finally {
          _reconnect();
        }
      },
      cancelOnError: true,
    );
  }

  void _reconnect() {
    if (isDisposed) return;
    Future.delayed(const Duration(seconds: 3), () {
      _init();
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    channel?.sink.close();
    sensorDataController.close();
  }
}
