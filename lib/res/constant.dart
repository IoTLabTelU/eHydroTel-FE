class AppStrings {
  static const String appName = 'ꫀHydrotel';
  static const String errorMessage = 'An error has occurred. Please try again.';
  static const String loadingMessage = 'Loading, please wait...';
  static const String successMessage = 'Operation completed successfully!';
  static const String noDataMessage = 'No data available.';
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String unauthorizedMessage = 'Unauthorized access. Please log in again.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String invalidInputMessage = 'Invalid input. Please check your data.';
  static const String timeoutMessage = 'Request timed out. Please try again.';
  static const String maintenanceMessage = 'The system is currently under maintenance. Please try again later.';
}

class EndpointStrings {}

enum DeviceStatus { active, idle, critical }

String getDeviceStatusText(DeviceStatus status) {
  switch (status) {
    case DeviceStatus.active:
      return 'Active';
    case DeviceStatus.idle:
      return 'Idle';
    case DeviceStatus.critical:
      return 'Critical';
  }
}

enum PlantSessionStatus { active, completed, stopped }

String getPlantSessionStatusText(PlantSessionStatus status) {
  switch (status) {
    case PlantSessionStatus.active:
      return 'Active';
    case PlantSessionStatus.completed:
      return 'Completed';
    case PlantSessionStatus.stopped:
      return 'Stopped';
  }
}
