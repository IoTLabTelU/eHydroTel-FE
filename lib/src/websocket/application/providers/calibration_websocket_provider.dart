import 'package:hydro_iot/core/providers/websocket_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/calibration_websocket_repository_impl.dart';

part 'calibration_websocket_provider.g.dart';

@riverpod
CalibrationWebsocketRepositoryImpl calibrationWebsocketRepositoryImpl(Ref ref) {
  final websocket = ref.watch(calibrationWebsocketProvider);
  final calibrationWebsocketRepository = CalibrationWebsocketRepositoryImpl(websocket);
  ref.onDispose(() {
    calibrationWebsocketRepository.dispose();
    ref.invalidate(calibrationWebsocketProvider);
  });
  return calibrationWebsocketRepository;
}
