import 'package:dio/dio.dart';
import '../models/plant_model.dart';

class PlantApi {
  final Dio dio;
  PlantApi(this.dio);

  Future<List<PlantModel>> getPlants() async {
    final response = await dio.get('/plants');
    final data = response.data['data'] as List;
    return data.map((e) => PlantModel.fromJson(e)).toList();
  }
}
