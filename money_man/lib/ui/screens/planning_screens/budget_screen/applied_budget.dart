import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

import 'current_applied_budget.dart';

class Applied extends StatelessWidget {
  const Applied({Key key, this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      padding: EdgeInsets.only(top: 30),
      color: Color(0xff1a1a1a),
      child: StreamBuilder<List<Budget>>(
          stream: _firestore.budgetStream(wallet.id),
          builder: (context, snapshot) {
            List<Budget> budgets = snapshot.data;
            budgets.sort((b, a) => b.beginDate.compareTo(a.beginDate));
            for (int i = 0; i < budgets.length; i++) {
              if (DateTime.now().isBefore(budgets[i].endDate)) {
                budgets.removeAt(i);
                i--;
                print(i);
                //print(DateTime.now());
                // print(budgets[i].endDate);
                // print(budgets[i].category.name);
              }
            }
            return ListView.builder(
              itemCount: budgets == null ? 0 : budgets.length,
              itemBuilder: (context, index) => Column(
                children: [
                  //MyTimeRange(),
                  MyBudgetTile(
                    budget: budgets[index],
                    wallet: wallet,
                  )
                ],
              ),
            );
          }),
    );
  }
}
