import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_app/main.dart';
import 'package:provider/provider.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CodePage extends StatefulWidget {
  const CodePage({super.key, required this.title});

  final String title;

  @override
  State<CodePage> createState() => CodePageState();
}

class CodePageState extends State<CodePage> with TickerProviderStateMixin {
  late AnimationController animationController;
  final PageController pageController = PageController(
    viewportFraction: 1,
  );
  final GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addListener(() {
            setState(() {});
          });
    animationController.repeat();
  }

  @override
  void dispose() {
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
                      flex: 7,
                      child: RepaintBoundary(
                          key: appState.globalKey,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              color: Colors.white,
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                children: <Widget>[
                                  for (final code in appState.splitCodes) ...[
                                    Center(
                                        child: QrImageView(
                                            padding: const EdgeInsets.all(10.0),
                                            data: code,
                                            version: QrVersions.auto,
                                            errorCorrectionLevel:
                                                QrErrorCorrectLevel.L,
                                            size: 300))
                                  ]
                                ],
                              ),
                            ),
                          )),
                      // RepaintBoundary(
                      //     key: appState.globalKey,
                      //     child: Container(
                      //       color: Colors.white,
                      //       child: PageView.builder(
                      //           itemCount: appState.splitCodes.length,
                      //           controller: pageController,
                      //           onPageChanged: (int num) {
                      //             log("Page number : $num");
                      //             setState(() {
                      //               currentPageNotifier.value = num;
                      //             });
                      //           },
                      //           scrollDirection: Axis.horizontal,
                      //           // i
                      //           itemBuilder: (context, index) {
                      //             return Center(
                      //                 child: QrImageView(
                      //                     padding: const EdgeInsets.all(10.0),
                      //                     data: appState.splitCodes[index],
                      //                     version: QrVersions.auto,
                      //                     errorCorrectionLevel:
                      //                         QrErrorCorrectLevel.L,
                      //                     size: 300));
                      //           }),
                      //     ))
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: CirclePageIndicator(
                    //       itemCount: appState.splitCodes.length,
                    //       currentPageNotifier: currentPageNotifier,
                    //     ),
                    //   ),
                    // ),
                    // if (appState.renderError == false)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: () {
                              appState.captureAndSharePng();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('QR code saved'),
                              ));
                            },
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
