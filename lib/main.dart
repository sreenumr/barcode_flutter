import 'dart:convert';
import 'dart:ffi';
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
import 'package:qr/qr.dart';

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
  var selectedFile;
  var selectedFileName = "";
  var selectedFilePath = "";
  var QrData = "";
  var isLoading = false;
  var renderError = false;
  var qrRenderErrorMsg = "";
  var qrImage;
  var qrCode;
  List<String> splitCodes = [];
  List<QrCode> codes = [];

  GlobalKey globalKey = GlobalKey();

  void pickFile() async {
    try {
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
      await Permission.camera.request();
      // requestFilePermission();
      final result = await FilePicker.platform.pickFiles(allowMultiple: false);
      if (result == null) return;

      selectedFile = result.files.first;
      selectedFileName = result.files.first.name;
      selectedFilePath = result.files.first.path!;
      // print(result.files.first.size);
      // print(result.files.first.path);
      print("Extension = ${selectedFile.extension}");
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void generateQRCode() async {
    isLoading = true;

    var binaryData = await readFileAsBinary(selectedFilePath);
    // var selectedFileExt =
    var byteData = await readFileAsBytes(selectedFilePath);

    // var unicode = utf8.encode(byteData);
    var GZIPcompressedByteData = gzip.encode(byteData);
    var ZLIBcompressedByteData = zlib.encode(byteData);

    var unicode = utf8.encode(binaryData);
    var GZIPcompressedBinaryData = gzip.encode(unicode);
    var ZLIBcompressedBinaryData = zlib.encode(unicode);

    // compressedData =

    var base64Data = base64Encode(byteData);
    var base64Unicode = utf8.encode(base64Data);
    // var base64UnicodeCompressed = zlib.encode(base64Unicode);
    var GZIPcompressedBase64Data = gzip.encode(base64Unicode);
    var ZLIBcompressedBase64Data = zlib.encode(base64Unicode);

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

    // print('Bytes  ${byteData.length} bytes');
    // print('GZIPcompressed ${GZIPcompressedByteData.length} bytes');
    // print('ZLIBcompressed ${ZLIBcompressedByteData.length} bytes');
    // print('ZLIBcompressed ${ZLIBcompressedByteData} bytes');

    // print('Binary  ${unicode.length} bytes');
    // print('GZIPcompressedBinaryData ${GZIPcompressedBase64Data.length} bytes');
    // print('ZLIBcompressedBinaryData ${ZLIBcompressedBase64Data.length} bytes');

    // print('Base64  ${base64Data.length} bytes');
    // print('GZIPcompressedBase64Data ${GZIPcompressedBinaryData.length} bytes');
    // print('ZLIBcompressedBase64Data ${ZLIBcompressedBinaryData.length} bytes');

    try {
      final barcode = Barcode.qrCode(
          typeNumber: 40, errorCorrectLevel: BarcodeQRCorrectionLevel.low);
      QrData = ZLIBcompressedByteData.join("");
      // print("Length of QR data = ${QrData.length}");
      // final png = svg.to
      // QrData = "Happy Birthday to You";
      int chunkSize = 2953;
      print(chunkSize);
      splitCodes = await splitWithCount(QrData, chunkSize, selectedFile);
      for (final code in splitCodes) {
        qrCode = QrCode(QrVersions.max, QrErrorCorrectLevel.L)..addData(code);
        codes.add(qrCode);
      }

      // qrImage = QrImage(qrCode);
      // final svg = barcode.toSvg(ZLIBcompressedByteData.join(""),
      //     width: 100, height: 100);

      // await File('/storage/emulated/0/flutter_qr_image.svg').writeAsString(svg);

      isLoading = false;
    } on InputTooLongException catch (e) {
      renderError = true;
      qrRenderErrorMsg = "File too big to convert";
      print('An error occurred: $e');
      isLoading = false;
    } catch (e) {
      renderError = true;
      print('An error occurred: $e');
      isLoading = false;
    }
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

  // void decodeQRCodes(List<String> qrStringList) {
  //   List<int> qrIntList = [];
  //   //ext pos noofchunks
  //   qrStringList.sort((a,b)=>a.)
  //   for (final qrData in qrStringList) {
  //     // var intData = qrData.split("").map((data) => int.parse(data)).toList();
  //     var
  //     qrIntList = qrIntList + intData;
  //   }

  //   var decompressedData
  // }
}
