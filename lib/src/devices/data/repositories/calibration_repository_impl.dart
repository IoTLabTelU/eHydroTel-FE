import 'package:hydro_iot/pkg.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/calibration_session_entity.dart';
import '../../domain/entities/calibration_step_def_entity.dart';
import '../../domain/entities/calibration_timer_entity.dart';
import '../../domain/entities/step_advance_result_entity.dart';
import '../../domain/repositories/calibration_repository.dart';
import '../models/active_calibration_session_model.dart';

/// Perintah ke endpoint ini menunggu round-trip MQTT ke hardware
/// (perangkat IoT bisa lambat merespons). Dokumen integrasi mewajibkan
/// timeout minimal 45-60 detik, BUKAN default Dio (yang berarti
/// menunggu tanpa batas dan bisa membuat tombol stuck loading selamanya
/// kalau device tidak pernah merespons).
final _mqttCommandOptions = Options(sendTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60));

class CalibrationRepositoryImpl implements CalibrationRepository {
  final ApiClient api;

  CalibrationRepositoryImpl(this.api);
  @override
  Future<bool> cancelSession(String serial) {
    return api
        .post(
          Params(path: '${EndpointStrings.calibration}/$serial/cancel', fromJson: (json) => json['success'] as bool, options: _mqttCommandOptions),
        )
        .then((response) {
          return response.isSuccess;
        });
  }

  @override
  Future<StepAdvanceResultEntity> completeStep(String serial) {
    final response = api.post(
      Params(
        path: '${EndpointStrings.calibration}/$serial/complete-step',
        fromJson: (json) => StepAdvanceResultEntity.fromJson(json['data']),
        options: _mqttCommandOptions,
      ),
    );
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to complete step');
      }
      return res.data!;
    });
  }

  @override
  Future<ActiveCalibrationSessionModel?> getActiveSession(String serial) {
    final response = api.get(
      Params(
        path: '${EndpointStrings.calibration}/$serial/session',
        fromJson: (json) => json['data'] != null ? ActiveCalibrationSessionModel.fromJson(json['data']) : null,
      ),
    );
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to get active session');
      }
      return res.data;
    });
  }

  @override
  Future<int> getEstimatedTotalSec() {
    final response = api.get(Params(path: '${EndpointStrings.calibration}/estimate-time', fromJson: (json) => json['data']['total_soak_sec'] as int));
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to get estimated total time');
      }
      return res.data!;
    });
  }

  @override
  Future<List<CalibrationStepDefEntity>> getSteps() {
    final response = api.get(
      Params(
        path: '${EndpointStrings.calibration}/steps',
        fromJson: (json) => (json['data'] as List).map((e) => CalibrationStepDefEntity.fromJson(e)).toList(),
      ),
    );
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to get steps');
      }
      return res.data!;
    });
  }

  @override
  Future<CalibrationSessionEntity> startSession(String serial) {
    final response = api.post(
      Params(
        path: '${EndpointStrings.calibration}/$serial/start',
        fromJson: (json) => CalibrationSessionEntity.fromJson(json['data']),
        options: _mqttCommandOptions,
      ),
    );
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to start session');
      }
      return res.data!;
    });
  }

  @override
  Future<CalibrationTimerEntity> startSoak(String serial) {
    final response = api.post(
      Params(
        path: '${EndpointStrings.calibration}/$serial/soak',
        fromJson: (json) => CalibrationTimerEntity.fromJson(json['data']),
        options: _mqttCommandOptions,
      ),
    );
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to start soak');
      }
      return res.data!;
    });
  }

  @override
  Future<int> getStepEstimateMin(String action) {
    final response = api.get(
      Params(path: '${EndpointStrings.calibration}/estimate-time/$action', fromJson: (json) => json['data']['duration_min'] as int),
    );
    return response.then((res) {
      if (!res.isSuccess) {
        throw Exception(res.message ?? 'Failed to get step estimate time');
      }
      return res.data!;
    });
  }
}
