class SessionData {
  final String deviceName;
  final String plantName;
  final DateTime startDate;
  final int totalDays;
  final double minPh;
  final double maxPh;
  final int minPpm;
  final int maxPpm;

  SessionData({
    required this.deviceName,
    required this.plantName,
    required this.startDate,
    required this.totalDays,
    required this.minPh,
    required this.maxPh,
    required this.minPpm,
    required this.maxPpm,
  });
}
