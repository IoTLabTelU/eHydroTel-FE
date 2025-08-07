import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/buttons.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_connecting_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_form_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_sensor_setup_screen.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/add_device_summary_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  static const String path = 'create';

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  bool isDeviceConnected = false;
  bool isDeviceConnecting = false;
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceDescriptionController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();

  RangeValues _phValues = RangeValues(5.0, 7.0);
  RangeValues _ppmValues = RangeValues(300.0, 700.0);

  void changePhValues(RangeValues newValues) {
    setState(() {
      _phValues = newValues;
    });
  }

  void changePpmValues(RangeValues newValues) {
    setState(() {
      _ppmValues = newValues;
    });
  }

  void connectDevice() {
    setState(() {
      isDeviceConnecting = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isDeviceConnected = true;
        isDeviceConnecting = false;
      });
    });
  }

  void _resetAll() {
    setState(() {
      isDeviceConnected = false;
      isDeviceConnecting = false;
      _currentStep = 0;
      _deviceNameController.clear();
      _deviceDescriptionController.clear();
      _deviceIdController.clear();
      _phValues = RangeValues(5.0, 7.0);
      _ppmValues = RangeValues(300.0, 700.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Stepper(
        currentStep: _currentStep,
        onStepTapped: null,
        elevation: 5,
        type: StepperType.horizontal,
        connectorColor: WidgetStatePropertyAll(ColorValues.iotMainColor),
        connectorThickness: 2,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              if (_currentStep > 0) secondaryButton(onPressed: details.onStepCancel!, text: 'Back', context: context),
              const Spacer(),
              if (_currentStep < 3) secondaryButton(onPressed: details.onStepContinue!, text: 'Next', context: context),
              if (_currentStep == 3)
                primaryButton(
                  onPressed: () {
                    _resetAll();
                    Toast().showSuccessToast(
                      context: context,
                      title: 'Device Added Successfully',
                      description: 'Your device has been added successfully.',
                    );
                    context.pop();
                  },
                  text: 'Add Device',
                  context: context,
                ),
            ],
          );
        },
        onStepContinue: () {
          if (_currentStep == 0 && !isDeviceConnected) {
            Toast().showErrorToast(
              context: context,
              title: 'Device not connected',
              description: 'Please connect your device first.',
            );
            return;
          }
          if (_currentStep == 1 && !_formKey.currentState!.validate()) {
            return;
          }
          if (_currentStep < 3) {
            setState(() {
              _currentStep++;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          }
        },

        physics: const ClampingScrollPhysics(),
        controller: _scrollController,
        steps: [
          Step(
            title: const Text(''),
            content: SizedBox(
              height: heightQuery(context) * 0.5,
              child: AddDeviceConnectingScreen(
                isDeviceConnected: isDeviceConnected,
                isDeviceConnecting: isDeviceConnecting,
                onConnectPressed: connectDevice,
              ),
            ),
            isActive: _currentStep == 0,
            state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text(''),
            content: SizedBox(
              height: heightQuery(context) * 0.5,
              child: AddDeviceFormScreen(
                deviceNameController: _deviceNameController,
                deviceDescriptionController: _deviceDescriptionController,
                deviceIdController: _deviceIdController,
                formKey: _formKey,
              ),
            ),
            isActive: _currentStep >= 1,
            state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text(''),
            content: SizedBox(
              height: heightQuery(context) * 0.5,
              child: AddDeviceSensorSetupScreen(
                phValues: _phValues,
                ppmValues: _ppmValues,
                onChangedPH: (RangeValues value) {
                  changePhValues(value);
                },
                onChangedPPM: (RangeValues value) {
                  changePpmValues(value);
                },
              ),
            ),
            isActive: _currentStep >= 2,
            state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text(''),
            content: SizedBox(
              height: heightQuery(context) * 0.5,
              child: buildAddDeviceSummaryWidget(
                context: context,
                deviceName: _deviceNameController.text,
                deviceDescription: _deviceDescriptionController.text,
                deviceId: _deviceIdController.text,
                phValues: _phValues,
                ppmValues: _ppmValues,
              ),
            ),
            isActive: _currentStep >= 3,
            state: _currentStep >= 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
