import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_api.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final DeviceApi api;

  DeviceRepositoryImpl(this.api);

  @override
  Future<Device> registerDevice({
    required String name,
    required String description,
    required String serialNumber,
  }) async {
    return await api.registerDevice(
      name: name,
      description: description,
      serialNumber: serialNumber,
    );
  }
}
