import 'package:flutter/material.dart';

class RollingNumberText extends StatefulWidget {
  final double value;
  final TextStyle? style;
  final Duration duration;
  final int decimalCount;

  const RollingNumberText({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 500),
    this.decimalCount = 2,
  });

  @override
  State<RollingNumberText> createState() => _RollingNumberTextState();
}

class _RollingNumberTextState extends State<RollingNumberText> with SingleTickerProviderStateMixin {
  late double _displayedValue;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isIncreasing = true;

  @override
  void initState() {
    super.initState();
    _displayedValue = widget.value;

    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void didUpdateWidget(RollingNumberText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _isIncreasing = widget.value > oldWidget.value;
      _animateValueChange(oldWidget.value, widget.value);
    }
  }

  void _animateValueChange(double from, double to) {
    _controller.reset();
    _animation =
        Tween<double>(begin: from, end: to).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic))
          ..addListener(() {
            setState(() {
              _displayedValue = _animation.value;
            });
          });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDigit(double value, bool isIncreasing) {
    // Hitung digit dan progress (antara 0-1)
    final int currentDigit = value.floor() % 10;
    final double progress = value - value.floor();

    // arah animasi — kalau turun, geser ke bawah
    final double direction = isIncreasing ? -1.0 : 1.0;

    return ClipRect(
      child: Transform.translate(
        offset: Offset(0, progress * 40 * direction),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$currentDigit', style: widget.style),
            // Text('${(currentDigit + 1) % 10}', style: widget.style),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = _displayedValue.toStringAsFixed(widget.decimalCount);
    final characters = text.split('');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: characters.map((char) {
        if (char == '.') {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text('.', style: widget.style),
          );
        }
        final parsed = double.tryParse(char);
        if (parsed == null) {
          return Text(char, style: widget.style);
        }
        return _buildDigit(parsed, _isIncreasing);
      }).toList(),
    );
  }
}
