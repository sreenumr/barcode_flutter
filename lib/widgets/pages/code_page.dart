import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_app/main.dart';
import 'package:provider/provider.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key, required this.title});

  final String title;

  @override
  State<CodePage> createState() => CodePageState();
}

class CodePageState extends State<CodePage> {
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
          children: [
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
                            for (final code in appState.splitCodes) ...[
                              // if (codeData.length <= 23648)
                              QrImageView(
                                  data: code,
                                  version: QrVersions.auto,
                                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                                  size: 50)
                            ]
                          ],
                        )),
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
