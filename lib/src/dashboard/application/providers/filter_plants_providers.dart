import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/res/constant.dart';

class FilterDevices extends Notifier<DeviceStatus?> {
  @override
  DeviceStatus? build() => DeviceStatus.active;

  void setPlantStatus(DeviceStatus? status) {
    state = status;
  }
}

final filterDevicesProvider = NotifierProvider<FilterDevices, DeviceStatus?>(FilterDevices.new);
