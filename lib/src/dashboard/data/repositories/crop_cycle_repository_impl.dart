import '../../domain/entities/crop_cycle_response.dart';
import '../../domain/repositories/crop_cycle_repository.dart';
import '../datasources/crop_cycle_api_service.dart';

class CropCycleRepositoryImpl implements CropCycleRepository {
  final CropCycleApiService apiService;

  CropCycleRepositoryImpl(this.apiService);

  @override
  Future<CropCycleResponse> getCropCycles() async {
    try {
      final response = await apiService.getCropCycles();
      return response;
    } catch (e) {
      throw Exception('Failed to get crop cycles: $e');
    }
  }
}
