import 'package:hydro_iot/src/websocket/application/providers/sensor_websocket_provider.dart';
import 'package:hydro_iot/src/websocket/application/state/sensor_websocket_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sensor_websocket_controller.g.dart';

@riverpod
class SensorWebsocketController extends _$SensorWebsocketController {
  @override
  SensorWebsocketState build() {
    final data = ref.watch(sensorWebsocketRepositoryProvider);
    final websocket = ref.watch(sensorWebsocketRepositoryImplProvider);
    return SensorWebsocketState(isConnected: websocket.isSubscribed, sensorData: data);
  }
}
