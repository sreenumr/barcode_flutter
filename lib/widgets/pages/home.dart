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
                        fontSize: Constants.fontMedium, color: Colors.black))
              else
                const Text(
                  "Open a file to be converted to QR code",
                  style: TextStyle(
                      fontSize: Constants.fontMedium, color: Colors.black),
                ),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    appState.pickFile();
                  },
                  icon: const Icon(Icons.file_open),
                  label: const Text(
                    "Open File",
                  ),
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
        floatingActionButton: appState.selectedFileName.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CodePage(
                                title: "Code Page",
                              )));
                  appState.generateQRCode();
                },
                icon: const Icon(Icons.qr_code),
                label: const Text("Generate QR code"))
            : null);
  }
}
