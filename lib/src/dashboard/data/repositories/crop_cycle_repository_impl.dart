import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';

import '../../domain/entities/crop_cycle_response.dart';
import '../../domain/repositories/crop_cycle_repository.dart';
import '../datasources/crop_cycle_api_service.dart';

class CropCycleRepositoryImpl implements CropCycleRepository {
  final CropCycleApiService apiService;

  CropCycleRepositoryImpl(this.apiService);

  @override
  Future<CropCycleResponse> getCropCyclesForDashboard() async {
    try {
      final response = await apiService.getCropCyclesForDashboard();
      return response.data!;
    } catch (e) {
      throw Exception('Failed to get crop cycles: $e');
    }
  }

  @override
  Future<CropCycleResponse> getCropCyclesForDevices(String deviceId) async {
    try {
      final response = await apiService.getCropCyclesForDevices(deviceId);
      return response.data!;
    } catch (e) {
      throw Exception('Failed to get crop cycles: $e');
    }
  }

  @override
  Future<bool> addCropCycle(SessionData cropCycleData) async {
    try {
      final response = await apiService.addCropCycle(cropCycleData);
      return response.isSuccess;
    } catch (e) {
      throw Exception('Failed to add crop cycle: $e');
    }
  }

  @override
  Future<bool> deleteCropCycle(String id) {
    // TODO: implement deleteCropCycle
    throw UnimplementedError();
  }

  @override
  Future<bool> endCropCycle(String id) {
    // TODO: implement endCropCycle
    throw UnimplementedError();
  }

  @override
  Future<bool> updateCropCycle(String id, SessionData cropCycleData) {
    // TODO: implement updateCropCycle
    throw UnimplementedError();
  }
}
