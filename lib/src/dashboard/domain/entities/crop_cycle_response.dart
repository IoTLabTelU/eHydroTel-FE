import 'package:hydro_iot/src/dashboard/domain/entities/crop_cycle_entity.dart';

class CropCycleResponse {
  final bool success;
  final String message;
  final List<CropCycle> data;
  final Meta meta;

  CropCycleResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.meta,
  });
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}
