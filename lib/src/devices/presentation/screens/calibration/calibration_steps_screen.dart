import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:vector_graphics/vector_graphics.dart';
import '../../../../../pkg.dart';
import '../../widgets/cardlike_container_widget.dart';
import 'calibration_steps.dart';

enum CalibrationStepState { ready, running, done, applying }

class CalibrationsStepsScreen extends StatefulWidget {
  static const String path = 'calibration-steps';
  const CalibrationsStepsScreen({super.key});

  @override
  State<CalibrationsStepsScreen> createState() => _CalibrationsStepsScreenState();
}

class _CalibrationsStepsScreenState extends State<CalibrationsStepsScreen> {
  int _currentStep = 0;
  CalibrationStepState _stepState = CalibrationStepState.ready;
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  // ─── Helpers ────────────────────────────────────────────────────────────────

  Map<String, dynamic> get _step => calibrationSteps[_currentStep];
  bool get _isLastStep => _currentStep == calibrationSteps.length - 1;

  /// True jika step berikutnya beda tipe (pH→PPM) atau ini step terakhir
  bool get _isLastOfType {
    if (_isLastStep) return true;
    return calibrationSteps[_currentStep + 1]['type'] != _step['type'];
  }

  /// Durasi kalibrasi dalam menit — pH = 30 menit, PPM = 10 menit
  int get _durationMinutes => _step['type'] == 'pH' ? 1 : 1;

  String get _nextStepLabel {
    if (_isLastStep) return '';
    final next = calibrationSteps[_currentStep + 1];
    return '${next['type']} ${next['calibration']}';
  }

  String get _formattedTime {
    final m = _remainingSeconds ~/ 60;
    final s = _remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')} remaining';
  }

  // ─── Timer ──────────────────────────────────────────────────────────────────

  void _startTimer() {
    _remainingSeconds = _durationMinutes * 2;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        setState(() {
          _remainingSeconds = 0;
          _stepState = CalibrationStepState.done;
        });
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  // ─── Actions ────────────────────────────────────────────────────────────────

  Future<void> _beginCalibration() async {
    setState(() => _isLoading = true);
    try {
      // TODO: panggil endpoint BE — start calibration step
      // await ref.read(calibrationProvider.notifier).startStep(
      //   type: _step['type'], value: _step['calibration'],
      // );
      _startTimer();
      setState(() => _stepState = CalibrationStepState.running);
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _applyCalibration() async {
    setState(() => _isLoading = true);
    try {
      // TODO: panggil endpoint BE — apply calibration untuk tipe ini
      // await ref.read(calibrationProvider.notifier).applyCalibration(type: _step['type']);
      setState(() => _stepState = CalibrationStepState.applying);
      _showApplyBottomSheet();
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _continueToNext() async {
    if (_isLastStep) {
      // TODO: navigasi ke success screen atau pop
      context.pop();
      return;
    }
    setState(() {
      _currentStep++;
      _stepState = CalibrationStepState.ready;
      _remainingSeconds = 0;
      _scrollController.animateTo(
        (_currentStep * (widthQuery(context) * 0.2 + 12)),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: ColorValues.danger600));
  }

  // ─── Bottom Sheet: Apply Calibration ────────────────────────────────────────

  void _showApplyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: ColorValues.whiteColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => _ApplyCalibrationSheet(
        type: _step['type'] as String,
        nextStepLabel: _nextStepLabel,
        onContinue: () {
          Navigator.of(ctx).pop();
          _continueToNext();
        },
        image: _step['type'] == 'pH' ? ImageAssets.applypHCalibration : ImageAssets.applyPPMCalibration,
      ),
    );
  }

  // ─── Build ──────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: ColorValues.neutral50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          decoration: BoxDecoration(
            color: ColorValues.whiteColor,
            shape: BoxShape.circle,
            border: Border.all(color: ColorValues.neutral200),
          ),
          margin: EdgeInsets.only(left: 16.w),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorValues.blackColor),
            onPressed: () => context.pop(),
          ),
        ),
        title: Text(local.deviceCalibration, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            children: [
              _buildStepIndicator(),
              const SizedBox(height: 16),
              _buildTitleCard(),
              const SizedBox(height: 16),
              _buildImageCard(),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: _buildButton()),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Step Indicator ─────────────────────────────────────────────────────────

  Widget _buildStepIndicator() {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Row(children: [for (int i = 0; i < calibrationSteps.length; i++) _buildStepChip(i)]),
      ),
    );
  }

  Widget _buildStepChip(int index) {
    final step = calibrationSteps[index];
    final isActive = index == _currentStep;
    final isDone = index < _currentStep;
    final isFinished = isDone || (isActive && (_stepState == CalibrationStepState.done || _stepState == CalibrationStepState.applying));

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      width: widthQuery(context) * 0.2,
      decoration: BoxDecoration(
        color: isActive || isFinished ? ColorValues.whiteColor : ColorValues.neutral100,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isActive && (_stepState == CalibrationStepState.ready || _stepState == CalibrationStepState.running)
              ? ColorValues.blueProgress
              : isFinished
              ? ColorValues.success600
              : ColorValues.neutral100,
          width: isActive || isFinished ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VectorGraphic(loader: AssetBytesLoader(step['icon'] as String), width: 18, height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              step['type'] as String,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: ColorValues.blueProgress),
            ),
          ),
          Text(
            '${step['calibration']}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: ColorValues.blackColor),
          ),
        ],
      ),
    );
  }

  // ─── Title Card ─────────────────────────────────────────────────────────────

  Widget _buildTitleCard() {
    final type = _step['type'] as String;
    final value = _step['calibration'];
    final local = AppLocalizations.of(context)!;

    final (title, subtitle) = switch (_stepState) {
      CalibrationStepState.ready => ('Calibrate $type $value', local.placeSensor(type, value.toDouble())),
      CalibrationStepState.running => ('Calibrate $type $value', 'Calibration in progress'),
      CalibrationStepState.done || CalibrationStepState.applying => (
        '$type $value Calibrated',
        _isLastOfType && !_isLastStep ? 'Ready to apply calibration' : 'Ready for the next step',
      ),
    };

    return CardLikeContainerWidget(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    if (_stepState == CalibrationStepState.done || _stepState == CalibrationStepState.applying) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.check_circle, color: ColorValues.green500, size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Image Card ─────────────────────────────────────────────────────────────

  Widget _buildImageCard() {
    final local = AppLocalizations.of(context)!;
    final type = _step['type'] as String;
    final value = _step['calibration'];

    // Gambar: done/applying pakai gambar rinse, lainnya pakai gambar sensor di larutan
    final isDoneState = _stepState == CalibrationStepState.done || _stepState == CalibrationStepState.applying;

    final imageAsset = isDoneState
        ? type == 'pH'
              ? ImageAssets.pHRinse
              : ImageAssets
                    .ppmRinse // gambar bilas sensor
        : _getCalibrationImage(type, value); // gambar sensor di larutan_isLastOfType
    final caption = isDoneState
        ? !_isLastOfType
              ? 'Rinse the sensor with clean water before proceeding to the next calibration step'
              : 'Rinse the sensor with clean water and return it to its holder'
        : local.keepTheSensorSubmerged;

    return CardLikeContainerWidget(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: heightQuery(context) * 0.24,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(24)),
              child: Image.asset(imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: widthQuery(context) * 0.6,
              child: Text(
                caption,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCalibrationImage(String type, dynamic value) {
    if (type == 'pH') {
      return value == 7 ? ImageAssets.pH7 : ImageAssets.pH4;
    }
    return switch (value) {
      500 => ImageAssets.ppm500,
      1000 => ImageAssets.ppm1000,
      1382 => ImageAssets.ppm1382,
      _ => ImageAssets.ppm1000,
    };
  }

  // ─── Button ─────────────────────────────────────────────────────────────────

  Widget _buildButton() {
    return switch (_stepState) {
      CalibrationStepState.ready => primaryButton(
        text: 'Begin $_durationMinutes-Minute Calibration',
        onPressed: _isLoading ? () {} : _beginCalibration,
        context: context,
      ),

      CalibrationStepState.running => secondaryButton(
        text: _formattedTime,
        onPressed: () {}, // disabled — tidak bisa ditekan
        context: context,
        color: ColorValues.neutral200,
      ),

      CalibrationStepState.done => primaryButton(
        text: _isLastStep
            ? 'Apply ${_step['type']} Calibration'
            : _isLastOfType
            ? 'Apply ${_step['type']} Calibration'
            : 'Continue to $_nextStepLabel',
        onPressed: _isLoading
            ? () {}
            : _isLastOfType
            ? _applyCalibration
            : _continueToNext,
        context: context,
      ),

      CalibrationStepState.applying => primaryButton(
        text: _isLastStep
            ? 'Apply ${_step['type']} Calibration'
            : _isLastOfType
            ? 'Apply ${_step['type']} Calibration'
            : 'Continue to $_nextStepLabel',
        onPressed: _isLoading
            ? () {}
            : _isLastOfType
            ? _applyCalibration
            : _continueToNext,
        context: context,
      ),
    };
  }
}

// ─── Bottom Sheet: Apply Calibration ──────────────────────────────────────────

class _ApplyCalibrationSheet extends StatelessWidget {
  final String type;
  final String nextStepLabel;
  final VoidCallback onContinue;
  final String image;

  const _ApplyCalibrationSheet({required this.type, required this.nextStepLabel, required this.onContinue, required this.image});

  @override
  Widget build(BuildContext context) {
    final isLast = nextStepLabel.isEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 32 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              const SizedBox(width: 50), // spacer untuk buat title tetap di tengah meskipun ada tombol close di kanan
              Text(
                '$type Calibration\nApplied',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, decorationThickness: 2, color: ColorValues.blackColor),
              ),
              GestureDetector(
                onTap: () => context.pop(),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorValues.whiteColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: ColorValues.neutral200),
                    ),
                    child: const VectorGraphic(loader: AssetBytesLoader(IconAssets.close), width: 18, height: 18),
                  ),
                ),
              ),
            ],
          ),

          // Close button
          const SizedBox(height: 20),

          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: Image.asset(image, fit: BoxFit.cover),
          ),
          const SizedBox(height: 16),

          Text(
            isLast ? 'Your device calibration is now calibrated and ready to use' : 'Your device is ready for $nextStepLabel calibration',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorValues.blackColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: primaryButton(text: isLast ? 'Finish' : 'Continue to $nextStepLabel', onPressed: onContinue, context: context),
          ),
        ],
      ),
    );
  }
}
