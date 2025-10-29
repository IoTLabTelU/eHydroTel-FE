import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';

class BlinkingDotIndicator extends StatefulWidget {
  const BlinkingDotIndicator({super.key});

  @override
  State<BlinkingDotIndicator> createState() => _BlinkingDotIndicatorState();
}

class _BlinkingDotIndicatorState extends State<BlinkingDotIndicator> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _BlinkingDot(animation: _controller, interval: const Interval(0.0, 0.5), dotColor: ColorValues.green500),
        const SizedBox(width: 8),
        _BlinkingDot(animation: _controller, interval: const Interval(0.25, 0.75), dotColor: ColorValues.green500),
        const SizedBox(width: 8),
        _BlinkingDot(animation: _controller, interval: const Interval(0.5, 1.0), dotColor: ColorValues.green500),
      ],
    );
  }
}

class _BlinkingDot extends AnimatedWidget {
  const _BlinkingDot({required this.animation, required this.interval, required this.dotColor})
    : super(listenable: animation);

  final Animation<double> animation;
  final Interval interval;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    // Create a curved animation for a specific interval
    final curvedAnimation = CurvedAnimation(parent: animation, curve: interval);

    // Fade the dot in and out based on the animation's value
    final dotOpacity = Tween<double>(begin: 0.0, end: 1.0).evaluate(curvedAnimation);

    return Opacity(
      opacity: dotOpacity,
      child: SizedBox(
        width: 10,
        height: 10,
        child: DecoratedBox(
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
