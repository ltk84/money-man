import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
//ui/screens/planning_screens/budget_screen/budget_home.dart
import 'package:provider/provider.dart';

import 'add_budget.dart';
import 'applied_budget.dart';
import 'current_applied_budget.dart';

class BudgetScreen extends StatefulWidget {
  Wallet crrWallet;
  BudgetScreen({Key key, this.crrWallet}) : super(key: key);

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
                    await buildShowDialog(context, widget.crrWallet.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SuperIcon(
                        iconPath: widget.crrWallet.iconID,
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
                          wallet: widget.crrWallet,
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
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CurrentlyApplied(
                      wallet: widget.crrWallet,
                    ),
                    Applied(wallet: widget.crrWallet)
                  ],
                )),
          ),
        ));
  }

  void buildShowDialog(BuildContext context, String id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final _firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.grey[900],
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: _auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
    final updatedWallet = await _firestore.getWalletByID(result);
    setState(() {
      widget.crrWallet = updatedWallet;
    });
  }
}
