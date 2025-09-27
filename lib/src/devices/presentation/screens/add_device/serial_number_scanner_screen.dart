import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SerialNumberScannerScreen extends StatefulWidget {
  const SerialNumberScannerScreen({super.key, required this.barcode, required this.onDetect});

  static const String path = 'scan';

  final Barcode? barcode;
  final Function(BarcodeCapture)? onDetect;

  @override
  State<SerialNumberScannerScreen> createState() => _SerialNumberScannerScreenState();
}

class _SerialNumberScannerScreenState extends State<SerialNumberScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  Widget _barcodePreview(Barcode? value) {
    if (value == null) {
      return const Text(
        'Please Scan Serial Number Barcode',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          MobileScanner(onDetect: widget.onDetect, controller: _controller),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Expanded(child: Center(child: _barcodePreview(widget.barcode)))],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
