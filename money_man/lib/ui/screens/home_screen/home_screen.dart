import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';
import 'package:money_man/ui/screens/account_screens/account_edit_information_screen.dart';
//import 'package:money_man/ui/screens/account_screen/account_screen.dart';
import 'package:money_man/ui/screens/planning_screen/planning_screen.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/account_screens/account_screen.dart';
import 'package:money_man/ui/screens/report_screens/report_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/add_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTap(int index, Wallet wallet) {
    if (_selectedIndex != index) {
      if (index == 2) {
        showCupertinoModalBottomSheet(
            isDismissible: true,
            backgroundColor: Colors.grey[900],
            context: context,
            builder: (context) => AddTransactionScreen(currentWallet: wallet));
      } else
        setState(() {
          _selectedIndex = index;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    print('home build');

    return StreamBuilder<Wallet>(
        stream: _firestore.currentWallet,
        builder: (context, snapshot) {
          final wallet = snapshot.data;

          List<Widget> _screens = [
            TransactionScreen(currentWallet: wallet),
            ReportScreen(currentWallet: wallet),
            AddTransactionScreen(currentWallet: wallet),
            PlanningScreen(),
            AccountScreen(),
          ];

          if (snapshot.connectionState == ConnectionState.active) {
            if (wallet == null) {
              return FirstStep();
            } else
              return Scaffold(
                backgroundColor: Colors.white38,
                body: _screens.elementAt(_selectedIndex),
                bottomNavigationBar: BottomAppBar(
                  notchMargin: 5,
                  shape: CircularNotchedRectangle(),
                  color: Colors.black,
                  child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.account_balance_wallet_rounded,
                              size: 25.0),
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
                      onTap: (index) => _onItemTap(index, wallet)),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    _onItemTap(2, wallet);
                  },
                  backgroundColor: Colors.yellow[700],
                  elevation: 0,
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
              );
          } else
            return LoadingScreen();
        });
    // hello there
  }
}
