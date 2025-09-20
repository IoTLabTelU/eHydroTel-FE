import '../../domain/entities/crop_cycle_response.dart';
import 'crop_cycle_model.dart';

class CropCycleResponseModel extends CropCycleResponse {
  CropCycleResponseModel({
    required super.success,
    required super.message,
    required List<CropCycleModel> super.data,
    required MetaModel super.meta,
  });

  factory CropCycleResponseModel.fromJson(Map<String, dynamic> json) {
    return CropCycleResponseModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => CropCycleModel.fromJson(item))
          .toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => (item as CropCycleModel).toJson()).toList(),
      'meta': (meta as MetaModel).toJson(),
    };
  }
}

class MetaModel extends Meta {
  MetaModel({
    required super.total,
    required super.page,
    required super.limit,
    required super.totalPages,
  });

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
      totalPages: json['totalPages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}
