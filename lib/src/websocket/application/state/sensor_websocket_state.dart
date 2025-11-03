import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_websocket_state.freezed.dart';

@freezed
sealed class SensorWebsocketState with _$SensorWebsocketState {
  const factory SensorWebsocketState({
    @Default(false) bool isConnected,
    @Default(AsyncLoading()) AsyncValue<Map<String, dynamic>> sensorData,
    @Default('') String errorMessage,
  }) = _SensorWebsocketState;
}
