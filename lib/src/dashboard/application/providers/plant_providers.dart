import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/dashboard/domain/usecases/get_plant_usecase.dart';

import '../../data/datasources/plant_api.dart';
import '../../data/repositories/plant_repository_impl.dart';
import '../../domain/entities/plant_entity.dart';

///dio provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: BaseConfigs.baseUrl!,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
});

///API provider
final plantApiProvider = Provider<PlantApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PlantApi(dio);
});

///Repository provider
final plantRepositoryProvider = Provider<PlantRepositoryImpl>((ref) {
  final api = ref.watch(plantApiProvider);
  return PlantRepositoryImpl(api);
});

///Usecase provider
final getPlantsUseCaseProvider = Provider<GetPlantsUseCase>((ref) {
  final repo = ref.watch(plantRepositoryProvider);
  return GetPlantsUseCase(repo);
});

// StateNotifier
class PlantNotifier extends StateNotifier<AsyncValue<List<PlantEntity>>> {
  final GetPlantsUseCase getPlantsUseCase;

  PlantNotifier(this.getPlantsUseCase) : super(const AsyncValue.loading()) {
    fetchPlants();
  }

  Future<void> fetchPlants() async {
    try {
      state = const AsyncValue.loading();
      final plants = await getPlantsUseCase();
      state = AsyncValue.data(plants);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Provider buat UI
final plantNotifierProvider =
    StateNotifierProvider<PlantNotifier, AsyncValue<List<PlantEntity>>>((ref) {
      final usecase = ref.watch(getPlantsUseCaseProvider);
      return PlantNotifier(usecase);
    });
