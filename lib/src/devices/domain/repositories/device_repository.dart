import '../entities/device.dart';

abstract class DeviceRepository {
  Future<Device> registerDevice({
    required String name,
    required String description,
    required String serialNumber,
  });
}
