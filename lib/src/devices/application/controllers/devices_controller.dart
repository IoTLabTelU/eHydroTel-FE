import 'package:hydro_iot/src/devices/application/providers/device_provider.dart';
import 'package:hydro_iot/src/devices/domain/entities/device_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'devices_controller.g.dart';

@riverpod
class DevicesController extends _$DevicesController {
  @override
  FutureOr<List<DeviceEntity>> build() async {
    return fetchDevices();
  }

  Future<List<DeviceEntity>> fetchDevices() async {
    state = const AsyncValue.loading();

    final res = await ref.read(devicesRepositoryProvider).getMyDevices();

    if (!res.isSuccess) {
      state = AsyncValue.error(res.message ?? 'Failed to fetch devices', StackTrace.current);
      return [];
    }
    if (res.data == null) {
      state = const AsyncValue.data([]);
      return [];
    }
    state = AsyncValue.data(res.data!);
    return res.data!;
  }

  Future<void> registerDevice({required String name, required String description, required String serialNumber}) async {
    state = const AsyncValue.loading();
    final res = await ref
        .read(devicesRepositoryProvider)
        .registerDevice(name: name, description: description, serialNumber: serialNumber);

    if (!res.isSuccess) {
      state = AsyncValue.error(res.message ?? 'Failed to register device', StackTrace.current);
      return;
    }

    // Refresh the devices list after successful registration
    await fetchDevices();
  }

  Future<DeviceEntity?> getDeviceDetails(String deviceId) async {
    state = const AsyncValue.loading();
    final res = await ref.read(devicesRepositoryProvider).getDeviceDetails(deviceId);

    if (!res.isSuccess) {
      state = AsyncValue.error(res.message ?? 'Failed to fetch device details', StackTrace.current);
      return null;
    }
    return res.data;
  }
}
