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

Future<List<String>> splitWithCount(
    String input, int chunkSize, dynamic selectedFile) async {
  List<String> output = [];
  int start = 0;
  int end = 0;
  int pos = 0;
  int maxCharsForChunkNum = 1;
  int extLength = selectedFile.extension.length;

  // int currentChunkSize = 0;
  print("Input length = ${input.length}");
  print("Selected File ${selectedFile.extension}");
  // print("Splitting $input of length ${input.length}");
  try {
    while (start <= input.length) {
      end = start + chunkSize;
      if (end > input.length) end = input.length;
      if (input.substring(start, end).isNotEmpty) {
        var string =
            input.substring(start, end - 1 - maxCharsForChunkNum - extLength) +
                selectedFile.extension +
                pos.toString();
        pos++;
        output.add(string);
      }
      // print("Creating chunk ${input.substring(start, end)}");
      start += chunkSize;
    }

    for (int i = 0; i < output.length; i++) {
      output[i] = output[i] + output.length.toString();
    }
    for (int i = 0; i < output.length; i++) {
      print("Value of QR code before generation : ${output[i]}");
    }
  } catch (e) {
    print("An error occurred $e");
  }

  return output;
}
