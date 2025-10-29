import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import '../../../../../pkg.dart';

class SerialNumberScannerScreen extends StatefulWidget {
  const SerialNumberScannerScreen({super.key});

  static const String path = 'scan';

  @override
  State<SerialNumberScannerScreen> createState() => _SerialNumberScannerScreenState();
}

class _SerialNumberScannerScreenState extends State<SerialNumberScannerScreen> {
  bool isFlashOn = false;
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    autoZoom: true,
  );
  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Input Your Device Serial',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  Barcode? _barcode;
  void _handleBarcode(BarcodeCapture barcodes) async {
    if (mounted) {
      _barcode = barcodes.barcodes.first;
      final displayValue = _barcode?.displayValue;
      if (displayValue == null) {
        Toast().showErrorToast(
          context: context,
          title: 'Error',
          description: 'No display value found in the scanned barcode.',
        );
        return;
      }
      if (!displayValue.contains('EHT-')) {
        Toast().showErrorToast(
          context: context,
          title: 'Error',
          description: 'Invalid barcode. Please scan a valid device serial number barcode.',
        );
        return;
      }
      await showDialog(
        context: context,
        builder: (context) {
          return infoDialog(
            context: context,
            title: 'Scanned!',
            content: 'Serial Number: $displayValue',
            onConfirm: () => context.pushReplacement('/create/form', extra: {'serialNumber': displayValue}),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Stack(
      children: [
        MobileScanner(onDetect: _handleBarcode, controller: _controller),
        Scaffold(
          backgroundColor: Colors.transparent,
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
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            title: Text(
              local.scanQrCode,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: ColorValues.whiteColor, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 40.h),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.toggleTorch();
                        isFlashOn = !isFlashOn;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 20, top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(30)),
                      child: isFlashOn
                          ? const VectorGraphic(
                              loader: AssetBytesLoader(IconAssets.flashlightOn),
                              width: 40,
                              height: 40,
                              colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                            )
                          : const VectorGraphic(
                              loader: AssetBytesLoader(IconAssets.flashlightOff),
                              width: 40,
                              height: 40,
                              colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                            ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(31), color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Scan the QR code in the device body.',
                            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: ColorValues.whiteColor),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset(ImageAssets.scanTutorial, width: 103.w, height: 83.h),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => context.pushReplacement('/create/form', extra: {'serialNumber': ''}),
                    child: Container(
                      width: widthQuery(context) * 0.7,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _barcodePreview(_barcode),
                          SizedBox(width: 8.w),
                          const VectorGraphic(
                            loader: AssetBytesLoader(IconAssets.moreInfo),
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(ColorValues.whiteColor, BlendMode.srcIn),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
