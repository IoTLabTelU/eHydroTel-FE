import 'package:hydro_iot/core/api/api.dart';

import '../entities/device_entity.dart';

abstract class DeviceRepository {
  Future<Responses<List<DeviceEntity>>> getMyDevices({int page = 1, int limit = 10});
  Future<Responses<DeviceEntity>> getDeviceDetails(String deviceId);
  Future<Responses<bool>> registerDevice({required String name, required String description, required String serialNumber});
  Future<Responses<bool>> updateDevice({
    required String deviceId,
    required String name,
    required String description,
    String? ssid,
    String? wifiPassword,
  });
  Future<Responses<bool>> deleteDevice(String deviceId);
}
