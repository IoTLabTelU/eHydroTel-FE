import 'package:hydro_iot/core/providers/websocket_provider.dart';
import 'package:hydro_iot/src/websocket/data/repositories/sensor_websocket_repository_impl.dart';
import 'package:hydro_iot/src/websocket/domain/entities/sensor_socket_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sensor_websocket_provider.g.dart';

@riverpod
Stream<SensorSocketEntity> sensorWebsocketRepository(Ref ref) {
  final websocket = ref.watch(sensorWebsocketProvider);
  final sensorWebsocketRepository = SensorWebsocketRepositoryImpl(websocket);
  ref.onDispose(() {
    sensorWebsocketRepository.dispose();
    ref.invalidate(sensorWebsocketProvider);
  });
  return sensorWebsocketRepository.sensorDataStream;
}

@riverpod
SensorWebsocketRepositoryImpl sensorWebsocketRepositoryImpl(Ref ref) {
  final websocket = ref.watch(sensorWebsocketProvider);
  final sensorWebsocketRepository = SensorWebsocketRepositoryImpl(websocket);
  ref.onDispose(() {
    sensorWebsocketRepository.dispose();
    ref.invalidate(sensorWebsocketProvider);
  });
  return sensorWebsocketRepository;
}
