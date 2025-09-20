import '../../domain/entities/device.dart';
import '../../domain/repositories/device_repository.dart';

class RegisterDeviceUseCase {
  final DeviceRepository repo;

  RegisterDeviceUseCase(this.repo);

  Future<Device> call({
    required String name,
    required String description,
    required String serialNumber,
  }) {
    return repo.registerDevice(
      name: name,
      description: description,
      serialNumber: serialNumber,
    );
  }
}
