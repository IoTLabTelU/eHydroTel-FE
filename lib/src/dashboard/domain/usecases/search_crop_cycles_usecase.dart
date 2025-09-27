import '../entities/crop_cycle_response.dart';
import '../repositories/crop_cycle_repository.dart';

class SearchCropCyclesUsecase {
  final CropCycleRepository repository;

  SearchCropCyclesUsecase(this.repository);

  Future<CropCycleResponse> call(String query) async {
    return await repository.searchCropCycles(query);
  }
}
