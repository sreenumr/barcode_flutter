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

  int pos = 0;
  int maxCharsForChunkNum = 1;
  int extLength = selectedFile.extension.length;
  int charsForEmptySpace = 1;
  int charsForCodePos = 1;
  int charsForExtLength = 1;

  List<String> sList = input.split(" ");
  String chunk = "";
  String temp = "";
  List<String> chunkList = [];
  int tempChunkSize = chunkSize -
      charsForExtLength -
      charsForCodePos -
      charsForEmptySpace -
      maxCharsForChunkNum -
      extLength;

  if (tempChunkSize <= 0) {
    tempChunkSize = chunkSize;
  }
  for (int i = 0; i < sList.length; i++) {
    temp += "${sList[i]}${" "}";
    if (temp.length <= tempChunkSize) {
      chunk = temp;
    } else {
      // log("${chunk.trim()}");
      chunkList.add(chunk.trim());
      chunk = "";
      temp = "${sList[i]}${" "}";
    }
    if (i == sList.length - 1) {
      // log("Last element reached");
      chunk = temp;
      // log("${chunk.trim()}");
      chunkList.add(chunk.trim());
    }
  }

  for (chunk in chunkList) {
    var newChunk =
        "$chunk ${selectedFile.extension}${selectedFile.extension.length.toString()}${pos.toString()}${chunkList.length.toString()}";
    pos++;
    output.add(newChunk);
    // log("$newChunk");
  }

  return output;
}
