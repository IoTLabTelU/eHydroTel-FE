import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydro_iot/src/websocket/domain/entities/sensor_socket_entity.dart';

part 'sensor_websocket_state.freezed.dart';

@freezed
sealed class SensorWebsocketState with _$SensorWebsocketState {
  const factory SensorWebsocketState({required bool isConnected, required AsyncValue<SensorSocketEntity> sensorData}) =
      _SensorWebsocketState;
}
