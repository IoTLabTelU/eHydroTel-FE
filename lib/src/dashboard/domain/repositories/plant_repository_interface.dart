import 'package:hydro_iot/src/dashboard/domain/entities/plant_entity.dart';

abstract class PlantRepositoryInterface {
  Future<List<PlantEntity>> getAllPlants();
}
