// import 'package:dio/dio.dart';
// import 'package:hydro_iot/core/config/config.dart';
// import '../models/device_model.dart';

// class DeviceApi {
//   final Dio _dio = Dio();

//   Future<DeviceModel> registerDevice({
//     required String name,
//     required String description,
//     required String serialNumber,
//   }) async {
//     final response = await _dio.post(
//       '${BaseConfigs.baseUrl}/device/register',
//       data: {
//         'name': name,
//         'description': description,
//         'serial_number': serialNumber,
//       },
//     );

//     return DeviceModel.fromJson(response.data['data']);
//   }
// }
