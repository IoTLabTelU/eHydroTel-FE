import 'package:hydro_iot/src/websocket/application/providers/sensor_websocket_provider.dart';
import 'package:hydro_iot/src/websocket/application/state/sensor_websocket_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sensor_websocket_controller.g.dart';

@riverpod
class SensorWebsocketController extends _$SensorWebsocketController {
  @override
  SensorWebsocketState build(String serialNumber) {
    return initAndListen(serialNumber);
  }

  SensorWebsocketState initAndListen(String serialNumber) {
    final repo = ref.watch(sensorWebsocketRepositoryImplProvider(serialNumber));
    final stream = repo.sensorDataStream;

    final sub = stream.listen(
      (entity) {
        state = SensorWebsocketState(isConnected: repo.isListening, sensorData: AsyncData(entity));
      },
      onError: (e, st) {
        state = SensorWebsocketState(isConnected: false, sensorData: AsyncError(e, st));
      },
    );

    ref.onDispose(() {
      sub.cancel();
      repo.dispose();
    });

    return SensorWebsocketState(isConnected: repo.isListening, sensorData: const AsyncLoading());
  }

  void reconnect(String serialNumber) {
    ref.read(sensorWebsocketRepositoryImplProvider(serialNumber)).reconnect(serialNumber);
  }

  void disconnect(String serialNumber) {
    ref.read(sensorWebsocketRepositoryImplProvider(serialNumber)).dispose();
  }
}
