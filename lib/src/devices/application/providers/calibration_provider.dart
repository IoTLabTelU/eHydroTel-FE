import 'package:hydro_iot/core/providers/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/calibration_repository_impl.dart';

part 'calibration_provider.g.dart';

@riverpod
CalibrationRepositoryImpl calibrationRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return CalibrationRepositoryImpl(client);
}
