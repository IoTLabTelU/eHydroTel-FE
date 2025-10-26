import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';

class PillRangeThumbShape extends RangeSliderThumbShape {
  final double width;
  final double height;

  PillRangeThumbShape({this.width = 36, this.height = 22});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(width, height);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final Canvas canvas = context.canvas;

    final Rect thumbRect = Rect.fromCenter(center: center, width: width, height: height);

    final RRect thumbShape = RRect.fromRectAndRadius(thumbRect, Radius.circular(height / 2));

    // Glow / soft blur effect
    final Paint glowPaint = Paint()
      ..color = ColorValues.blueProgress.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Main thumb paint
    final Paint thumbPaint = Paint()
      ..color = ColorValues.blueProgress.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    // Draw glow behind
    canvas.drawRRect(thumbShape.inflate(6), glowPaint);

    // Draw pill
    canvas.drawRRect(thumbShape, thumbPaint);
  }
}
