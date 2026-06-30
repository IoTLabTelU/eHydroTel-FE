import 'package:hydro_iot/core/providers/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/models/active_calibration_session_model.dart';
import '../../data/repositories/calibration_repository_impl.dart';

part 'calibration_provider.g.dart';

@riverpod
CalibrationRepositoryImpl calibrationRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return CalibrationRepositoryImpl(client);
}

/// GET /estimate-time — dipakai di StartCalibrationScreen untuk menampilkan
/// total estimasi waktu kalibrasi (jangan hardcode angka di UI).
@riverpod
Future<int> calibrationEstimatedTotalMin(Ref ref) async {
  final totalSec = await ref.read(calibrationRepositoryProvider).getEstimatedTotalSec();
  return (totalSec / 60).round();
}

/// GET /:serial/session — dipakai oleh DeviceCard untuk menampilkan progress
/// kalibrasi aktif tanpa join socket room. Provider ini autoDispose sehingga
/// setiap card mengambil session sendiri dan dibuang saat card keluar dari tree.
/// Riverpod akan otomatis re-fetch saat card di-rebuild (misal setelah return
/// dari halaman kalibrasi atau notifikasi masuk + invalidate dipanggil).
@riverpod
Future<ActiveCalibrationSessionModel?> activeCalibrationSession(Ref ref, String serial) async {
  return ref.read(calibrationRepositoryProvider).getActiveSession(serial);
}
