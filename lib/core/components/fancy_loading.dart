import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/utils/spinner_paint.dart';

import '../../res/res.dart';

class FancyLoading extends StatefulWidget {
  final String title;
  const FancyLoading({super.key, required this.title});
  @override
  State<FancyLoading> createState() => FancyLoadingState();
}

class FancyLoadingState extends State<FancyLoading> with SingleTickerProviderStateMixin {
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
    return Center(
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
                          const Color(0xFF360033),
                          const Color(0xFF0B8793),
                          const Color(0xFF360033),
                          const Color(0xFF0B8793),
                          const Color(0xFF360033),
                          const Color(0xFF0B8793),
                        ]),
                      ),
                      Icon(
                        Icons.cloud_sync,
                        color: ColorValues.iotMainColor,
                        size: 60 * 0.5, // icon setengah diameter spinner
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
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
    );
  }
}
