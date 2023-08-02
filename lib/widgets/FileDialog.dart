import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class FileDialog extends StatelessWidget {
  final VoidCallback onOk;
  FileDialog({required this.onOk});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return AlertDialog(
      content: const Text('Save As'),
      actions: <Widget>[
        Column(
          children: [
            TextField(
                onChanged: (text) {
                  log("Text changed");
                  appState.saveAsFileName = text;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'FileName',
                )),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                appState.saveAsFileName = "";
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onOk();
                Navigator.pop(context, 'OK');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      ],
    );
  }
}
