import '../../../devices/domain/entities/calibration_timer_entity.dart';
import '../../../devices/domain/entities/step_advance_result_entity.dart';

abstract class CalibrationWebsocketRepository {
  void joinRoom(String serial);
  void leaveRoom(String serial);

  /// Stream timer_start event → emit CalibrationTimer
  Stream<CalibrationTimerEntity> get onTimerStart;

  /// Stream step_advance event → emit StepAdvanceResult
  Stream<StepAdvanceResultEntity> get onStepAdvance;

  /// Stream reconnect event (no payload, trigger resync)
  Stream<void> get onReconnect;

  void dispose();
}
