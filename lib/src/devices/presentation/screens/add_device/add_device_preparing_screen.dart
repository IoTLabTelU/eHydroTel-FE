import 'package:hydro_iot/src/devices/presentation/widgets/blinking_dot_indicator_widget.dart';

import '../../../../../pkg.dart';

class AddDevicePreparingScreen extends StatefulWidget {
  const AddDevicePreparingScreen({
    super.key,
    required this.serialNumber,
    required this.deviceName,
    required this.deviceDescription,
  });

  final String serialNumber;
  final String deviceName;
  final String deviceDescription;

  static const String path = 'preparing';

  @override
  State<AddDevicePreparingScreen> createState() => _AddDevicePreparingScreenState();
}

class _AddDevicePreparingScreenState extends State<AddDevicePreparingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        context.pushReplacement(
          '/create/pairing',
          extra: {
            'serialNumber': widget.serialNumber,
            'deviceName': widget.deviceName,
            'deviceDescription': widget.deviceDescription,
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      color: ColorValues.whiteColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              local.preparingNextStep,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: ColorValues.green500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const BlinkingDotIndicator(),
          ],
        ),
      ),
    );
  }
}
