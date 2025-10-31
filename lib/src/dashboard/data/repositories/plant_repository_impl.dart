import 'package:hydro_iot/src/dashboard/data/datasources/plant_api_service.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/plant_entity.dart';
import 'package:hydro_iot/src/dashboard/domain/repositories/plant_repository_interface.dart';

class PlantRepositoryImpl implements PlantRepositoryInterface {
  final PlantApiService apiService;

  PlantRepositoryImpl(this.apiService);
  @override
  Future<List<PlantEntity>> getAllPlants() async {
    final response = await apiService.getAllPlants();
    return response.data!;
  }
}
