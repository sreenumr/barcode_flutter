import 'dart:io';
import 'package:barcode_app/main.dart';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key, required this.title});

  final String title;

  @override
  State<ScanPage> createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Set<Barcode> result = {};
  String barcodeOutput = "";
  QRViewController? controller;
  int totalChunksScanned = 0;
  int totalChunks = 0;
  Set<String?> resultCodeSet = {};
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    resultCodeSet = appState.resultCodeSet;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 5,
              child: SizedBox(
                width: 300.0,
                height: 300.0,
                child: QrCamera(
                  qrCodeCallback: (code) {
                    // ...;
                    log(code!);
                    processQr(code);
                  },
                ),
              )
              // child: QRView(
              //   overlay: QrScannerOverlayShape(
              //     // Configure the overlay to look nice
              //     borderRadius: 10,
              //     borderWidth: 5,
              //     borderColor: Colors.white,
              //   ),
              //   key: qrKey,
              //   onQRViewCreated: _onQRViewCreated,
              // ),
              ),
          Expanded(
            flex: 1,
            child: Center(
              // ignore: unnecessary_null_comparison
              child: (result != null)
                  ? Container(
                      child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                                "Total Scanned = ${resultCodeSet.length}/$totalChunks")
                          ],
                        )
                      ],
                    ))
                  : const Text('Scan a code'),
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
        // if(scanData.code.length)
        resultCodeSet.add(scanData.code);
        if (resultCodeSet.isNotEmpty) {
          totalChunks = int.parse(
              resultCodeSet.first!.substring(resultCodeSet.first!.length - 1));
        }

        log(scanData.code!);

        // totalChunks = resultCodeSet.last.substring(resultCodeSet.last.length - 1);
      });
    });
  }

  void processQr(String code) {
    setState(() {
      // result = scanData;
      // result.add(scanData);
      // result.add(scanData);
      // if(scanData.code.length)
      resultCodeSet.add(code);
      if (resultCodeSet.isNotEmpty) {
        totalChunks = int.parse(
            resultCodeSet.first!.substring(resultCodeSet.first!.length - 1));
      }
      print("Total Chunks ${totalChunks}");

      // totalChunks = resultCodeSet.last.substring(resultCodeSet.last.length - 1);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
