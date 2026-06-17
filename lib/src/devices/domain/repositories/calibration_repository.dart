import '../../data/models/active_calibration_session_model.dart';
import '../entities/calibration_session_entity.dart';
import '../entities/calibration_step_def_entity.dart';
import '../entities/calibration_timer_entity.dart';
import '../entities/step_advance_result_entity.dart';

abstract class CalibrationRepository {
  /// GET /steps — definisi semua step (panggil sekali, cache)
  Future<List<CalibrationStepDefEntity>> getSteps();

  /// GET /:serial/session — untuk initial load & reconnect sync
  /// return null jika tidak ada sesi aktif
  Future<ActiveCalibrationSessionModel?> getActiveSession(String serial);

  /// POST /:serial/start
  Future<CalibrationSessionEntity> startSession(String serial);

  /// POST /:serial/soak — mulai soak timer utk step berikutnya
  Future<CalibrationTimerEntity> startSoak(String serial);

  /// POST /:serial/complete-step
  Future<StepAdvanceResultEntity> completeStep(String serial);

  /// POST /:serial/cancel
  Future<bool> cancelSession(String serial);

  /// GET /estimate-time — total estimasi waktu (untuk ditampilkan di awal)
  Future<int> getEstimatedTotalSec();

  Future<int> getStepEstimateMin(String action);
}
