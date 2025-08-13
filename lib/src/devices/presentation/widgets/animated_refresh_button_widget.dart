import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

class AnimatedRefreshButton extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final bool loading;
  const AnimatedRefreshButton({super.key, required this.onRefresh, required this.loading});
  @override
  State<AnimatedRefreshButton> createState() => _AnimatedRefreshButtonState();
}

class _AnimatedRefreshButtonState extends State<AnimatedRefreshButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void didUpdateWidget(covariant AnimatedRefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading) {
      _controller.repeat();
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.loading ? null : () async => widget.onRefresh(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: ColorValues.iotMainColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: RotationTransition(
          turns: Tween<double>(begin: 0, end: 1).animate(_controller),
          child: Icon(Icons.refresh, color: ColorValues.iotMainColor),
        ),
      ),
    );
  }
}
