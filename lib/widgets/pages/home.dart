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
                    appState.captureAndSharePng();
                  },
                  child: const Text("Generate Code"))),
            if (appState.QrData.isNotEmpty)
              RepaintBoundary(
                  key: appState.globalKey,
                  child: QrImageView(
                    data: appState.QrData,
                    version: QrVersions.max,
                    size: 200,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          'Uh oh! Something went wrong...',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ))
          ],
        ),
      ),
    );
  }
}
