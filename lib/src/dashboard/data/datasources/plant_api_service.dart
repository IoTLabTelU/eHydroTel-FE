import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/res/constant.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/plant_entity.dart';

class PlantApiService {
  final ApiClient apiClient;
  PlantApiService({required this.apiClient});

  Future<Responses<List<PlantEntity>>> getAllPlants() async {
    return await apiClient.get(
      Params<List<PlantEntity>>(
        path: EndpointStrings.plants,
        fromJson: (json) => (json['data'] as List).map((e) => PlantEntity.fromJson(e)).toList(),
      ),
    );
  }
}
