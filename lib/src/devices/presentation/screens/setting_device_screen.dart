import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class SettingDeviceScreen extends StatefulWidget {
  const SettingDeviceScreen({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.deviceDescription,
    required this.ssid,
  });

  final String deviceName;
  final String deviceId;
  final String deviceDescription;
  final String ssid;

  static const String path = 'settings';

  @override
  State<SettingDeviceScreen> createState() => _SettingDeviceScreenState();
}

class _SettingDeviceScreenState extends State<SettingDeviceScreen> {
  late TextEditingController _deviceNameController;
  late TextEditingController _deviceIdController;
  late TextEditingController _deviceDescriptionController;
  late TextEditingController _ssidController;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController(text: widget.deviceName);
    _deviceIdController = TextEditingController(text: widget.deviceId);
    _deviceDescriptionController = TextEditingController(text: widget.deviceDescription);
    if (widget.ssid == 'Unknown SSID') {
      _ssidController = TextEditingController();
    } else {
      _ssidController = TextEditingController(text: widget.ssid);
    }
  }

  void _saveDevice() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'Device Information',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorValues.neutral500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
              ],
            ),
            const SizedBox(height: 20),
            TextFormFieldComponent(
              controller: _deviceIdController,
              label: 'Serial Number',
              hintText: 'Enter serial number',
              obscureText: false,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormFieldComponent(
              controller: _deviceNameController,
              label: 'Device Name',
              hintText: 'Enter device name',
              obscureText: false,
            ),
            const SizedBox(height: 16),
            TextFormFieldComponent(
              controller: _deviceDescriptionController,
              label: 'Device Description',
              hintText: 'Enter device description',
              obscureText: false,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    'Pairing Configuration',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorValues.neutral500,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 16),
            TextFormFieldComponent(controller: _ssidController, label: 'SSID', hintText: 'Enter SSID', obscureText: false),
            const SizedBox(height: 16),
            TextFormFieldComponent(
              controller: _passwordController,
              label: 'Password',
              hintText: 'Enter password',
              obscureText: true,
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: primaryButton(text: 'Save Changes', onPressed: _saveDevice, context: context),
            ),
          ],
        ),
      ),
    );
  }
}
