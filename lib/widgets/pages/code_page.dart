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
          child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          if (appState.isLoading == true)
            const Center(child: CircularProgressIndicator()),
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
                child: Container(
                  color: Colors.white,
                  child: GridView.count(
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    primary: false,
                    children: <Widget>[
                      for (final code in appState.splitCodes) ...[
                        Center(
                            child: QrImageView(
                                padding: EdgeInsets.all(10.0),
                                data: code,
                                version: QrVersions.auto,
                                errorCorrectionLevel: QrErrorCorrectLevel.L,
                                size: 300))
                      ]
                    ],
                  ),
                )),
          if (appState.renderError == false)
            ElevatedButton(
                onPressed: appState.captureAndSharePng,
                child: const Text("Save QR Code"))
        ],
      )),
    );
  }
}
