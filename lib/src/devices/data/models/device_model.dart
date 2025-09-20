import '../../domain/entities/device.dart';

class DeviceModel extends Device {
  DeviceModel({
    required super.id,
    required super.ownerId,
    required super.name,
    required super.description,
    required super.serialNumber,
    required super.adminStatus,
    required super.status,
    super.ssid,
    required super.createdAt,
    required super.updatedAt,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      id: json['id'],
      ownerId: json['owner_id'],
      name: json['name'],
      description: json['description'],
      serialNumber: json['serial_number'],
      adminStatus: json['admin_status'],
      status: json['status'],
      ssid: json['ssid'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
