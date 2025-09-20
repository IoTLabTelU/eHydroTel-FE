import '../entities/plant_entity.dart';
import '../repositories/plant_repository.dart';

class GetPlantsUseCase {
  final PlantRepository repository;
  GetPlantsUseCase(this.repository);

  Future<List<PlantEntity>> call() async {
    return await repository.getPlants();
  }
}
