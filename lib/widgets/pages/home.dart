import 'package:barcode_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './code_page.dart';
import '../../config/constants.dart' as Constants;

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (appState.selectedFileName.isNotEmpty)
              Text(appState.selectedFileName,
                  style: const TextStyle(
                    fontSize: Constants.fontMedium,
                  )),
            if (appState.selectedFileName.isNotEmpty)
              (ElevatedButton.icon(
                  onPressed: () {
                    appState.generateQRCode();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CodePage(
                                  title: "Code Page",
                                )));
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text(
                    "Generate Code",
                  )))
            else
              const Text(
                "Open a file to be converted to QR code",
                style: TextStyle(
                  fontSize: Constants.fontMedium,
                ),
              ),
          ]
              .map((widget) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: widget,
                  ))
              .toList(),
        ),
      ),
      floatingActionButton:
          // Row(
          // children: [
          // FloatingActionButton.extended(
          //     onPressed: () => {appState.pickFile()},
          //     icon: const Icon(Icons.qr_code_scanner),
          //     label: const Text("Generate Code")),
          FloatingActionButton.extended(
              onPressed: () => {appState.pickFile()},
              icon: const Icon(Icons.file_upload),
              label: const Text("Open File")),
      // ],
    );
    // );
  }
}
