import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/error_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_list_screen.dart';
import 'package:money_man/ui/screens/report_screens/reports_screens.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/error_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static List<Widget> _screens = [
    TransactionScreen(),
    ReportScreen(),
    LoadingScreen(),
    ErrorScreen(),
    ErrorScreen()
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
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: Colors.grey[900],
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_rounded, size: 25.0),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_sharp, size: 25.0),
              label: 'Report',
              //backgroundColor: Colors.grey[500],
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: 0.0,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_sharp, size: 25.0),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 25.0),
              label: 'Account',
            ),
          ],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[400],
          unselectedFontSize: 12.0,
          selectedFontSize: 12.0,
          currentIndex: _selectedIndex,
          onTap: _onItemTap,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _onItemTap(2);
        },
        backgroundColor: Colors.yellow[700],
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
    // hello there
  }
}
