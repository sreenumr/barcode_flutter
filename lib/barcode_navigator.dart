import 'widgets/pages/home.dart';
import 'widgets/pages/scan.dart';
import 'package:flutter/material.dart';

class BarcodeNavigator extends StatefulWidget {
  const BarcodeNavigator({super.key});

  @override
  State<BarcodeNavigator> createState() => BarcodeNavigatorState();
}

class BarcodeNavigatorState extends State<BarcodeNavigator> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(title: "Home"),
    ScanPage(title: "Scan")
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.scanner_outlined),
            label: 'Scan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
