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
import 'barcode_navigator.dart';

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
          home: const BarcodeNavigator()
          // home: const MyHomePage(
          //   title: "Home",
          // ),
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
    var binaryData = await readFileAsBinary(selectedFilePath);
    var byteData = await readFileAsBytes(selectedFilePath);

    // var unicode = utf8.encode(byteData);
    var GZIPcompressed = gzip.encode(byteData);
    var ZLIBcompressed = zlib.encode(byteData);

    // compressedData =
    // var unicode = utf8.encode(binaryData);

    // var base64Data = base64Encode(byteData);
    // var base64Unicode = utf8.encode(base64Data);
    // var base64UnicodeCompressed = zlib.encode(base64Unicode);
    // var GZIPcompressed = gzip.encode(unicode);
    // var ZLIBcompressed = zlib.encode(unicode);

    // var base64Compressed = gzip.encode(base64Data);
    // var BASE64ZLIBcompressed = zlib.encode(base64);
    // var compressed = bvm.print('Original ${binaryData.length} bytes');

    // print('Binary $binaryData');
    // print('Unicode $unicode');
    // print('Base64 $base64');
    // print('Unicode  ${unicode.length} bytes');
    // print('Base64  ${base64Data.length} bytes');
    // print('base64Unicode  ${base64Unicode.length} bytes');
    // print('base64UnicodeCompressed  ${base64UnicodeCompressed.length} bytes');

    print('Bytes  ${byteData.length} bytes');
    print('GZIPcompressed ${GZIPcompressed.length} bytes');
    print('ZLIBcompressed ${ZLIBcompressed.length} bytes');

    QrData = ZLIBcompressed.join("");

    final barcode = Barcode.qrCode();
    // final png = svg.to
    final svg = barcode.toSvg(ZLIBcompressed.join(""), width: 100, height: 100);
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();

    await File('/storage/emulated/0/flutter_qr_image.svg').writeAsString(svg);
    notifyListeners();
  }

  Future<void> captureAndSharePng() async {
    try {
      RenderRepaintBoundary? boundary = globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary?;
      var image = await boundary!.toImage();
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final file =
          await File('/storage/emulated/0/flutter_qr_image.png').create();
      await file.writeAsBytes(pngBytes);

      // await Share.file(_dataString, '$_dataString.png', pngBytes, 'image/png');
    } catch (e) {
      print(e.toString());
    }
  }
}
