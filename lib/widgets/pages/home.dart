import 'package:barcode_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(appState.selectedFileName),
            ElevatedButton(
                onPressed: () {
                  appState.pickFile();
                },
                child: const Text("Browse")),
            if (appState.selectedFileName.isNotEmpty)
              (ElevatedButton(
                  onPressed: () {
                    appState.generateQRCode();
                  },
                  child: const Text("Generate Code"))),
            if (appState.QrData.isNotEmpty)
              Column(
                children: [
                  if (appState.isLoading == true)
                    const CircularProgressIndicator(),
                  if (appState.renderError)
                    Center(
                      child: Text(
                        appState.qrRenderErrorMsg,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    RepaintBoundary(
                        key: appState.globalKey,
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          children: <Widget>[
                            for (final codeData in appState.splitCodes) ...[
                              if (codeData.length <= 23648)
                                QrImageView.withQr(
                                    qr: appState.qrCode,
                                    version: QrVersions.auto,
                                    errorCorrectionLevel: QrErrorCorrectLevel.L,
                                    size: 100)
                              else
                                Text(codeData.length.toString())
                            ]
                          ],
                        )),
                  // QrImageView(
                  //   data: appState.QrData,
                  //   version: QrVersions.auto,
                  //   errorCorrectionLevel: QrErrorCorrectLevel.L,
                  //   size: 200,
                  //   errorStateBuilder: (cxt, err) {
                  //     return Center(
                  //       child: Text(
                  //         appState.qrRenderErrorMsg,
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     );
                  //   },
                  // )),
                  if (appState.renderError == false)
                    ElevatedButton(
                        onPressed: appState.captureAndSharePng,
                        child: const Text("Save QR Code"))
                ],
              )
          ],
        ),
      ),
    );
  }
}
