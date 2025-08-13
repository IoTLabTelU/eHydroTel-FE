import 'package:flutter/material.dart';
import 'package:hydro_iot/utils/spinner_paint.dart';
import 'package:hydro_iot/utils/utils.dart';

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
    _fakeDoWork();
  }

  Future<void> _fakeDoWork() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    Navigator.of(context).pop();
    Toast().showSuccessToast(context: context, title: 'Export started.', description: ' You\'ll be notified when it\'s ready.');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  return CustomPaint(painter: SpinnerPainter(_controller.value, ColorValues.iotMainColor));
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            const Text('This may take a moment...', style: TextStyle(color: ColorValues.neutral600)),
          ],
        ),
      ),
    );
  }
}
