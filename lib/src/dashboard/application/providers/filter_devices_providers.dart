import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/res/constant.dart';

class FilterDevices extends Notifier<DeviceStatus?> {
  @override
  DeviceStatus? build() => DeviceStatus.active;

  void setDeviceStatus(DeviceStatus? status) {
    state = status;
  }
}

final filterDevicesProvider = NotifierProvider<FilterDevices, DeviceStatus?>(FilterDevices.new);

class FilterCropCycle extends Notifier<PlantStatus?> {
  @override
  PlantStatus? build() => PlantStatus.ongoing;
}

final filterCropCycleProvider = NotifierProvider<FilterCropCycle, PlantStatus?>(FilterCropCycle.new);

class FilterHistoryCropCycle extends Notifier<PlantStatus?> {
  @override
  PlantStatus? build() => PlantStatus.finished;
}

final filterHistoryCropCycleProvider = NotifierProvider<FilterHistoryCropCycle, PlantStatus?>(FilterHistoryCropCycle.new);
