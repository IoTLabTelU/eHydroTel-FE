import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../devices/domain/entities/calibration_progress_entity.dart';

part 'step_advance_socket_event_entity.freezed.dart';
part 'step_advance_socket_event_entity.g.dart';

/// Representasi ringan step di dalam payload Socket.IO — HANYA berisi field
/// yang benar-benar dikirim backend untuk `completed_step`/`next_step` pada
/// event ini ({ index, action, phase, label }). Tidak memakai
/// [CalibrationStepDefEntity] secara langsung karena entity itu punya field
/// wajib `requiresSoak` yang TIDAK ADA di payload socket — kalau dipakai
/// langsung, parsing akan selalu gagal.
@freezed
sealed class CalibrationStepRefEntity with _$CalibrationStepRefEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CalibrationStepRefEntity({required int index, required String action, required String phase, required String label}) =
      _CalibrationStepRefEntity;

  factory CalibrationStepRefEntity.fromJson(Map<String, dynamic> json) => _$CalibrationStepRefEntityFromJson(json);
}

/// Shape ini KHUSUS untuk payload event Socket.IO `calibration:${serial}:step_advance`.
///
/// Sengaja dipisah dari `StepAdvanceResultEntity` (yang merepresentasikan
/// response REST POST /:serial/complete-step) karena dua-duanya punya
/// bentuk JSON yang berbeda meski sama-sama "step advance":
///
/// REST  /complete-step → { session, next_step, is_final }
/// Socket step_advance  → { session_id, completed_step, next_step, progress }
///
/// Memakai entity yang sama untuk keduanya akan membuat parsing salah satu
/// dari dua sumber tersebut selalu gagal (field wajib yang tidak ada di JSON).
@freezed
sealed class StepAdvanceSocketEventEntity with _$StepAdvanceSocketEventEntity {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory StepAdvanceSocketEventEntity({
    required String sessionId,
    required CalibrationStepRefEntity completedStep,
    CalibrationStepRefEntity? nextStep,
    required CalibrationProgressEntity progress,
  }) = _StepAdvanceSocketEventEntity;

  const StepAdvanceSocketEventEntity._();

  /// Tidak ada `next_step` berarti ini adalah event untuk langkah terakhir
  /// (calctds) — kalibrasi penuh selesai.
  bool get isFinal => nextStep == null;

  factory StepAdvanceSocketEventEntity.fromJson(Map<String, dynamic> json) => _$StepAdvanceSocketEventEntityFromJson(json);
}
