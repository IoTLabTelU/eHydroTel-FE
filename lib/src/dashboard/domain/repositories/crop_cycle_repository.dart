import '../entities/crop_cycle_response.dart';

abstract class CropCycleRepository {
  Future<CropCycleResponse> getCropCycles();
}
