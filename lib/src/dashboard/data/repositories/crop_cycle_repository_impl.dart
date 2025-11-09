import 'package:hydro_iot/src/dashboard/data/models/edit_session_data.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';

import '../../domain/entities/crop_cycle_response.dart';
import '../../domain/repositories/crop_cycle_repository.dart';
import '../datasources/crop_cycle_api_service.dart';

class CropCycleRepositoryImpl implements CropCycleRepository {
  final CropCycleApiService apiService;

  CropCycleRepositoryImpl(this.apiService);

  @override
  Future<CropCycleResponse> getCropCyclesForDashboard(String status, bool active) async {
    final response = await apiService.getCropCyclesForDashboard(status, active);
    return response.data!;
  }

  @override
  Future<CropCycleResponse> getCropCyclesForDevices(String deviceId) async {
    final response = await apiService.getCropCyclesForDevices(deviceId);
    return response.data!;
  }

  @override
  Future<CropCycleResponse> searchCropCycles(String query) async {
    final response = await apiService.searchCropCycles(query);
    return response.data!;
  }

  @override
  Future<bool> addCropCycle(SessionData cropCycleData) async {
    final response = await apiService.addCropCycle(cropCycleData);
    return response.isSuccess;
  }

  @override
  Future<bool> deleteCropCycle(String id) async {
    final response = await apiService.deleteCropCycle(id);
    return response.isSuccess;
  }

  @override
  Future<bool> endCropCycle(String id) async {
    final response = await apiService.endCropCycle(id);
    return response.isSuccess;
  }

  @override
  Future<bool> updateCropCycle(String id, EditSessionData cropCycleData) async {
    final response = await apiService.updateCropCycle(id, cropCycleData);
    return response.isSuccess;
  }
}
