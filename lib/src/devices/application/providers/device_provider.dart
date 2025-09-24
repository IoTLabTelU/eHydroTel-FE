import 'package:hydro_iot/core/providers/provider.dart';
import 'package:hydro_iot/src/devices/data/repositories/device_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_provider.g.dart';

@riverpod
DeviceRepositoryImpl devicesRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return DeviceRepositoryImpl(client);
}
