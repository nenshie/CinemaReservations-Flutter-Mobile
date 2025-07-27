import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;
  bool _isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    }
    _qrController?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Scan QR Code',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // QR scanner
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.green,
              borderRadius: 10,
              borderLength: 40,
              borderWidth: 12,
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          // Show loading indicator while processing
          if (_isProcessing)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _simulateQRScan(String code) async {
    if (!mounted || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(Duration(seconds: 1));

    print("Scanned QR Code: $code");

    setState(() {
      _isProcessing = false;
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });

    // Listen for scanned data stream
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && !scanData.code!.isEmpty) {
        _qrController?.pauseCamera();
        await _simulateQRScan(scanData.code!);
        _qrController?.resumeCamera();
      }
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}
