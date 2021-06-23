import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/ui/style.dart';
//ui/screens/planning_screens/budget_screen/budget_home.dart
import 'package:provider/provider.dart';

import 'add_budget.dart';
import 'applied_budget.dart';
import 'current_applied_budget.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
  }

  Wallet temp = Wallet(
      id: 'id',
      name: 'defaultName',
      amount: 0,
      currencyID: 'USD',
      iconID: 'assets/icons/wallet_2.svg');

  Wallet _wallet;
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Style.backgroundColor,
            appBar: AppBar(
              backgroundColor: Style.boxBackgroundColor.withOpacity(0.2),
              leading: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Style.foregroundColor,
                  )),
              title: Text('Budgets',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                  )),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () async {
                    final _auth = Provider.of<FirebaseAuthService>(context,
                        listen: false);

                    final result = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.grey[900],
                        context: context,
                        builder: (context) {
                          return Provider(
                              create: (_) {
                                return FirebaseFireStoreService(
                                    uid: _auth.currentUser.uid);
                              },
                              child: WalletSelectionScreen(
                                id: _wallet != null ? _wallet.id : temp,
                              ));
                        });
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SuperIcon(
                        iconPath:
                            _wallet != null ? _wallet.iconID : temp.iconID,
                        size: 30,
                      ),
                      Icon(
                          Icons.arrow_drop_down,
                          color: Style.foregroundColor.withOpacity(0.54),
                      ),
                    ],
                  ),
                )
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TabBar(
                    labelStyle: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                    unselectedLabelColor: Style.foregroundColor.withOpacity(0.54),
                    labelColor: Style.foregroundColor,
                    isScrollable: true,
                    controller: _tabController,
                    indicatorColor: Style.primaryColor,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                          child: Container(
                        width: 120,
                        child: Center(
                          child: Text(
                            "Running",
                          ),
                        ),
                      )),
                      Tab(
                          child: Container(
                        width: 120,
                        child: Center(
                          child: Text(
                            "Finished",
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              elevation: 0,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Style.boxBackgroundColor,
                    context: context,
                    builder: (context) => AddBudget(
                          wallet: _wallet,
                        ));
              },
              child: Icon(
                Icons.add_rounded,
                size: 30,
              ),
              backgroundColor: Style.primaryColor,
              elevation: 0,
            ),
            body: Container(
              color: Style.backgroundColor,
              padding: EdgeInsets.only(top: 15),
              child: StreamBuilder<Object>(
                  stream: _firestore.currentWallet,
                  builder: (context, snapshot) {
                    _wallet = snapshot.data ?? temp;
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        CurrentlyApplied(
                          wallet: _wallet,
                        ),
                        Applied(wallet: _wallet)
                      ],
                    );
                  }),
            ),
          ),
        ));
  }
}
