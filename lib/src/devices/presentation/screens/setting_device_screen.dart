import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/src/devices/application/controllers/devices_controller.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/cardlike_container_widget.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import '../../../../pkg.dart';

class SettingDeviceScreen extends ConsumerStatefulWidget {
  const SettingDeviceScreen({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.deviceDescription,
    required this.addedAt,
    required this.updatedAt,
    required this.ssid,
  });

  final String deviceName;
  final String deviceId;
  final String deviceDescription;
  final String addedAt;
  final String updatedAt;
  final String ssid;

  static const String path = 'settings';

  @override
  ConsumerState<SettingDeviceScreen> createState() => _SettingDeviceScreenState();
}

class _SettingDeviceScreenState extends ConsumerState<SettingDeviceScreen> {
  late TextEditingController _deviceNameController;
  late TextEditingController _deviceIdController;
  late TextEditingController _deviceDescriptionController;
  late TextEditingController _wifiSsidController;
  late TextEditingController _wifiPasswordController;
  final _formKey = GlobalKey<FormState>();
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController(text: widget.deviceName);
    _deviceIdController = TextEditingController(text: widget.deviceId);
    _deviceDescriptionController = TextEditingController(text: widget.deviceDescription);
    _wifiSsidController = TextEditingController(text: widget.ssid);
    _wifiPasswordController = TextEditingController();
    _deviceNameController.addListener(onTextChanged);
    _deviceDescriptionController.addListener(onTextChanged);
    _wifiSsidController.addListener(onTextChanged);
    _wifiPasswordController.addListener(onTextChanged);
  }

  void onTextChanged() {
    if (_deviceNameController.text != widget.deviceName ||
        _deviceDescriptionController.text != widget.deviceDescription ||
        _wifiSsidController.text != widget.ssid ||
        _wifiPasswordController.text.isNotEmpty) {
      setState(() {
        isEdited = true;
      });
    } else {
      setState(() {
        isEdited = false;
      });
    }
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceIdController.dispose();
    _deviceDescriptionController.dispose();
    _formKey.currentState?.dispose();
    _wifiSsidController.dispose();
    _wifiPasswordController.dispose();
    _deviceNameController.removeListener(onTextChanged);
    _deviceDescriptionController.removeListener(onTextChanged);
    _wifiSsidController.removeListener(onTextChanged);
    _wifiPasswordController.removeListener(onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    ref.listen(devicesControllerProvider, (_, next) {
      next.whenOrNull(
        error: (err, _) {
          final errorMessage = (err as Exception).toString().replaceAll('Exception: ', '');
          if (context.mounted) {
            Toast().showErrorToast(context: context, title: local.error, description: errorMessage);
            context.pop();
          }
        },
        data: (data) {
          if (context.mounted) {
            Toast().showSuccessToast(context: context, title: local.success, description: local.deviceUpdatedSuccessfully);
            context.pop();
            context.pop();
          }
        },
        loading: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => FancyLoadingDialog(title: local.updatingDevice),
          );
        },
      );
    });
    void saveDevice() {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      ref
          .read(devicesControllerProvider.notifier)
          .updateDevice(
            deviceId: widget.deviceId,
            name: _deviceNameController.text,
            description: _deviceDescriptionController.text,
            ssid: _wifiSsidController.text.isNotEmpty && _wifiSsidController.text != widget.ssid
                ? _wifiSsidController.text
                : null,
            wifiPassword: _wifiPasswordController.text.isNotEmpty ? _wifiPasswordController.text : null,
          );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorValues.whiteColor,
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
              onPressed: isEdited
                  ? () async {
                      await showAdaptiveDialog(
                        context: context,
                        builder: (_) {
                          return alertDialog(
                            context: context,
                            title: local.discardYourChanges,
                            content: local.anyUnsavedChangesWillBeLost,
                            confirmText: local.discardChanges,
                            onConfirm: () {
                              context.pop();
                            },
                          );
                        },
                      );
                    }
                  : context.pop,
            ),
          ),
          title: Text(
            local.editDevice,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              CardLikeContainerWidget(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${local.addedOn}  ', style: Theme.of(context).textTheme.labelSmall),
                        const VectorGraphic(loader: AssetBytesLoader(IconAssets.dot)),
                        Text(
                          '  ${widget.addedAt}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorValues.neutral600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${local.updatedOn}  ', style: Theme.of(context).textTheme.labelSmall),
                        const VectorGraphic(loader: AssetBytesLoader(IconAssets.dot)),
                        Text(
                          '  ${widget.updatedAt}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorValues.neutral600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CardLikeContainerWidget(
                child: Column(
                  children: [
                    TextFormFieldComponent(
                      controller: _deviceIdController,
                      label: 'Serial Number',
                      hintText: 'Serial number',
                      obscureText: false,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextFormFieldComponent(
                      controller: _deviceNameController,
                      label: 'Device Name',
                      hintText: 'Name your device',
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter device name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormFieldComponent(
                      controller: _deviceDescriptionController,
                      label: 'Device Description',
                      hintText: 'Description (optional)',
                      obscureText: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 12.w),
                child: Text(
                  local.wifiConfiguration,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: ColorValues.neutral500),
                ),
              ),
              const SizedBox(height: 8),
              CardLikeContainerWidget(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormFieldComponent(
                        controller: _wifiSsidController,
                        label: 'New SSID (optional)',
                        hintText: 'New SSID (optional)',
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormFieldComponent(
                        controller: _wifiPasswordController,
                        label: 'New Password (optional)',
                        hintText: 'New Password (optional)',
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              // Save Button
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: cancelButton(
                      context: context,
                      onPressed: isEdited
                          ? () async {
                              await showAdaptiveDialog(
                                context: context,
                                builder: (_) {
                                  return alertDialog(
                                    context: context,
                                    title: local.discardYourChanges,
                                    content: local.anyUnsavedChangesWillBeLost,
                                    confirmText: local.discardChanges,
                                    onConfirm: () {
                                      context.pop();
                                    },
                                  );
                                },
                              );
                            }
                          : context.pop,
                      textColor: ColorValues.green900,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 5,
                    child: primaryButton(
                      text: local.save,
                      onPressed: isEdited ? saveDevice : () {},
                      context: context,
                      color: isEdited ? ColorValues.green500 : ColorValues.neutral400,
                      textColor: ColorValues.green900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
