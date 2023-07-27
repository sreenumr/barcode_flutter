import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

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

void writeFileAsBytes(List<int> data, String filename, String ext,
    [String path = "/storage/emulated/0/"]) async {
  final file = File("$path/$filename.$ext");
  await file.writeAsBytes(data);
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
  int charsForEmptySpace = 1;
  // input = "Happy Birthday to you";
  // chunkSize = 5;

  // int currentChunkSize = 0;
  // print("Input length = ${input.length}");
  // print("Selected File ${selectedFile.extension}");
  // print("Splitting $input of length ${input.length}");
  try {
    while (start <= input.length) {
      end = start + chunkSize;
      if (end > input.length) end = input.length;
      if (input.substring(start, end).isNotEmpty) {
        // print("End before ${end}");
        if (end -
                1 -
                maxCharsForChunkNum -
                extLength -
                1 -
                charsForEmptySpace <=
            0) {
          //do nothing
          end = end;
        } else if (end -
                1 -
                maxCharsForChunkNum -
                extLength -
                1 -
                charsForEmptySpace <=
            start) {
          end = end;
        } else {
          end = end -
              1 -
              maxCharsForChunkNum -
              extLength -
              1 -
              charsForEmptySpace;
        }
        // print("End after ${end}");
        var emptySpace = " ";
        var string = input.substring(start, end) +
            emptySpace +
            selectedFile.extension +
            selectedFile.extension.length.toString() +
            pos.toString();
        // print(
        // "New String  = ${string + selectedFile.extension + pos.toString()}");
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
      log("Value of QR code before generation : ${output[i]}");
    }
  } catch (e) {
    print("An error occurred $e");
  }

  return output;
}
