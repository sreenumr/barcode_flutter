import 'package:barcode_app/main.dart';
import 'package:barcode_app/widgets/FileDialog.dart';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import '../../config/constants.dart' as constants;

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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: SizedBox(
                  // width: 300.0,
                  // height: 300.0,

                  child: Stack(
                children: [
                  QrCamera(
                    fit: BoxFit.fill,
                    notStartedBuilder: (context) =>
                        const LinearProgressIndicator(),
                    qrCodeCallback: (code) {
                      // ...;
                      // log(code!);
                      processQr(code!);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 5, color: Colors.white),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)))),
                  ),
                ],
              ))),
          Expanded(
            flex: 1,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (totalChunks != 0)
                      Text(
                        "Total Scanned = ${resultCodeSet.length}/$totalChunks",
                        style: const TextStyle(
                            color: constants.themeColorSecondary),
                      )
                    else
                      const Text("Scan QR codes"),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            clearScanned();
                            appState.resultCodeSet.clear();
                          },
                          child: const Text("Reset")),
                    )
                  ],
                ),
                if (resultCodeSet.length == totalChunks && (totalChunks != 0))
                  ElevatedButton(
                      onPressed: () => showDialog<String>(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) =>
                              FileDialog(onOk: appState.decodeQRCodes)),
                      child: const Text("Click to generate file"))
              ],
            )),
          )
        ],
      ),
    );
  }

  void clearScanned() {
    setState(() {
      totalChunks = 0;
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
      // print("Total Chunks ${totalChunks}");

      // totalChunks = resultCodeSet.last.substring(resultCodeSet.last.length - 1);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
