import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';

import '../entities/crop_cycle_response.dart';

abstract class CropCycleRepository {
  Future<CropCycleResponse> getCropCyclesForDashboard();
  Future<CropCycleResponse> getCropCyclesForDevices(String deviceId);
  Future<bool> addCropCycle(SessionData cropCycleData);
  Future<bool> updateCropCycle(String id, SessionData cropCycleData);
  Future<bool> deleteCropCycle(String id);
  Future<bool> endCropCycle(String id);
}
