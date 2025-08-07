import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDeviceSensorSetupScreen extends StatefulWidget {
  const AddDeviceSensorSetupScreen({
    super.key,
    required this.phValues,
    required this.ppmValues,
    required this.onChangedPH,
    required this.onChangedPPM,
  });

  final RangeValues phValues;
  final RangeValues ppmValues;

  final ValueChanged<RangeValues> onChangedPH;
  final ValueChanged<RangeValues> onChangedPPM;

  @override
  State<AddDeviceSensorSetupScreen> createState() => _AddDeviceSensorSetupScreenState();
}

class _AddDeviceSensorSetupScreenState extends State<AddDeviceSensorSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: ColorValues.iotMainColor.withValues(alpha: 0.8),
        inactiveTrackColor: ColorValues.iotMainColor.withValues(alpha: 0.2),
        thumbColor: ColorValues.success500,
        overlayColor: ColorValues.iotMainColor.withValues(alpha: 0.2),
        valueIndicatorColor: ColorValues.iotMainColor,
        trackHeight: 10.h,
        rangeThumbShape: RoundRangeSliderThumbShape(pressedElevation: 10, elevation: 5),
      ),
      child: ListView(
        children: [
          Text('Set Sensor Thresholds', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(
            'Adjust the thresholds based on your specific sensor requirements.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorValues.iotMainColor),
          ),
          const SizedBox(height: 10),
          Text(
            'Ensure that the thresholds are set within the operational range of your sensors.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColorValues.iotMainColor),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Text('0', style: Theme.of(context).textTheme.bodyLarge),
              Expanded(
                child: RangeSlider(
                  key: const Key('phRangeSlider'),
                  values: widget.phValues,
                  onChanged: widget.onChangedPH,
                  min: 0,
                  max: 14,
                  divisions: 28,
                  labels: null,
                ),
              ),
              Text('14', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'pH Thresholds: ${widget.phValues.start.toStringAsFixed(2)} - ${widget.phValues.end.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Text('0', style: Theme.of(context).textTheme.bodyLarge),
              Expanded(
                child: RangeSlider(
                  key: const Key('ppmRangeSlider'),
                  values: widget.ppmValues,
                  onChanged: widget.onChangedPPM,
                  min: 0,
                  max: 2000,
                  divisions: 20,
                  labels: null,
                ),
              ),
              Text('++', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'PPM Thresholds: ${widget.ppmValues.start.toInt()} - ${widget.ppmValues.end.toInt()}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
