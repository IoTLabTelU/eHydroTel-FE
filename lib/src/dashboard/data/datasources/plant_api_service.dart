import 'dart:developer';

import 'package:hydro_iot/pkg.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/plant_entity.dart';

class PlantApiService {
  final ApiClient apiClient;
  PlantApiService({required this.apiClient});

  Future<Responses<List<PlantEntity>>> getAllPlants() async {
    return await apiClient
        .get<List<PlantEntity>>(
          Params<List<PlantEntity>>(
            path: EndpointStrings.plants,
            fromJson: (json) => (json['data'] as List).map((e) => PlantEntity.fromJson(e)).toList(),
          ),
        )
        .then((response) {
          if (!response.isSuccess) {
            throw Exception(response.message ?? 'Failed to fetch plant types');
          }
          log('Fetchedddddd plants: ${response.data}');
          return response;
        });
  }
}
