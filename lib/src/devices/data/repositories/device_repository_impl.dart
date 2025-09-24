import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/data/models/register_my_device_request.dart';
import 'package:hydro_iot/src/devices/domain/entities/device_entity.dart';

import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final ApiClient api;

  DeviceRepositoryImpl(this.api);

  @override
  Future<Responses<bool>> registerDevice({
    required String name,
    required String description,
    required String serialNumber,
  }) async {
    final request = RegisterMyDeviceRequest(name: name, description: description, serialNumber: serialNumber);
    return api.post<bool>(
      Params<bool>(
        path: EndpointStrings.registerMyDevice,
        fromJson: (json) => json['success'] as bool,
        body: request.toJson(),
      ),
    );
  }

  @override
  Future<Responses<List<DeviceEntity>>> getMyDevices() {
    return api.get<List<DeviceEntity>>(
      Params<List<DeviceEntity>>(
        path: EndpointStrings.getMyDevices,
        fromJson: (json) => (json['data'] as List).map((item) => DeviceEntity.fromJson(item)).toList(),
      ),
    );
  }

  @override
  Future<Responses<DeviceEntity>> getDeviceDetails(String deviceId) {
    return api.get<DeviceEntity>(
      Params<DeviceEntity>(
        path: '${EndpointStrings.devices}/$deviceId',
        fromJson: (json) => DeviceEntity.fromJson(json['data']),
      ),
    );
  }
}
