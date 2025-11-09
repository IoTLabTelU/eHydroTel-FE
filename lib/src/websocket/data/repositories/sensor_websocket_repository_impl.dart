import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hydro_iot/core/config/config.dart';
import 'package:hydro_iot/core/providers/websocket_provider.dart';
import 'package:hydro_iot/src/websocket/domain/entities/sensor_socket_entity.dart';
import 'package:hydro_iot/src/websocket/domain/repositories/sensor_websocket_repository.dart';
import 'package:hydro_iot/utils/storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;

class SensorWebsocketRepositoryImpl implements SensorWebsocketRepository {
  final SensorWebsocket _websocket;
  SensorWebsocketRepositoryImpl(this._websocket);

  socket.Socket? channel;
  bool isDisposed = false;
  bool isConnected = false;
  bool isListening = false;
  int _retryCount = 0;
  Timer? _reconnectTimer;
  StreamController<SensorSocketEntity> sensorDataController = StreamController<SensorSocketEntity>();
  Stream<SensorSocketEntity> get sensorDataStream => sensorDataController.stream;

  @override
  void init(String serialNumber) async {
    channel = await _websocket.connect();
    _listen(serialNumber);
  }

  void _listen(String serialNumber) {
    if (isDisposed || channel == null) return;
    String event = 'device:$serialNumber:sensor';
    channel?.onConnect((_) {
      isConnected = true;
      _retryCount = 0;
      log('Connected to socket.io');
    });
    channel?.onError((error) async {
      log('Got error from socket.io: ${error.toString()}');
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
        Future.delayed(const Duration(seconds: 3), () => reconnect(serialNumber));
      }
    });
    channel?.on(event, (data) {
      log('Received sensor data: $data');
      isListening = true;
      sensorDataController.add(SensorSocketEntity.fromJson(data as Map<String, dynamic>));
    });
    channel?.onConnectError((err) {
      log('⚠️ Connect error: $err');
      isConnected = false;
      isListening = false;
      Future.delayed(const Duration(seconds: 3), () => reconnect(serialNumber));
    });

    channel?.onReconnectError((err) {
      log('❌ Reconnect error: $err');
    });

    channel?.onReconnectAttempt((_) {
      log('🔄 Trying to reconnect...');
    });

    channel?.onDisconnect((_) {
      log('🔌 Socket disconnected');
      isConnected = false;
      isListening = false;
      Future.delayed(const Duration(seconds: 3), () => reconnect(serialNumber));
    });
  }

  @override
  void reconnect(String serialNumber) async {
    if (isDisposed) return;
    if (_reconnectTimer != null && _reconnectTimer!.isActive) return;

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.none)) {
      log('No internet connection, delaying reconnect...');
      Future.delayed(const Duration(seconds: 5), () => reconnect(serialNumber));
      return;
    }

    log('Reconnecting socket...');
    final delay = Duration(seconds: (2 << _retryCount).clamp(2, 30));
    _reconnectTimer = Timer(delay, () {
      try {
        init(serialNumber);
      } catch (e) {
        log('Reconnect failed: $e');
        Future.delayed(const Duration(seconds: 3), () => reconnect(serialNumber));
      }
      _retryCount++;
    });
  }

  @override
  void dispose() {
    isDisposed = true;
    isListening = false;
    channel?.dispose();
    sensorDataController.close();
    _reconnectTimer?.cancel();
  }
}
