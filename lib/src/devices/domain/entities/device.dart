class Device {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String serialNumber;
  final String adminStatus;
  final String status;
  final String? ssid;
  final DateTime createdAt;
  final DateTime updatedAt;

  Device({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.serialNumber,
    required this.adminStatus,
    required this.status,
    this.ssid,
    required this.createdAt,
    required this.updatedAt,
  });
}
