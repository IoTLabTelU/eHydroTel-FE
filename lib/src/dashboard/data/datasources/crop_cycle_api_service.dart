import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';
import '../models/crop_cycle_response_model.dart';

class CropCycleApiService {
  final ApiClient apiClient;

  CropCycleApiService({required this.apiClient});

  // Future<CropCycleResponseModel> getCropCycles() async {
  //   final url = '${BaseConfigs.baseUrl}/api/crop-cycle';

  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //       'Content-Type': 'application/json',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     return CropCycleResponseModel.fromJson(jsonData);
  //   } else {
  //     throw Exception('Failed to fetch crop cycles: ${response.statusCode}');
  //   }
  // }

  Future<Responses<CropCycleResponseModel>> getCropCyclesForDashboard() async {
    return await apiClient.get<CropCycleResponseModel>(
      Params<CropCycleResponseModel>(
        path: EndpointStrings.cropcycleByUser,
        fromJson: (json) => CropCycleResponseModel.fromJson(json),
      ),
    );
  }

  Future<Responses<CropCycleResponseModel>> getCropCyclesForDevices(
    String deviceId,
  ) async {
    return await apiClient.get<CropCycleResponseModel>(
      Params<CropCycleResponseModel>(
        path: '${EndpointStrings.cropcycleByDevice}/$deviceId',
        fromJson: (json) => CropCycleResponseModel.fromJson(json),
      ),
    );
  }

  Future<Responses<bool>> addCropCycle(SessionData sessionData) async {
    return await apiClient.post<bool>(
      Params<bool>(
        path: EndpointStrings.cropcycle,
        fromJson: (json) => json as bool,
        body: sessionData.toJson(),
      ),
    );
  }

  Future<Responses<CropCycleResponseModel>> searchCropCycles(String query) async {
    return await apiClient.get<CropCycleResponseModel>(
      Params<CropCycleResponseModel>(
        path: '${EndpointStrings.cropcycle}?q=$query',
        fromJson: (json) => CropCycleResponseModel.fromJson(json),
      ),
    );
  }
}
