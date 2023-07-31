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

    final pageView = PageView(
      controller: PageController(initialPage: 1),
      children: [],
    );

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
              flex: 8,
              child: RepaintBoundary(
                  key: appState.globalKey,
                  child: PageView.builder(
                      itemCount: appState.splitCodes.length,
                      controller: PageController(viewportFraction: 1),
                      onPageChanged: (int num) => {changeIndex(num)},
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Center(
                            child: QrImageView(
                                padding: const EdgeInsets.all(10.0),
                                data: appState.splitCodes[index],
                                version: QrVersions.auto,
                                errorCorrectionLevel: QrErrorCorrectLevel.L,
                                size: 300));
                      })),
            ),
            Expanded(
              flex: 1,
              child: Wrap(children: [
                for (int i = 0; i < appState.splitCodes.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: ElevatedButton(
                        onPressed: () => {},
                        child: const Text(" "),
                      ),
                    ),
                  ),
              ]),
            ),
            if (appState.renderError == false)
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: appState.captureAndSharePng,
                      child: const Text("Save QR Code")),
                ),
              ),
          ],
        )));
  }

  void changeIndex(int num) {
    print("Page Number $num");
  }
}
