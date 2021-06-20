import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';
import 'package:money_man/ui/screens/planning_screens/planning_screen.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/account_screens/account_screen.dart';
import 'package:money_man/ui/screens/report_screens/report_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/add_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 3;

  void _onItemTap(int index, Wallet wallet) {
    if (_selectedIndex != index) {
      if (index == 2) {
        showCupertinoModalBottomSheet(
            isDismissible: true,
            backgroundColor: Style.boxBackgroundColor,
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
            PlanningScreen(currentWallet: wallet),
            AccountScreen(),
          ];

          if (snapshot.connectionState == ConnectionState.active) {
            if (wallet == null) {
              return FirstStep();
            } else
              return Scaffold(
                backgroundColor: Style.foregroundColor.withOpacity(0.38),
                body: _screens.elementAt(_selectedIndex),
                bottomNavigationBar: BottomAppBar(
                  notchMargin: 5,
                  shape: CircularNotchedRectangle(),
                  color: Style.backgroundColor,
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
                            color: Colors.transparent,
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
                      selectedLabelStyle: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedItemColor: Style.foregroundColor,
                      unselectedItemColor: Style.foregroundColor.withOpacity(0.54),
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
                  backgroundColor: Style.primaryColor,
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
