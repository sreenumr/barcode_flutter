import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.title});

  final String title;

  @override
  State<ScanPage> createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Set<Barcode> result = {};
  Set<String?> resultCodeSet = {};
  String barcodeOutput = "";
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              overlay: QrScannerOverlayShape(
                // Configure the overlay to look nice
                borderRadius: 10,
                borderWidth: 5,
                borderColor: Colors.white,
              ),
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              // ignore: unnecessary_null_comparison
              child: (result != null)
                  ? ListView(
                      children: [
                        for (final res in resultCodeSet) Text("Code $res")
                      ],
                    )
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // result = scanData;
        result.add(scanData);
        result.add(scanData);
        resultCodeSet.add(scanData.code);
        print(scanData.code);
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
