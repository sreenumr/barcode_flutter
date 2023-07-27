import 'package:barcode_app/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './code_page.dart';

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
                  style: const TextStyle(fontWeight: FontWeight.bold)),
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {appState.pickFile()},
          icon: const Icon(Icons.file_upload),
          label: const Text("Open File")),
    );
  }
}
