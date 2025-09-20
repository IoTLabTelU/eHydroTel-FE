import '../../domain/entities/crop_cycle_entity.dart';

class CropCycleModel extends CropCycle {
  CropCycleModel({
    required super.id,
    required super.name,
    required super.phMin,
    required super.phMax,
    required super.ppmMin,
    required super.ppmMax,
    required super.startedAt,
    super.endedAt,
    required super.active,
    required super.status,
    required DeviceModel super.device,
    required PlantModel super.plant,
  });

  factory CropCycleModel.fromJson(Map<String, dynamic> json) {
    return CropCycleModel(
      id: json['id'],
      name: json['name'],
      phMin: json['ph_min'].toDouble(),
      phMax: json['ph_max'].toDouble(),
      ppmMin: json['ppm_min'],
      ppmMax: json['ppm_max'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      active: json['active'],
      status: json['status'],
      device: DeviceModel.fromJson(json['device']),
      plant: PlantModel.fromJson(json['plant']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ph_min': phMin,
      'ph_max': phMax,
      'ppm_min': ppmMin,
      'ppm_max': ppmMax,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'active': active,
      'status': status,
      'device': (device as DeviceModel).toJson(),
      'plant': (plant as PlantModel).toJson(),
    };
  }
}

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.name,
    required super.serialNumber,
    required super.status,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      name: json['name'],
      serialNumber: json['serial_number'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'serial_number': serialNumber,
      'status': status,
    };
  }
}

class PlantModel extends Plant {
  PlantModel({required super.id, required super.name});

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    return PlantModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
