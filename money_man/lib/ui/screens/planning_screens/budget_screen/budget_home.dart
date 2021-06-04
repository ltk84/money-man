import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
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
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
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
    //_wallet = _firestore.currentWallet
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: 1 == 65
          ? Scaffold(
              body: MyTimeRange(),
            )
          : DefaultTabController(
              length: 3,
              child: StreamBuilder<Wallet>(
                  stream: _firestore.currentWallet,
                  builder: (context, snapshot) {
                    Wallet wallet = snapshot.data;
                    print(wallet.id);
                    return Scaffold(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.account_balance_wallet_rounded),
                              Icon(Icons.arrow_drop_down),
                            ],
                          )
                        ],
                        bottom: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorColor: Color(0xffd3db00),
                          indicatorWeight: 3,
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelColor: Colors.white30,
                          tabs: [
                            Tab(
                              child: Container(
                                  child: Icon(
                                Icons.add_circle,
                                color: Color(0xFF2FB49C),
                                size: 35,
                              )),
                            ),
                            Tab(
                                child: Container(
                              width: 120,
                              child: Text(
                                "Currently applied",
                              ),
                            )),
                            Tab(
                                child: Container(
                              width: 120,
                              child: Text(
                                "Applied",
                              ),
                            )),
                          ],
                        ),
                        elevation: 3,
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          AddBudget(
                            tabController: _tabController,
                          ),
                          CurrentlyApplied(
                            wallet: wallet,
                          ),
                          Applied()
                        ],
                      ),
                    );
                  }),
            ),
    );
  }
}
