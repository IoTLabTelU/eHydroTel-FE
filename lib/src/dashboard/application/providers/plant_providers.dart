import 'package:hydro_iot/core/providers/provider.dart';
import 'package:hydro_iot/src/dashboard/data/datasources/plant_api_service.dart';
import 'package:hydro_iot/src/dashboard/data/repositories/plant_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plant_providers.g.dart';

@riverpod
PlantApiService plantApiService(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PlantApiService(apiClient: apiClient);
}

@riverpod
PlantRepositoryImpl plantRepository(Ref ref) {
  final apiService = ref.watch(plantApiServiceProvider);
  return PlantRepositoryImpl(apiService);
}
