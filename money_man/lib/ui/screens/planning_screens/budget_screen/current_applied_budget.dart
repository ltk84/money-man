import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screen/budget_detail.dart';
import 'package:provider/provider.dart';

import 'line_chart_progress.dart';

class CurrentlyApplied extends StatelessWidget {
  Wallet wallet;

  CurrentlyApplied({
    Key key,
    @required this.wallet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      padding: EdgeInsets.only(top: 30),
      color: Color(0xff1a1a1a),
      //child: MyBudgetTile(),
      child: StreamBuilder<List<Budget>>(
          stream: _firestore.budgetStream(wallet.id),
          builder: (context, snapshot) {
            List<Budget> budgets = snapshot.data;
            print(budgets);
            return ListView.builder(
              itemCount: budgets == null ? 0 : budgets.length,
              itemBuilder: (context, index) => Column(
                children: [MyTimeRange(), MyBudgetTile()],
              ),
            );
          }),
    );
  }
}

class MyBudgetTile extends StatelessWidget {
  const MyBudgetTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BudgetDetailScreen()),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 110,
          color: Color(0xff1b1b1b),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(15, 15, 15, 5),
                            child: Icon(
                              Icons.circle,
                              color: Colors.redAccent,
                              size: 50,
                            )),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "All expend",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ), //Title cho khoản chi thu đã chọn
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 25, 15, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '3.000.000',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ), // Target
                          Text(
                            'Remain: 1.300.000',
                            style: TextStyle(color: Colors.white54),
                          ), // Remain
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(80, 0, 15, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xff161616),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF2FB49C)),
                    minHeight: 8,
                    value: 0.5,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xff171717)),
                margin: EdgeInsets.fromLTRB(300, 3, 15, 0),
                child: Text(
                  "Today",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTimeRange extends StatelessWidget {
  const MyTimeRange({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: 70,
        color: Color(0xff1b1b1b),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                "This month",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '3,000,000',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Remain: 1,300,000',
                  style: TextStyle(color: Colors.white),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
