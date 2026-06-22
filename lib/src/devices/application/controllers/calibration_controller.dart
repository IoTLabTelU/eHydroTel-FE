import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/calibration_progress_entity.dart';
import '../../domain/entities/calibration_session_entity.dart';
import '../../domain/entities/calibration_step_def_entity.dart';
import '../../../websocket/application/providers/calibration_websocket_provider.dart';
import '../providers/calibration_provider.dart';
import '../states/calibration_state.dart';

part 'calibration_controller.g.dart';

@riverpod
class CalibrationController extends _$CalibrationController {
  @override
  CalibrationState build(String serial) {
    // Watch (bukan read) di sini sengaja, supaya Riverpod menahan instance
    // websocket repository ini hidup selama controller masih dipakai —
    // mencegah dispose/recreate berulang setiap kali method lain di bawah
    // memanggil ref.read(calibrationWebsocketRepositoryImplProvider).
    ref.watch(calibrationWebsocketRepositoryImplProvider);
    return const CalibrationState();
  }

  Future<void> init(String serial) async {
    state = state.copyWith(phase: CalibrationPhase.loading);
    try {
      final steps = await ref.read(calibrationRepositoryProvider).getSteps();
      final session = await ref.read(calibrationRepositoryProvider).getActiveSession(serial);
      ref.read(calibrationWebsocketRepositoryImplProvider).joinRoom(serial);
      _listenSocket(serial);

      // Set allSteps dulu sebelum apapun, karena _advanceToDisplayStep
      // butuh allSteps untuk mencari step berikutnya.
      state = state.copyWith(allSteps: steps);

      if (session == null) {
        // Belum ada sesi aktif → mulai sesi baru. /start otomatis
        // mengeksekusi 'enter_cal', sehingga session.currentStep yang
        // dikembalikan backend = 'enter_cal' (BUKAN step yang harus
        // ditampilkan ke user). Majukan secara lokal ke step pertama
        // yang benar-benar butuh aksi user (biasanya cal7).
        final newSession = await ref.read(calibrationRepositoryProvider).startSession(serial);
        state = state.copyWith(session: _advanceToDisplayStep(newSession));
        await _syncEstimate(serial);
        state = state.copyWith(phase: CalibrationPhase.idle);
        return;
      }

      // RECONNECT: ada sesi aktif. session.session.currentStep di sini
      // juga masih merujuk ke step yang TERAKHIR dieksekusi backend, jadi
      // tetap perlu dimajukan ke step yang harus ditampilkan — caranya
      // sama persis dengan kasus fresh-start di atas.
      final displaySession = _advanceToDisplayStep(session.session);
      state = state.copyWith(session: displaySession, progress: session.progress);

      final remaining = session.timer?.remainingSec ?? 0;
      if (session.timer != null && remaining > 0) {
        state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: session.timer);
      } else if (session.timer != null && remaining == 0) {
        state = state.copyWith(phase: CalibrationPhase.readyToComplete);
      } else {
        await _syncEstimate(serial);
        state = state.copyWith(phase: CalibrationPhase.idle);
      }
    } catch (e) {
      state = state.copyWith(phase: CalibrationPhase.error, error: e);
    }
  }

  /// `rawSession.currentStep` selalu menunjuk ke step yang BARU SAJA
  /// dieksekusi backend. UI butuh tahu step BERIKUTNYA yang harus
  /// dikerjakan user — itu selalu ada di index (currentStepIndex + 1)
  /// pada `allSteps`. Helper ini memajukan session secara lokal supaya
  /// `state.currentStepDef` selalu konsisten dengan apa yang harus
  /// ditampilkan, di SEMUA jalur (fresh start, reconnect, complete-step,
  /// socket step_advance).
  CalibrationSessionEntity _advanceToDisplayStep(CalibrationSessionEntity rawSession) {
    final targetIndex = rawSession.currentStepIndex + 1;
    for (final step in state.allSteps) {
      if (step.index == targetIndex) {
        return rawSession.copyWithNextStep(step);
      }
    }
    // Tidak ketemu step berikutnya (sudah di langkah terakhir) — biarkan apa adanya.
    return rawSession;
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
      // Majukan tampilan ke step berikutnya. progress dihitung dari
      // current_step_index (yang baru saja dieksekusi, sebelum dimajukan)
      // + 1, sesuai semantik `progress.current` pada dokumen.
      final newProgress = CalibrationProgressEntity(current: result.session.currentStepIndex + 1, total: state.allSteps.length);
      final updatedSession = result.session.copyWithNextStep(result.nextStep!);
      state = state.copyWith(session: updatedSession, progress: newProgress, phase: CalibrationPhase.idle, activeTimer: null, isActionLoading: false);
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
      final newProgress = CalibrationProgressEntity(current: result.session.currentStepIndex + 1, total: state.allSteps.length);
      final updatedSession = result.session.copyWithNextStep(result.nextStep!);
      state = state.copyWith(phase: CalibrationPhase.applying, session: updatedSession, progress: newProgress);
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

  Future<void> onSoakCompleted(String serial) async {
    // Guard: hanya jalankan jika masih di fase soaking
    if (state.phase != CalibrationPhase.soaking) return;

    state = state.copyWith(phase: CalibrationPhase.readyToComplete);
  }

  void leaveRoom(String serial) => ref.read(calibrationWebsocketRepositoryImplProvider).leaveRoom(serial);

  void _listenSocket(String serial) {
    ref.read(calibrationWebsocketRepositoryImplProvider).onTimerStart.listen((timer) {
      state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: timer);
    });

    ref.read(calibrationWebsocketRepositoryImplProvider).onStepAdvance.listen((event) {
      // Sinkronisasi jika step diselesaikan dari device/tab lain.
      if (event.isFinal || state.session == null) {
        if (event.isFinal) state = state.copyWith(phase: CalibrationPhase.done);
        return;
      }

      // Payload socket cuma punya step ref ringan (tanpa requiresSoak),
      // jadi cari definisi lengkapnya di allSteps berdasarkan action name
      // sebelum dipakai untuk copyWithNextStep.
      CalibrationStepDefEntity? fullNextStep;
      for (final s in state.allSteps) {
        if (s.action == event.nextStep!.action) {
          fullNextStep = s;
          break;
        }
      }
      if (fullNextStep == null) return;

      final updatedSession = state.session!.copyWithNextStep(fullNextStep);
      state = state.copyWith(session: updatedSession, progress: event.progress, phase: CalibrationPhase.idle, activeTimer: null);
    });

    ref.read(calibrationWebsocketRepositoryImplProvider).onReconnect.listen((_) async {
      // PENTING: wajib resync — lihat best practice no. 4 di dokumen
      final session = await ref.read(calibrationRepositoryProvider).getActiveSession(serial);
      if (session == null) return;

      final displaySession = _advanceToDisplayStep(session.session);
      final remaining = session.timer?.remainingSec ?? 0;

      if (session.timer != null && remaining > 0) {
        state = state.copyWith(phase: CalibrationPhase.soaking, activeTimer: session.timer, session: displaySession, progress: session.progress);
      } else {
        state = state.copyWith(phase: CalibrationPhase.readyToComplete, session: displaySession, progress: session.progress);
      }
    });
  }
}
