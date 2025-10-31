import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDeviceFormScreen extends StatefulWidget {
  const AddDeviceFormScreen({super.key, required this.serialNumber});

  final String serialNumber;

  static const String path = 'form';

  @override
  State<AddDeviceFormScreen> createState() => _AddDeviceFormScreenState();
}

class _AddDeviceFormScreenState extends State<AddDeviceFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _deviceNameController = TextEditingController();
  final TextEditingController _deviceDescriptionController = TextEditingController();
  late TextEditingController _serialNumberController;

  @override
  void initState() {
    super.initState();
    _serialNumberController = TextEditingController(text: widget.serialNumber);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              decoration: BoxDecoration(
                color: ColorValues.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(color: ColorValues.neutral200),
              ),
              margin: EdgeInsets.only(left: 16.w),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: ColorValues.blackColor),
                onPressed: () async {
                  await showAdaptiveDialog(
                    context: context,
                    builder: (_) {
                      return alertDialog(
                        context: context,
                        title: local.discardYourEntries,
                        content: local.anyUnsavedEntriesWillBeLost,
                        confirmText: local.discardEntries,
                        onConfirm: () async {
                          context.pop();
                        },
                      );
                    },
                  );
                },
              ),
            ),
            title: Text(
              local.newDevice,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormFieldComponent(
                    controller: _serialNumberController,
                    hintText: 'Serial Number',
                    label: local.serialNumber,
                    obscureText: false,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter serial number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormFieldComponent(
                    controller: _deviceNameController,
                    hintText: 'Name your device',
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
                    hintText: 'Description (optional)',
                    label: local.deviceDescription,
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: cancelButton(
                          context: context,
                          onPressed: () => context.pop(),
                          textColor: ColorValues.green900,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 5,
                        child: primaryButton(
                          text: local.next,
                          onPressed: _formKey.currentState?.validate() == true
                              ? () {
                                  context.push(
                                    '/create/preparing',
                                    extra: {
                                      'deviceName': _deviceNameController.text,
                                      'deviceDescription': _deviceDescriptionController.text,
                                      'serialNumber': _serialNumberController.text,
                                    },
                                  );
                                }
                              : () {},
                          context: context,
                          textColor: ColorValues.green900,
                          color: _formKey.currentState?.validate() == true ? ColorValues.green500 : ColorValues.neutral400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
