import 'package:flutter/material.dart';
import 'widgets/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

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
  var selectedFile = "";

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    selectedFile = result.files.first.name;
    print(selectedFile);
    // print(result.files.first.size);
    // print(result.files.first.path);
    notifyListeners();
  }
}
