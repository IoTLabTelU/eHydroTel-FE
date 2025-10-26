import 'package:hydro_iot/src/dashboard/data/models/edit_session_data.dart';
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
  Future<CropCycleResponse> searchCropCycles(String query) async {
    try {
      final response = await apiService.searchCropCycles(query);
      return response.data!;
    } catch (e) {
      throw Exception('Failed to search crop cycles: $e');
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
  Future<bool> deleteCropCycle(String id) async {
    try {
      final response = await apiService.deleteCropCycle(id);
      return response.isSuccess;
    } catch (e) {
      throw Exception('Failed to delete crop cycle: $e');
    }
  }

  @override
  Future<bool> endCropCycle(String id) async {
    try {
      final response = await apiService.endCropCycle(id);
      return response.isSuccess;
    } catch (e) {
      throw Exception('Failed to end crop cycle: $e');
    }
  }

  @override
  Future<bool> updateCropCycle(String id, EditSessionData cropCycleData) async {
    try {
      final response = await apiService.updateCropCycle(id, cropCycleData);
      return response.isSuccess;
    } catch (e) {
      throw Exception('Failed to update crop cycle: $e');
    }
  }
}
