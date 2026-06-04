import '../../domain/repositories/crop_cycle_repository.dart';
import '../entities/crop_cycle_response.dart';

class GetCropCyclesUsecase {
  final CropCycleRepository repository;

  GetCropCyclesUsecase(this.repository);

  Future<CropCycleResponse> call(String status, bool active, {int page = 1, int limit = 10}) async {
    final response = await repository.getCropCyclesForDashboard(status, active, page: page, limit: limit);

    if (!response.success) {
      throw Exception(response.message);
    }

    return response;
  }
}
