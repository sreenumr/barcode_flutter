import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'widgets/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode/barcode.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const MyHomePage(
          title: "Home",
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedFileName = "";
  var selectedFilePath = "";
  var QrData = "";
  GlobalKey globalKey = GlobalKey();

  void pickFile() async {
    try {
      // requestFilePermission();
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      print("RESULT CODE FOR FILE PICKING");
      print(result);
      if (result == null) return;

      selectedFileName = result.files.first.name;
      selectedFilePath = result.files.first.path!;
      // print(result.files.first.size);
      // print(result.files.first.path);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void generateQRCode() async {
    var byteData = await readFileAsBytes(selectedFilePath);
    QrData = byteData;
    // Create a DataMatrix barcode
    final dm = Barcode.qrCode();
    final svg = dm.toSvg(byteData, width: 200, height: 200);
    // Save the image
    // await Permission.storage.request();

    var status = await Permission.manageExternalStorage.request();
    var status1 = await Permission.storage.request();

    print("PERMISSION STATUSES");
    print(status);
    print(status1);

    await File('/storage/emulated/0/flutter_qr_image.svg').writeAsString(svg);
    // _captureAndSharePng();
    notifyListeners();
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary!.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final file =
          await File('//storage//emulated//0//flutter_qr_image.png').create();
      await file.writeAsBytes(pngBytes);

      // final channel = const MethodChannel('channel:me.alfian.share/share');
      // channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print("ERROR");
      print(e.toString());
    }
  }
}
