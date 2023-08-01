import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_app/main.dart';
import 'package:provider/provider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key, required this.title});

  final String title;

  @override
  State<CodePage> createState() => CodePageState();
}

class CodePageState extends State<CodePage> with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
        .addListener(() {
      setState(() {});
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    tabController.dispose();
    animationController.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  final currentPageNotifier = ValueNotifier<int>(0);
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: appState.splitCodes.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                        flex: 6,
                        child: RepaintBoundary(
                            key: appState.globalKey,
                            child: PageView.builder(
                                itemCount: appState.splitCodes.length,
                                controller: PageController(viewportFraction: 1),
                                onPageChanged: (int num) {
                                  log("Page number : $num");
                                  setState(() {
                                    currentPageNotifier.value = num;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                                // i
                                itemBuilder: (context, index) {
                                  return Center(
                                      child: QrImageView(
                                          padding: const EdgeInsets.all(10.0),
                                          data: appState.splitCodes[index],
                                          version: QrVersions.auto,
                                          errorCorrectionLevel:
                                              QrErrorCorrectLevel.L,
                                          size: 300));
                                }))),
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CirclePageIndicator(
                          itemCount: appState.splitCodes.length,
                          currentPageNotifier: currentPageNotifier,
                        ),
                      ),
                    ),
                    // if (appState.renderError == false)
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
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    value: animationController.value,
                    backgroundColor: Colors.white,
                    valueColor: animationController.drive(
                        ColorTween(begin: Colors.blueAccent, end: Colors.red)),
                  )),
        ));
  }
}
