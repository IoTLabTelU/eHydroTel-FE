import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../websocket/application/providers/calibration_websocket_provider.dart';
import '../providers/calibration_provider.dart';
import '../states/calibration_state.dart';

part 'calibration_controller.g.dart';

@riverpod
class CalibrationController extends _$CalibrationController {
  @override
  CalibrationState build(String serial) => const CalibrationState();

  Future<void> init(String serial) async {
    state = state.copyWith(phase: CalibrationPhase.loading);
    try {
      final steps = await ref.read(calibrationRepositoryProvider).getSteps();
      final session = await ref.read(calibrationRepositoryProvider).getActiveSession(serial);
      ref.read(calibrationWebsocketRepositoryImplProvider).joinRoom(serial);
      _listenSocket(serial);

      if (session == null) {
        // belum ada sesi aktif → mulai sesi baru otomatis, atau munculkan
        // tombol "Mulai Kalibrasi" di luar screen ini (tergantung desain kamu)
        final newSession = await ref.read(calibrationRepositoryProvider).startSession(serial);
        state = state.copyWith(phase: CalibrationPhase.loading, session: newSession, allSteps: steps);
        await _syncEstimate(serial);
        state = state.copyWith(phase: CalibrationPhase.idle);
        return;
      }

      // RECONNECT: ada sesi aktif, cek apakah ada timer berjalan
      state = state.copyWith(allSteps: steps, session: session.session, progress: session.progress);

      if (session.timer != null && session.timer!.remainingSec! > 0) {
        state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: session.timer);
      } else if (session.timer != null && session.timer!.remainingSec == 0) {
        state = state.copyWith(phase: CalibrationPhase.readyToComplete);
      } else {
        await _syncEstimate(serial);
        state = state.copyWith(phase: CalibrationPhase.idle);
      }
    } catch (e) {
      state = state.copyWith(phase: CalibrationPhase.error, error: e);
    }
  }

  Future<void> _syncEstimate(String serial) async {
    final step = state.currentStepDef;
    if (step == null || !step.requiresSoak) {
      state = state.copyWith(currentStepEstimateMin: null);
      return;
    }
    // GET /estimate-time/:step  →  { duration_min }
    final min = await ref.read(calibrationRepositoryProvider).getStepEstimateMin(step.action);
    state = state.copyWith(currentStepEstimateMin: min);
  }

  Future<void> beginSoak(String serial) async {
    state = state.copyWith(isActionLoading: true);
    try {
      final timer = await ref.read(calibrationRepositoryProvider).startSoak(serial); // POST /:serial/soak
      state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: timer, isActionLoading: false);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, phase: CalibrationPhase.error, error: e);
    }
  }

  Future<void> completeCurrentStep(String serial) async {
    state = state.copyWith(isActionLoading: true);
    try {
      final result = await ref.read(calibrationRepositoryProvider).completeStep(serial); // POST /:serial/complete-step
      if (result.isFinal) {
        state = state.copyWith(phase: CalibrationPhase.done, isActionLoading: false);
        return;
      }
      // Update session.currentStepIndex secara lokal, lalu kembali ke idle utk step baru
      final updatedSession = state.session!.copyWithNextStep(result.nextStep!);
      state = state.copyWith(
        session: updatedSession,
        progress: updatedSession.progress,
        phase: CalibrationPhase.idle,
        activeTimer: null,
        isActionLoading: false,
      );
      await _syncEstimate(serial);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, phase: CalibrationPhase.error, error: e);
    }
  }

  /// Dipanggil utk step tanpa soak (calc/calctds) ATAU saat user tap
  /// "Apply X Calibration" di akhir tipe (state readyToComplete + isLastOfType).
  /// Keduanya sama-sama hit /complete-step di backend — bedanya hanya UI
  /// menampilkan ApplyCalibrationSheet sesudahnya.
  Future<void> applyStep(String serial) async {
    state = state.copyWith(isActionLoading: true);
    try {
      final result = await ref.read(calibrationRepositoryProvider).completeStep(serial); // POST /:serial/complete-step
      state = state.copyWith(isActionLoading: false);

      if (result.isFinal) {
        state = state.copyWith(phase: CalibrationPhase.done);
        return;
      }

      // Munculkan bottom sheet "X Calibration Applied" di luar sini —
      // screen yang listen state berubah ke `applying` lalu trigger ApplyCalibrationSheet.show(...)
      final updatedSession = state.session!.copyWithNextStep(result.nextStep!);
      state = state.copyWith(phase: CalibrationPhase.applying, session: updatedSession, progress: updatedSession.progress);
    } catch (e) {
      state = state.copyWith(isActionLoading: false, phase: CalibrationPhase.error, error: e);
    }
  }

  /// Dipanggil dari tombol "Continue to X" di dalam ApplyCalibrationSheet
  Future<void> confirmAppliedAndContinue(String serial) async {
    state = state.copyWith(phase: CalibrationPhase.idle, activeTimer: null);
    await _syncEstimate(serial);
  }

  Future<void> cancel(String serial) async {
    try {
      await ref.read(calibrationRepositoryProvider).cancelSession(serial); // POST /:serial/cancel
      state = state.copyWith(phase: CalibrationPhase.cancelled);
    } catch (e) {
      state = state.copyWith(phase: CalibrationPhase.error, error: e);
    }
  }

  void leaveRoom(String serial) => ref.read(calibrationWebsocketRepositoryImplProvider).leaveRoom(serial);

  void _listenSocket(String serial) {
    ref.read(calibrationWebsocketRepositoryImplProvider).onTimerStart.listen((timer) {
      state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: timer);
    });

    ref.read(calibrationWebsocketRepositoryImplProvider).onStepAdvance.listen((result) {
      // Sinkronisasi jika event datang dari device lain / tab lain
      if (result.isFinal) {
        state = state.copyWith(phase: CalibrationPhase.done);
        return;
      }
      state = state.copyWith(progress: result.progress, phase: CalibrationPhase.idle, activeTimer: null);
    });

    ref.read(calibrationWebsocketRepositoryImplProvider).onReconnect.listen((_) async {
      // PENTING: wajib resync — lihat best practice no. 4 di dokumen
      final session = await ref.read(calibrationRepositoryProvider).getActiveSession(serial);
      if (session?.timer != null && session!.timer!.remainingSec! > 0) {
        state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: session.timer, session: session.session, progress: session.progress);
      } else if (session != null) {
        state = state.copyWith(phase: CalibrationPhase.readyToComplete, session: session.session, progress: session.progress);
      }
    });
  }
}
