import '../../domain/entities/plant_entity.dart';

class PlantModel extends PlantEntity {
  PlantModel({
    required super.id,
    required super.name,
    super.phMin,
    super.phMax,
    super.ppmMin,
    super.ppmMax,
    super.imageUrl,
  });

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(
      id: json['id'],
      name: json['name'],
      phMin: json['ph_min']?.toDouble(),
      phMax: json['ph_max']?.toDouble(),
      ppmMin: json['ppm_min']?.toDouble(),
      ppmMax: json['ppm_max']?.toDouble(),
      imageUrl: json['image_url'],
    );
  }
}
