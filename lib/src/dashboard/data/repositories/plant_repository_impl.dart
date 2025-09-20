import '../../domain/entities/plant_entity.dart';
import '../../domain/repositories/plant_repository.dart';
import '../datasources/plant_api.dart';

class PlantRepositoryImpl implements PlantRepository {
  final PlantApi api;
  PlantRepositoryImpl(this.api);

  @override
  Future<List<PlantEntity>> getPlants() async {
    return await api.getPlants();
  }
}
