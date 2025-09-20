import '../entities/plant_entity.dart';

abstract class PlantRepository {
  Future<List<PlantEntity>> getPlants();
}
