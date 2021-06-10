import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
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

  Wallet _wallet = Wallet(
      id: 'id',
      name: 'defaultName',
      amount: 0,
      currencyID: 'USD',
      iconID: 'assets/icons/wallet_2.svg');
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff333333),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Budget",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                ),
              ),
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
                                id: _wallet.id,
                              ));
                        });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SuperIcon(
                        iconPath: _wallet.iconID,
                        size: 30,
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                )
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    indicatorColor: Color(0xffd3db00),
                    indicatorWeight: 3,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: Colors.white30,
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
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) => AddBudget(
                          wallet: _wallet,
                        ));
              },
              child: Icon(
                Icons.add,
                size: 30,
              ),
              backgroundColor: Color(0xFF2FB49C),
              elevation: 0,
            ),
            body: Container(
              color: Color(0xff1a1a1a),
              padding: EdgeInsets.only(top: 15),
              child: StreamBuilder<Object>(
                  stream: _firestore.currentWallet,
                  builder: (context, snapshot) {
                    _wallet = snapshot.data ?? _wallet;
                    return TabBarView(
                      controller: _tabController,
                      children: [
                        /*AddBudget(
                          tabController: _tabController,
                          wallet: _wallet,
                        ),*/
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
