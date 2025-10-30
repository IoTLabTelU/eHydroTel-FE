import 'package:hydro_iot/src/devices/presentation/widgets/cardlike_container_widget.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import '../../../../pkg.dart';

class SettingDeviceScreen extends StatefulWidget {
  const SettingDeviceScreen({
    super.key,
    required this.deviceName,
    required this.deviceId,
    required this.deviceDescription,
    required this.addedAt,
    required this.updatedAt,
  });

  final String deviceName;
  final String deviceId;
  final String deviceDescription;
  final String addedAt;
  final String updatedAt;

  static const String path = 'settings';

  @override
  State<SettingDeviceScreen> createState() => _SettingDeviceScreenState();
}

class _SettingDeviceScreenState extends State<SettingDeviceScreen> {
  late TextEditingController _deviceNameController;
  late TextEditingController _deviceIdController;
  late TextEditingController _deviceDescriptionController;
  final _formKey = GlobalKey<FormState>();
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    _deviceNameController = TextEditingController(text: widget.deviceName);
    _deviceIdController = TextEditingController(text: widget.deviceId);
    _deviceDescriptionController = TextEditingController(text: widget.deviceDescription);
    _deviceNameController.addListener(onTextChanged);
    _deviceDescriptionController.addListener(onTextChanged);
  }

  void onTextChanged() {
    if (!isEdited) {
      setState(() {
        isEdited =
            _deviceNameController.text != widget.deviceName || _deviceDescriptionController.text != widget.deviceDescription;
      });
    }
  }

  @override
  void dispose() {
    _deviceNameController.dispose();
    _deviceIdController.dispose();
    _deviceDescriptionController.dispose();
    _formKey.currentState?.dispose();
    _deviceNameController.removeListener(onTextChanged);
    _deviceDescriptionController.removeListener(onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    void saveDevice() {
      context.pop();
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
              onPressed: () {
                context.pop();
              },
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
                child: Form(
                  key: _formKey,
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
              ),
              const SizedBox(height: 20),
              // Save Button
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: cancelButton(context: context, onPressed: () => context.pop(), textColor: ColorValues.green900),
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
