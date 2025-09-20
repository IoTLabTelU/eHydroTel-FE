class CropCycle {
  final String id;
  final String name;
  final double phMin;
  final double phMax;
  final int ppmMin;
  final int ppmMax;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool active;
  final String status;
  final Device device;
  final Plant plant;

  CropCycle({
    required this.id,
    required this.name,
    required this.phMin,
    required this.phMax,
    required this.ppmMin,
    required this.ppmMax,
    required this.startedAt,
    this.endedAt,
    required this.active,
    required this.status,
    required this.device,
    required this.plant,
  });
}

class Device {
  final String id;
  final String name;
  final String serialNumber;
  final String status;

  Device({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.status,
  });
}

class Plant {
  final String id;
  final String name;

  Plant({required this.id, required this.name});
}
