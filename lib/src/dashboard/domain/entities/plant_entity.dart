class PlantEntity {
  final String id;
  final String name;
  final double? phMin;
  final double? phMax;
  final double? ppmMin;
  final double? ppmMax;
  final String? imageUrl;

  PlantEntity({
    required this.id,
    required this.name,
    this.phMin,
    this.phMax,
    this.ppmMin,
    this.ppmMax,
    this.imageUrl,
  });
}
