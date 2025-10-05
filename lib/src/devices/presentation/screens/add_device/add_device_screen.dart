import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_pairing_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_form_screen.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/add_device_summary_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  const AddDeviceScreen({super.key});

  static const String path = 'create';

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentStep = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceDescriptionController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();

  void _resetAll() {
    setState(() {
      _currentStep = 0;
      _deviceNameController.clear();
      _deviceDescriptionController.clear();
      _serialNumberController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen<AsyncValue>(devicesControllerProvider, (previous, next) {
      next.when(
        data: (data) {
          _resetAll();
          Toast().showSuccessToast(context: context, title: local.success, description: local.deviceAddedSuccessfully);
          context.pop();
          context.pop();
        },
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            context.pop();
            Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.registeringYourDevice),
          );
        },
      );
    });

    void registerDevice() {
      if (_deviceNameController.text.isEmpty ||
          _deviceDescriptionController.text.isEmpty ||
          _serialNumberController.text.isEmpty) {
        Toast().showErrorToast(context: context, title: local.error, description: local.fillAllFields);
        return;
      }

      ref
          .read(devicesControllerProvider.notifier)
          .registerDevice(
            name: _deviceNameController.text,
            description: _deviceDescriptionController.text,
            serialNumber: _serialNumberController.text,
          );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop && result == true) {
          _resetAll();
          return;
        }
        await showDialog(
          context: context,
          builder: (context) => alertDialog(
            context: context,
            title: local.cancelAddDevice,
            content: local.areYouSureCancelAddDevice,
            confirmText: local.yes,
            cancelText: local.no,
            onConfirm: () => context.pop(true),
          ),
        ).then((result) {
          if (result == true) {
            _resetAll();
            if (context.mounted) context.pop();
          }
        });
      },
      child: AnimatedContainer(
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
                if (_currentStep > 0) secondaryButton(onPressed: details.onStepCancel!, text: local.back, context: context),
                const Spacer(),
                if (_currentStep < 2)
                  secondaryButton(onPressed: details.onStepContinue!, text: local.next, context: context),
                if (_currentStep == 2) primaryButton(onPressed: registerDevice, text: local.addDevice, context: context),
              ],
            );
          },
          onStepContinue: () {
            if (_currentStep == 0 && !_formKey.currentState!.validate()) {
              return;
            }

            if (_currentStep < 2) {
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
                height: heightQuery(context) * 0.6,
                child: AddDeviceFormScreen(
                  deviceNameController: _deviceNameController,
                  deviceDescriptionController: _deviceDescriptionController,
                  deviceIdController: _serialNumberController,
                  formKey: _formKey,
                ),
              ),
              isActive: _currentStep >= 0,
              state: _currentStep >= 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text(''),
              content: SizedBox(height: heightQuery(context) * 0.6, child: const AddDevicePairingScreen()),
              isActive: _currentStep >= 1,
              state: _currentStep >= 1 ? StepState.complete : StepState.indexed,
            ),

            Step(
              title: const Text(''),
              content: SizedBox(
                height: heightQuery(context) * 0.6,
                child: buildAddDeviceSummaryWidget(
                  context: context,
                  deviceName: _deviceNameController.text,
                  deviceDescription: _deviceDescriptionController.text,
                  serialNumber: _serialNumberController.text,
                ),
              ),
              isActive: _currentStep >= 2,
              state: _currentStep >= 2 ? StepState.complete : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}
