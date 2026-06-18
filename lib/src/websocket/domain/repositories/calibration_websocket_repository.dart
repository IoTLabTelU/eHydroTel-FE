import '../../../devices/domain/entities/calibration_timer_entity.dart';
import '../entities/step_advance_socket_event_entity.dart';

abstract class CalibrationWebsocketRepository {
  void joinRoom(String serial);
  void leaveRoom(String serial);

  /// Stream timer_start event → emit CalibrationTimer
  Stream<CalibrationTimerEntity> get onTimerStart;

  /// Stream step_advance event → payload socket { session_id, completed_step, next_step, progress }
  /// CATATAN: ini BUKAN bentuk yang sama dengan response REST /complete-step.
  Stream<StepAdvanceSocketEventEntity> get onStepAdvance;

  /// Stream reconnect event (no payload, trigger resync)
  Stream<void> get onReconnect;

  void dispose();
}
