import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class AddDevicePairingScreen extends StatelessWidget {
  const AddDevicePairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 8.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wifi, size: 100.sp, color: ColorValues.iotMainColor),
              const SizedBox(height: 10),
              Text(
                local.readyToPair,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                local.addStep1,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                local.addStep2,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                local.addStep3,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                local.addStep4,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
