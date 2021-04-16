import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/screens/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _screens = [
    TransactionScreen(),
    LoadingScreen()
  ];

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        backgroundColor: Colors.white,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded, size: 20.0),label: 'Wallet',backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_sharp), label: 'Report',backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 60.0,), label: 'Add',backgroundColor: Colors.black ),
          BottomNavigationBarItem(icon: Icon(Icons.article_sharp), label: 'Report',backgroundColor: Colors.black),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Report',backgroundColor: Colors.black),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
      ),
    );
  }
}
