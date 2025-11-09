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
    final repo = ref.read(sensorWebsocketRepositoryImplProvider);
    repo.init(serialNumber);

    ref.listen(sensorWebsocketRepositoryImplProvider, (prev, next) {
      if (prev != next) {
        next.init(serialNumber);
      }
    });

    // gunakan .listen agar setiap ada data baru, state berubah
    final sub = repo.sensorDataStream.listen(
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

    // Initial state
    return SensorWebsocketState(isConnected: repo.isListening, sensorData: const AsyncLoading());
  }

  void reconnect(String serialNumber) {
    ref.read(sensorWebsocketRepositoryImplProvider).reconnect(serialNumber);
  }

  void disconnect() {
    ref.read(sensorWebsocketRepositoryImplProvider).dispose();
  }
}
