import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<String> readFileAsBytes(String filePath) async {
  print("Reading bytes...");
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  final binaryString =
      bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  print(binaryString);
  print("Reading bytes done");

  return binaryString;
}

Future<bool> requestFilePermission() async {
  PermissionStatus result;
  // In Android we need to request the storage permission,
  // while in iOS is the photos permission
  if (Platform.isAndroid) {
    result = await Permission.storage.request();
  }
  return false;
}
