import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RivesAnimation extends StatefulWidget {
  const RivesAnimation({super.key, required this.asset, required this.width, required this.height});

  final String asset;
  final double width;
  final double height;

  @override
  State<RivesAnimation> createState() => _RivesAnimationState();
}

class _RivesAnimationState extends State<RivesAnimation> {
  late File file;
  late RiveWidgetController _controller;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    file = (await File.asset(widget.asset, riveFactory: Factory.rive))!;
    _controller = RiveWidgetController(file);
    setState(() {
      isInitialized = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    file.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveWidget(controller: _controller, fit: Fit.cover),
    );
  }
}
