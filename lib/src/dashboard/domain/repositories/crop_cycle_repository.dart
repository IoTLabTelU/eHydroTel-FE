import 'package:hydro_iot/src/dashboard/data/models/edit_session_data.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';

import '../entities/crop_cycle_response.dart';

abstract class CropCycleRepository {
  Future<CropCycleResponse> getCropCyclesForDashboard(String status, bool active);
  Future<CropCycleResponse> getCropCyclesForDevices(String deviceId);
  Future<CropCycleResponse> searchCropCycles(String query);
  Future<bool> addCropCycle(SessionData cropCycleData);
  Future<bool> updateCropCycle(String id, EditSessionData cropCycleData);
  Future<bool> deleteCropCycle(String id);
  Future<bool> endCropCycle(String id);
}
