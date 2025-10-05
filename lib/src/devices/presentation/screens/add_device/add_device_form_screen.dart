import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AddDeviceFormScreen extends StatefulWidget {
  const AddDeviceFormScreen({
    super.key,
    required this.deviceNameController,
    required this.deviceDescriptionController,
    required this.deviceIdController,
    required this.formKey,
  });

  final TextEditingController deviceNameController;
  final TextEditingController deviceDescriptionController;
  final TextEditingController deviceIdController;

  final GlobalKey<FormState> formKey;

  @override
  State<AddDeviceFormScreen> createState() => _AddDeviceFormScreenState();
}

class _AddDeviceFormScreenState extends State<AddDeviceFormScreen> {
  GlobalKey<FormState> get _formKey => widget.formKey;
  TextEditingController get _deviceNameController => widget.deviceNameController;
  TextEditingController get _deviceDescriptionController => widget.deviceDescriptionController;
  TextEditingController get _deviceIdController => widget.deviceIdController;

  Barcode? _barcode;

  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      _barcode = barcodes.barcodes.first;
      final displayValue = _barcode?.displayValue;
      if (displayValue == null) {
        Toast().showErrorToast(
          context: context,
          title: 'Error',
          description: 'No display value found in the scanned barcode.',
        );
        context.pop();
        return;
      }
      if (!displayValue.contains('EHT-')) {
        Toast().showErrorToast(
          context: context,
          title: 'Error',
          description: 'Invalid barcode. Please scan a valid device serial number barcode.',
        );
        context.pop();
        return;
      }
      setState(() {
        _deviceIdController.text = displayValue;
      });
      await showDialog(
        context: context,
        builder: (context) {
          return infoDialog(
            context: context,
            title: 'Scanned!',
            content: 'Serial Number: $displayValue',
            onConfirm: () => context.pop(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Icon(Icons.devices, size: 100.sp, color: ColorValues.iotMainColor),
              ),
              Text(
                local.addDeviceInfo,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              TextFormFieldComponent(
                controller: _deviceIdController,
                hintText: 'Enter Serial Number',
                label: local.serialNumber,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter serial number';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: () {
                    context.push('/devices/create/scan', extra: {'barcode': _barcode, 'onDetect': _handleBarcode});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.qr_code_scanner, color: ColorValues.iotMainColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormFieldComponent(
                controller: _deviceNameController,
                hintText: 'Enter device name',
                label: local.deviceName,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter device name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormFieldComponent(
                controller: _deviceDescriptionController,
                hintText: 'Enter device description (optional)',
                label: local.deviceDescription,
                obscureText: false,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
