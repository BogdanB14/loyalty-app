import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/scan_results_sheet.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final _controller = MobileScannerController();
  bool _hasDetected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasDetected) return;
    final barcode = capture.barcodes.firstOrNull;
    final qrUrl = barcode?.rawValue;
    if (qrUrl == null) return;

    // Accept Serbian fiscal receipt QR codes
    if (qrUrl.contains('suf.purs.gov.rs') || qrUrl.contains('suf.purs')) {
      _hasDetected = true;
      _controller.stop();
      _showResults(qrUrl);
    }
  }

  void _showResults(String qrUrl) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ScanResultsSheet(
        qrUrl: qrUrl,
        points: 120,
        venueName: 'Kafana Zlatni Bor',
      ),
    ).then((_) {
      _hasDetected = false;
      _controller.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Receipt'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIconsRegular.lightning),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Overlay
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(
                    children: [
                      _corner(top: 0, left: 0),
                      _corner(top: 0, right: 0, flipH: true),
                      _corner(bottom: 0, left: 0, flipV: true),
                      _corner(bottom: 0, right: 0, flipH: true, flipV: true),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Point camera at fiscal receipt QR code',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner({
    double? top,
    double? bottom,
    double? left,
    double? right,
    bool flipH = false,
    bool flipV = false,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Transform.scale(
        scaleX: flipH ? -1 : 1,
        scaleY: flipV ? -1 : 1,
        child: Container(
          width: 24,
          height: 24,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primary, width: 3),
              left: BorderSide(color: AppColors.primary, width: 3),
            ),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(6)),
          ),
        ),
      ),
    );
  }
}
