import 'dart:developer';

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (appState.renderError)
                const Text(
                  "QR Code generation failed. QR code limit reached",
                  style: TextStyle(
                      fontSize: Constants.fontMedium, color: Colors.redAccent),
                ),
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
              if (appState.isLoading)
                Center(
                  child: SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red)),
                  ),
                )
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
                onPressed: () async {
                  // _onButtonPressed
                  await appState.generateQRCode();
                  if (appState.splitCodes.length > 6) {
                    log("Print Error");
                  } else {
                    log("No Error");
                    if (!mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const CodePage(title: "Code Page")));
                    // Navigator.of(context).push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const CodePage(
                    //               title: "Code Page",
                    //             )));
                  }
                }

                // } else {
                //   appState.renderError = true;
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text('QR Code generation Failed'),
                //   ));
                // }
                ,
                icon: const Icon(Icons.qr_code),
                label: const Text("Generate QR code"))
            : null);
  }
}
