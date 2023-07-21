import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<String> readFileAsBinary(String filePath) async {
  // print("Reading bytes...");
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  final binaryString =
      bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join();
  // print(binaryString);
  // print("Reading bytes done");

  return binaryString;
}

Future<List<int>> readFileAsBytes(String filePath) async {
  // print("Reading bytes...");
  final file = File(filePath);
  final bytes = await file.readAsBytes();
  // print(binaryString);
  // print("Reading bytes done");

  return bytes;
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

Future<List<String>> splitWithCount(String input, int chunkSize) async {
  List<String> output = [];
  int start = 0;
  int end = 0;

  // int currentChunkSize = 0;
  print("Input length = ${input.length}");
  // print("Splitting $input of length ${input.length}");
  try {
    while (start <= input.length) {
      end = start + chunkSize;
      if (end > input.length) end = input.length;
      output.add(input.substring(start, end));
      // print("Creating chunk ${input.substring(start, end)}");
      start += chunkSize;
    }

    for (final val in output) {
      print(val.length);
    }
  } catch (e) {
    print("An error occurred $e");
  }

  return output;
}
