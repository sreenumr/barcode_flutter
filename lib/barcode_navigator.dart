import 'widgets/pages/home_page.dart';
import 'widgets/pages/scan_page.dart';
import 'package:flutter/material.dart';

class BarcodeNavigator extends StatefulWidget {
  const BarcodeNavigator({super.key});

  @override
  State<BarcodeNavigator> createState() => BarcodeNavigatorState();
}

class BarcodeNavigatorState extends State<BarcodeNavigator> {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // toolbarHeight: 10, // Set this height
          title: const Text(
            "Barcode App",
          ),
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.qr_code_scanner))
          ]),
        ),
        body: const TabBarView(
            children: [MyHomePage(title: "Home"), ScanPage(title: "Scan")]),
      ),
    );
  }
}
