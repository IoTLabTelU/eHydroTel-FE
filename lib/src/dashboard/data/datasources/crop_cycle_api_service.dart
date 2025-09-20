import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hydro_iot/core/core.dart';
import '../models/crop_cycle_response_model.dart';

class CropCycleApiService {
  static const String accessToken = '';

  Future<CropCycleResponseModel> getCropCycles() async {
    final url = '${BaseConfigs.baseUrl}/crop-cycles';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CropCycleResponseModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch crop cycles: ${response.statusCode}');
    }
  }
}
