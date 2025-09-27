import 'package:hydro_iot/src/dashboard/application/providers/plant_providers.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/plant_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plant_controller.g.dart';

@riverpod
class PlantController extends _$PlantController {
  @override
  FutureOr<List<PlantEntity>> build() async {
    return fetchPlantTypes();
  }

  Future<List<PlantEntity>> fetchPlantTypes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final plantResponse = await ref.read(plantRepositoryProvider).getAllPlants();
      return plantResponse;
    });
    return state.value ?? [];
  }
}
