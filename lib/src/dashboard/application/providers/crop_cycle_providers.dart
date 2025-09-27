import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hydro_iot/core/providers/provider.dart';
import '../../data/datasources/crop_cycle_api_service.dart';
import '../../data/repositories/crop_cycle_repository_impl.dart';
import '../../domain/repositories/crop_cycle_repository.dart';
import '../../domain/usecases/get_crop_cycles_usecase.dart';
import '../../domain/usecases/search_crop_cycles_usecase.dart';
import '../notifiers/crop_cycle_notifier.dart';
import '../notifiers/search_crop_cycle_notifier.dart';
import '../state/crop_cycle_state.dart';

// API Service Provider
final cropCycleApiServiceProvider = Provider<CropCycleApiService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return CropCycleApiService(apiClient: apiClient);
});

// Repository Provider
final cropCycleRepositoryProvider = Provider<CropCycleRepository>((ref) {
  final apiService = ref.read(cropCycleApiServiceProvider);
  return CropCycleRepositoryImpl(apiService);
});

// Usecase Provider
final getCropCyclesUsecaseProvider = Provider<GetCropCyclesUsecase>((ref) {
  final repository = ref.read(cropCycleRepositoryProvider);
  return GetCropCyclesUsecase(repository);
});

// Notifier Provider
final cropCycleNotifierProvider = StateNotifierProvider<CropCycleNotifier, CropCycleState>((ref) {
  final usecase = ref.read(getCropCyclesUsecaseProvider);
  return CropCycleNotifier(usecase);
});

// Search Usecase Provider
final searchCropCyclesUsecaseProvider = Provider<SearchCropCyclesUsecase>((ref) {
  final repository = ref.read(cropCycleRepositoryProvider);
  return SearchCropCyclesUsecase(repository);
});

// Search Notifier Provider
final searchCropCycleNotifierProvider = StateNotifierProvider<SearchCropCycleNotifier, CropCycleState>((ref) {
  final usecase = ref.read(searchCropCyclesUsecaseProvider);
  return SearchCropCycleNotifier(usecase);
});
