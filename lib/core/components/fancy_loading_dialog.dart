import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/utils/spinner_paint.dart';

import '../../res/res.dart';

class FancyLoadingDialog extends StatefulWidget {
  final String title;
  const FancyLoadingDialog({super.key, required this.title});
  @override
  State<FancyLoadingDialog> createState() => FancyLoadingDialogState();
}

class FancyLoadingDialogState extends State<FancyLoadingDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return SizedBox(
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(60, 60),
                          painter: SpinnerPainter(_controller.value, [
                            ColorValues.green900,
                            ColorValues.green500,
                            ColorValues.green900,
                            ColorValues.green500,
                            ColorValues.green900,
                            ColorValues.green500,
                          ]),
                        ),
                        const Icon(
                          Icons.cloud_sync,
                          color: ColorValues.green500,
                          size: 60 * 0.5, // icon setengah diameter spinner
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              local.thisMayTakeAMoment,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.brightnessOf(context) == Brightness.dark ? ColorValues.neutral100 : ColorValues.neutral600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
