import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';
import 'package:hydro_iot/src/dashboard/data/models/session_data.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class SessionModal extends StatefulWidget {
  final Function(SessionData) onSessionAdded;

  const SessionModal({super.key, required this.onSessionAdded});

  @override
  State<SessionModal> createState() => _SessionModalState();
}

class _SessionModalState extends State<SessionModal> {
  late TextEditingController _deviceNameController;
  late TextEditingController _totalDaysController;

  late RangeValues _phRange;
  late RangeValues _ppmRange;
  DateTime _selectedDate = DateTime.now();

  void _saveDevice() {
    if (_deviceNameController.text.isEmpty || _totalDaysController.text.isEmpty || controller.selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    String deviceName = _deviceNameController.text;
    String plantName = controller.selectedItems.first.value;
    int totalDays = int.tryParse(_totalDaysController.text) ?? 30;
    double minPH = _phRange.start;
    double maxPH = _phRange.end;
    int minPPM = _ppmRange.start.round();
    int maxPPM = _ppmRange.end.round();

    SessionData newSession = SessionData(
      deviceName: deviceName,
      plantName: plantName,
      startDate: _selectedDate,
      totalDays: totalDays,
      minPh: minPH,
      maxPh: maxPH,
      minPpm: minPPM,
      maxPpm: maxPPM,
    );

    widget.onSessionAdded(newSession);
    Navigator.of(context).pop();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController();
    _totalDaysController = TextEditingController(text: '30');
    _phRange = const RangeValues(6.0, 7.5);
    _ppmRange = const RangeValues(500, 1500);
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _totalDaysController.dispose();
    super.dispose();
  }

  var items = [
    DropdownItem(label: 'Broccoli', value: 'Broccoli'),
    DropdownItem(label: 'Lettuce', value: 'Lettuce'),
    DropdownItem(label: 'Spinach', value: 'Spinach'),
    DropdownItem(label: 'Kale', value: 'Kale'),
    DropdownItem(label: 'Parsley', value: 'Parsley'),
  ];
  final controller = MultiSelectController<String>();

  @override
  Widget build(BuildContext context) {
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
            rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 15.r, pressedElevation: 10, elevation: 5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: ColorValues.neutral300, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 10),
              Text('Add New Session', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              ///Device Name Input
              TextField(
                controller: _deviceNameController,
                decoration: InputDecoration(
                  labelText: 'Device Name',
                  hintText: 'Enter device name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorValues.iotMainColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //plant Selection Dropdown
              MultiDropdown<String>(
                items: items,
                controller: controller,
                enabled: true,
                singleSelect: true,
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
                    borderSide: BorderSide(color: ColorValues.iotMainColor, width: 2),
                  ),
                ),
                dropdownDecoration: DropdownDecoration(
                  marginTop: 2,
                  maxHeight: 200,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                dropdownItemDecoration: DropdownItemDecoration(
                  selectedIcon: const Icon(Icons.check_box, color: Colors.green),
                  disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  selectedBackgroundColor: ColorValues.iotMainColor.withValues(alpha: 0.1),
                ),
              ),
              const SizedBox(height: 16),

              //date
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorValues.iotMainColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              //totaldays
              TextField(
                controller: _totalDaysController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Days',
                  hintText: 'Enter total days for session',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorValues.iotMainColor, width: 2),
                  ),
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

              // Add Session Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveDevice,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: ColorValues.iotMainColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Session', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}
