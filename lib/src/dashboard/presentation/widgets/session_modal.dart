import 'package:flutter/material.dart';
import 'package:hydro_iot/utils/utils.dart';

class SessionModal extends StatefulWidget {
  const SessionModal({super.key});

  @override
  State<SessionModal> createState() => _SessionModalState();
}

class _SessionModalState extends State<SessionModal> {
  late TextEditingController _deviceNameController;
  late TextEditingController _deviceIdController;

  late RangeValues _phRange;
  late RangeValues _ppmRange;

  void _saveDevice() {
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
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController();
    _deviceIdController = TextEditingController();
    _phRange = const RangeValues(6.0, 7.5);
    _ppmRange = const RangeValues(500, 1500);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // pH Threshold
          const Text(
            'pH Threshold',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RangeSlider(
            values: _phRange,
            min: 0,
            max: 14,
            divisions: 14,
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

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveDevice,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
