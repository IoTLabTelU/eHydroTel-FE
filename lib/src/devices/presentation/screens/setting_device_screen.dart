import 'package:flutter/material.dart';
import 'package:hydro_iot/utils/utils.dart';

class SettingDeviceScreen extends StatefulWidget {
  const SettingDeviceScreen({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.initialMinPh,
    required this.initialMaxPh,
    required this.initialMinPPM,
    required this.initialMaxPPM,
  });

  final String deviceName;
  final String deviceId;
  final double initialMinPh;
  final double initialMaxPh;
  final double initialMinPPM;
  final double initialMaxPPM;

  static const String path = 'settings';

  @override
  State<SettingDeviceScreen> createState() => _SettingDeviceScreenState();
}

class _SettingDeviceScreenState extends State<SettingDeviceScreen> {
  late TextEditingController _deviceNameController;
  late TextEditingController _deviceIdController;

  late RangeValues _phRange;
  late RangeValues _ppmRange;

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController(text: widget.deviceName);
    _deviceIdController = TextEditingController(text: widget.deviceId);
    _phRange = RangeValues(widget.initialMinPh, widget.initialMaxPh);
    _ppmRange = RangeValues(widget.initialMinPPM.toDouble(), widget.initialMaxPPM.toDouble());
  }

  void _saveDevice() {
    // TODO: Implement your save/update logic here
    String updatedName = _deviceNameController.text;
    String updatedId = _deviceIdController.text;
    double minPH = _phRange.start;
    double maxPH = _phRange.end;
    int minPPM = _ppmRange.start.round();
    int maxPPM = _ppmRange.end.round();

    print('Updated Device Info:');
    print('Name: $updatedName');
    print('ID: $updatedId');
    print('pH Range: $minPH - $maxPH');
    print('PPM Range: $minPPM - $maxPPM');

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Device Name
          const Text('Device Name', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _deviceNameController,
            decoration: InputDecoration(
              hintText: 'Enter device name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),

          // Device ID
          const Text('Device ID', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _deviceIdController,
            decoration: InputDecoration(
              hintText: 'Enter device ID',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),

          // pH Threshold
          const Text('pH Threshold', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          RangeSlider(
            values: _phRange,
            min: 0,
            max: 14,
            divisions: 14,
            labels: RangeLabels(_phRange.start.toStringAsFixed(1), _phRange.end.toStringAsFixed(1)),
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
          const Text('PPM Threshold', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          RangeSlider(
            values: _ppmRange,
            min: 0,
            max: 2000,
            divisions: 40,
            labels: RangeLabels(_ppmRange.start.round().toString(), _ppmRange.end.round().toString()),
            onChanged: (RangeValues values) {
              setState(() {
                _ppmRange = values;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Min PPM: ${_ppmRange.start.round()}'), Text('Max PPM: ${_ppmRange.end.round()}')],
          ),
          const SizedBox(height: 32),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveDevice,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
