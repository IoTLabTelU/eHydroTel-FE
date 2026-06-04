import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

import '../../l10n/app_localizations.dart';

class NoConnectionScreen extends StatefulWidget {
  final VoidCallback onRetry;

  const NoConnectionScreen({super.key, required this.onRetry});

  static const String path = 'no-connection';

  @override
  State<NoConnectionScreen> createState() => _NoConnectionScreenState();
}

class _NoConnectionScreenState extends State<NoConnectionScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late AnimationController _retryController;

  late Animation<double> _floatAnim;
  late Animation<double> _pulseAnim;
  late Animation<double> _rippleAnim;
  late Animation<double> _retryScaleAnim;

  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.0).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _rippleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..repeat();

    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _rippleController, curve: Curves.easeOut));

    _retryController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));

    _retryScaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(CurvedAnimation(parent: _retryController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _rippleController.dispose();
    _retryController.dispose();
    super.dispose();
  }

  Future<void> _handleRetry() async {
    if (_isRetrying) return;
    setState(() => _isRetrying = true);

    await _retryController.forward();
    await _retryController.reverse();

    widget.onRetry();

    // Reset setelah 2 detik biar tidak bisa spam tap
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isRetrying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValues.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildIllustration(),
              const SizedBox(height: 48),
              _buildTexts(context),
              const Spacer(flex: 3),
              _buildRetryButton(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnim, _pulseAnim, _rippleAnim]),
      builder: (_, __) {
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ripple ring terluar
              Opacity(
                opacity: (1 - _rippleAnim.value) * 0.15,
                child: Transform.scale(
                  scale: 0.6 + (_rippleAnim.value * 0.8),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorValues.green500, width: 1.5),
                    ),
                  ),
                ),
              ),

              // Ripple ring tengah (offset phase)
              Opacity(
                opacity: (1 - ((_rippleAnim.value + 0.4) % 1.0)) * 0.2,
                child: Transform.scale(
                  scale: 0.4 + (((_rippleAnim.value + 0.4) % 1.0) * 0.6),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorValues.green500, width: 1.5),
                    ),
                  ),
                ),
              ),

              // Background circle soft
              Transform.scale(
                scale: _pulseAnim.value,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorValues.green500.withOpacity(0.08)),
                ),
              ),

              // Icon floating
              Transform.translate(
                offset: Offset(0, _floatAnim.value),
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: ColorValues.green500.withOpacity(0.12)),
                  child: Center(child: _buildSignalIcon()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignalIcon() {
    // Custom signal icon dengan bar yang "mati"
    return SizedBox(width: 40, height: 40, child: CustomPaint(painter: _SignalBarPainter()));
  }

  Widget _buildTexts(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          local.noConnectionTitle,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: ColorValues.blackColor,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          local.noConnectionMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, height: 1.6, color: ColorValues.neutral500, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _retryScaleAnim,
      builder: (_, child) => Transform.scale(scale: _retryScaleAnim.value, child: child),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: _isRetrying ? null : _handleRetry,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorValues.green500,
            foregroundColor: Colors.white,
            disabledBackgroundColor: ColorValues.green500.withOpacity(0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: _isRetrying
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(local.tryAgain, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.2)),
                  ],
                ),
        ),
      ),
    );
  }
}

// Custom painter untuk signal bars yang "mati"
class _SignalBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const activeColor = ColorValues.green500;
    const inactiveColor = ColorValues.neutral200;

    final activePaint = Paint()
      ..color = activeColor
      ..style = PaintingStyle.fill;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    final barWidth = size.width * 0.18;
    final gap = size.width * 0.07;
    final totalBars = 4;
    final totalWidth = (barWidth * totalBars) + (gap * (totalBars - 1));
    final startX = (size.width - totalWidth) / 2;
    final radius = const Radius.circular(3);

    for (int i = 0; i < totalBars; i++) {
      final barHeight = size.height * (0.25 + (i * 0.22));
      final x = startX + (i * (barWidth + gap));
      final y = size.height - barHeight;
      final rect = RRect.fromLTRBR(x, y, x + barWidth, size.height, radius);

      // Hanya bar pertama yang "aktif", sisanya mati
      canvas.drawRRect(rect, i == 0 ? activePaint : inactivePaint);
    }

    // Tanda X kecil di pojok kanan atas
    final xPaint = Paint()
      ..color = ColorValues.danger600
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const xSize = 7.0;
    const xOffset = Offset(3, 2);
    canvas.drawLine(Offset(size.width - xSize - xOffset.dx, xOffset.dy), Offset(size.width - xOffset.dx, xSize + xOffset.dy), xPaint);
    canvas.drawLine(Offset(size.width - xOffset.dx, xOffset.dy), Offset(size.width - xSize - xOffset.dx, xSize + xOffset.dy), xPaint);
  }

  @override
  bool shouldRepaint(_SignalBarPainter old) => false;
}
