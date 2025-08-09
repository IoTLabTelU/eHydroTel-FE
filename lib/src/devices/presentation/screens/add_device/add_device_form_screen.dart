import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Add Device Info', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 20),
              TextFormFieldComponent(
                controller: _deviceIdController,
                hintText: 'Enter device ID',
                label: 'Device ID',
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter device ID';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: () {
                    // Handle QR code scanner tap
                    // This could be a function that opens a QR code scanner
                    // For example, you might use a package like ai_barcode_scanner
                    // to scan a QR code and retrieve the device ID.
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => QRCodeScannerScreen()));
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
                label: 'Device Name',
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
                label: 'Device Description',
                obscureText: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
