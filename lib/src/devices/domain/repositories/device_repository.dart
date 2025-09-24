import 'package:hydro_iot/core/api/api.dart';

import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<Responses<List<DeviceEntity>>> getMyDevices();
  Future<Responses<DeviceEntity>> getDeviceDetails(String deviceId);
  Future<Responses<bool>> registerDevice({required String name, required String description, required String serialNumber});
}
