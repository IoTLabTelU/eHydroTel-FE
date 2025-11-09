import '../entities/crop_cycle_response.dart';
import '../repositories/crop_cycle_repository.dart';

class GetCropCyclesUsecase {
  final CropCycleRepository repository;

  GetCropCyclesUsecase(this.repository);

  Future<CropCycleResponse> call(String status, bool active) async {
    return await repository.getCropCyclesForDashboard(status, active);
  }
}
