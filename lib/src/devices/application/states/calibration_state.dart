import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/calibration_progress_entity.dart';
import '../../domain/entities/calibration_session_entity.dart';
import '../../domain/entities/calibration_step_def_entity.dart';
import '../../domain/entities/calibration_timer_entity.dart';

part 'calibration_state.freezed.dart';

enum CalibrationPhase { loading, idle, soaking, readyToComplete, applying, done, error, cancelled }

@freezed
sealed class CalibrationState with _$CalibrationState {
  const CalibrationState._();

  const factory CalibrationState({
    @Default(CalibrationPhase.loading) CalibrationPhase phase,

    CalibrationSessionEntity? session,

    @Default([]) List<CalibrationStepDefEntity> allSteps,

    CalibrationTimerEntity? activeTimer,

    CalibrationProgressEntity? progress,

    Object? error,

    @Default(false) bool isActionLoading,

    int? currentStepEstimateMin,
  }) = _CalibrationState;

  // ──────────────────────────────────────────────────────────────
  // Helper Getters
  // ──────────────────────────────────────────────────────────────

  CalibrationStepDefEntity? get currentStepDef {
    final currentSession = session;
    if (currentSession == null) return null;

    for (final step in allSteps) {
      if (step.action == currentSession.currentStep) {
        return step;
      }
    }

    return null;
  }

  CalibrationStepDefEntity? get nextStepDef {
    final idx = session?.currentStepIndex ?? -1;

    for (final step in allSteps) {
      if (step.index == idx + 1) {
        return step;
      }
    }

    return null;
  }

  bool get isLastStep => nextStepDef == null;

  bool get isLastOfType {
    final current = currentStepDef;
    final next = nextStepDef;

    if (current == null) return false;
    if (next == null) return true;

    return next.phase != current.phase;
  }

  String? get nextStepShortLabel {
    final next = nextStepDef;

    if (next == null) return null;

    switch (next.action) {
      case 'cal7':
        return 'pH 7';

      case 'cal4':
        return 'pH 4';

      case 'calc':
        return 'Save pH';

      case 'cal500':
        return 'PPM 500';

      case 'cal1000':
        return 'PPM 1000';

      case 'cal1382':
        return 'PPM 1382';

      case 'calctds':
        return 'Save TDS';

      default:
        return next.label;
    }
  }
}
