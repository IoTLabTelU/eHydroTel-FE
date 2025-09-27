import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/components/fancy_loading_dialog.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/src/dashboard/application/controllers/crop_cycle_controller.dart';
import 'package:hydro_iot/src/dashboard/application/controllers/plant_controller.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';
import 'package:hydro_iot/src/dashboard/domain/entities/plant_entity.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/domain/entities/device_entity.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class SessionModal extends ConsumerStatefulWidget {
  final Function(SessionData) onSessionAdded;

  const SessionModal({super.key, required this.onSessionAdded});

  @override
  ConsumerState<SessionModal> createState() => _SessionModalState();
}

class _SessionModalState extends ConsumerState<SessionModal> {
  late TextEditingController _nameController;
  late TextEditingController _totalDaysController;

  late RangeValues _phRange;
  late RangeValues _ppmRange;

  AsyncValue<List<PlantEntity>> get plantTypes =>
      ref.watch(plantControllerProvider);
  AsyncValue<List<DeviceEntity>> get devices =>
      ref.watch(devicesControllerProvider);

  void _saveDevice() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter session name')),
      );
      return;
    }

    if (devicesController.selectedItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a device')));
      return;
    }

    if (plantsController.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a plant type')),
      );
      return;
    }

    String deviceId = devicesController.selectedItems.first.value.id;
    String name = _nameController.text;
    String plantId = plantsController.selectedItems.first.value.id;
    double minPH = _phRange.start;
    double maxPH = _phRange.end;
    int minPPM = _ppmRange.start.round();
    int maxPPM = _ppmRange.end.round();

    SessionData newSession = SessionData(
      deviceId: deviceId,
      plantId: plantId,
      name: name,
      phMin: minPH,
      phMax: maxPH,
      ppmMin: minPPM,
      ppmMax: maxPPM,
    );

    ref
        .read(cropCycleControllerProvider.notifier)
        .addCropCycleSession(newSession);
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _totalDaysController = TextEditingController();
    _phRange = const RangeValues(0, 0);
    _ppmRange = const RangeValues(0, 0);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalDaysController.dispose();
    super.dispose();
  }

  final plantsController = MultiSelectController<PlantEntity>();
  final devicesController = MultiSelectController<DeviceEntity>();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(cropCycleControllerProvider, (previous, next) {
      next.whenOrNull(
        loading: () => showDialog(
          context: context,
          builder: (context) => const FancyLoadingDialog(
            title: 'Adding New Crop Cycle Session...',
          ),
        ),
        error: (error, stackTrace) {
          context.pop();
          Toast().showErrorToast(
            context: context,
            title: 'Error',
            description: error.toString(),
          );
        },
        data: (_) {
          context.pop();
          Toast().showSuccessToast(
            context: context,
            title: 'Success',
            description: 'Crop Cycle Session Added',
          );
          SessionData sessionData = SessionData(
            deviceId: devicesController.selectedItems.first.value.id,
            plantId: plantsController.selectedItems.first.value.id,
            name: _nameController.text,
            phMin: _phRange.start,
            phMax: _phRange.end,
            ppmMin: _ppmRange.start.round(),
            ppmMax: _ppmRange.end.round(),
          );
          widget.onSessionAdded(sessionData);
          context.pop();
        },
      );
    });
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTrackColor: ColorValues.neutral400,
            thumbColor: ColorValues.whiteColor,
            overlayColor: ColorValues.iotMainColor.withValues(alpha: 0.2),
            valueIndicatorColor: ColorValues.iotMainColor,
            trackHeight: heightQuery(context) * 0.03,
            rangeThumbShape: RoundRangeSliderThumbShape(
              enabledThumbRadius: 15.r,
              pressedElevation: 10,
              elevation: 5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: ColorValues.neutral300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Add New Session',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              devices.when(
                data: (data) {
                  return MultiDropdown<DeviceEntity>(
                    items: data
                        .map(
                          (device) =>
                              DropdownItem(label: device.name, value: device),
                        )
                        .toList(),
                    controller: devicesController,
                    enabled: true,
                    singleSelect: true,
                    itemSeparator: const Divider(
                      height: 1,
                      color: ColorValues.neutral300,
                    ),
                    fieldDecoration: FieldDecoration(
                      hintText: 'Select Device',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ColorValues.iotMainColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorValues.iotMainColor,
                          width: 2,
                        ),
                      ),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 200,
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: const Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      disabledIcon: Icon(
                        Icons.lock,
                        color: Colors.grey.shade300,
                      ),
                      selectedBackgroundColor: ColorValues.iotMainColor
                          .withValues(alpha: 0.1),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Text('Error: $error');
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(height: 16),

              ///Session Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Session Name',
                  hintText: 'Enter session name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: ColorValues.iotMainColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //plant Selection Dropdown
              plantTypes.when(
                data: (data) {
                  print('Plant Types: ${data}');
                  return MultiDropdown<PlantEntity>(
                    items: data
                        .map(
                          (plant) =>
                              DropdownItem(label: plant.name, value: plant),
                        )
                        .toList(),
                    controller: plantsController,
                    enabled: true,
                    singleSelect: true,
                    itemSeparator: const Divider(
                      height: 1,
                      color: ColorValues.neutral300,
                    ),
                    onSelectionChange: (selectedItems) {
                      setState(() {
                        // Update UI based on selected plant
                        if (selectedItems.isNotEmpty) {
                          final selectedPlant = selectedItems.first;
                          _phRange = RangeValues(
                            selectedPlant.phMin ?? 0,
                            selectedPlant.phMax ?? 14,
                          );
                          _ppmRange = RangeValues(
                            selectedPlant.ppmMin?.toDouble() ?? 0,
                            selectedPlant.ppmMax?.toDouble() ?? 2000,
                          );
                        } else {
                          _phRange = const RangeValues(0, 0);
                          _ppmRange = const RangeValues(0, 0);
                        }
                      });
                    },
                    fieldDecoration: FieldDecoration(
                      hintText: 'Select Plant Type',
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      showClearIcon: false,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: ColorValues.iotMainColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: ColorValues.iotMainColor,
                          width: 2,
                        ),
                      ),
                    ),
                    dropdownDecoration: DropdownDecoration(
                      marginTop: 2,
                      maxHeight: 200,
                      backgroundColor: Theme.of(
                        context,
                      ).scaffoldBackgroundColor,
                    ),
                    dropdownItemDecoration: DropdownItemDecoration(
                      selectedIcon: const Icon(
                        Icons.check_box,
                        color: Colors.green,
                      ),
                      disabledIcon: Icon(
                        Icons.lock,
                        color: Colors.grey.shade300,
                      ),
                      selectedBackgroundColor: ColorValues.iotMainColor
                          .withValues(alpha: 0.1),
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Text('Error: $error');
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              ),

              const SizedBox(height: 16),

              if (plantsController.selectedItems.isNotEmpty) ...[
                // //totaldays
                // TextField(
                //   controller: _totalDaysController,
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //     labelText: 'Estimated Harvest Days',
                //     hintText: 'Enter estimated days to harvest',
                //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(12),
                //       borderSide: BorderSide(color: ColorValues.iotMainColor, width: 2),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24), // pH Threshold
                const Text(
                  'pH Threshold',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RangeSlider(
                  values: _phRange,
                  min: 0,
                  max: 14,
                  divisions: 28,
                  labels: RangeLabels(
                    _phRange.start.toStringAsFixed(1),
                    _phRange.end.toStringAsFixed(1),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _phRange = values;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Min pH: ${_phRange.start.toStringAsFixed(1)}'),
                    Text('Max pH: ${_phRange.end.toStringAsFixed(1)}'),
                  ],
                ),
                const SizedBox(height: 24),

                // PPM Threshold
                const Text(
                  'PPM Threshold',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                RangeSlider(
                  values: _ppmRange,
                  min: 0,
                  max: 2000,
                  divisions: 40,
                  labels: RangeLabels(
                    _ppmRange.start.round().toString(),
                    _ppmRange.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _ppmRange = values;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Min PPM: ${_ppmRange.start.round()}'),
                    Text('Max PPM: ${_ppmRange.end.round()}'),
                  ],
                ),

                const SizedBox(height: 32),

                // Add Session Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveDevice,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: ColorValues.iotMainColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Add Session',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ] else
                const SizedBox.shrink(),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}
