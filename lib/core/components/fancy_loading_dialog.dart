import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';

class FancyLoadingDialog extends StatefulWidget {
  final String title;
  const FancyLoadingDialog({super.key, required this.title});

  @override
  State<FancyLoadingDialog> createState() => _FancyLoadingDialogState();
}

class _FancyLoadingDialogState extends State<FancyLoadingDialog> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnim;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    // Bouncy scale — naik turun organik
    _bounceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);

    _scaleAnim = Tween<double>(begin: 0.88, end: 1.12).animate(CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut));

    // Rotasi slow untuk outer ring
    _rotateController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();

    // Pulse opacity untuk lingkaran latar
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.15, end: 0.35).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAnimatedIcon(),
            const SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(height: 6),
            Text(
              local.thisMayTakeAMoment,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Theme.brightnessOf(context) == Brightness.dark ? ColorValues.neutral100 : ColorValues.neutral600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran pulse di belakang
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (_, __) => Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(shape: BoxShape.circle, color: ColorValues.green500.withOpacity(_pulseAnim.value)),
            ),
          ),

          // Outer ring berputar pelan (dashed-like via arc)
          AnimatedBuilder(
            animation: _rotateController,
            builder: (_, __) => Transform.rotate(
              angle: _rotateController.value * 2 * pi,
              child: CustomPaint(
                size: const Size(72, 72),
                painter: _DashedRingPainter(color: ColorValues.green500.withOpacity(0.5)),
              ),
            ),
          ),

          // Icon dengan bounce
          AnimatedBuilder(
            animation: _scaleAnim,
            builder: (_, __) => Transform.scale(
              scale: _scaleAnim.value,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: ColorValues.green500),
                child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Painter untuk outer ring bergaris-putus
class _DashedRingPainter extends CustomPainter {
  final Color color;
  const _DashedRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const dashCount = 10;
    const dashAngle = 0.22; // panjang tiap dash (radian)
    const gapAngle = (2 * pi / dashCount) - dashAngle;

    double angle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), angle, dashAngle, false, paint);
      angle += dashAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) => old.color != color;
}
