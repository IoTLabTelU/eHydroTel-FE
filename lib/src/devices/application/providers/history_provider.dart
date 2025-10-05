import 'package:hydro_iot/core/providers/provider.dart';
import 'package:hydro_iot/src/devices/data/repositories/history_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_provider.g.dart';

@riverpod
HistoryRepositoryImpl historyRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return HistoryRepositoryImpl(apiClient: client);
}
