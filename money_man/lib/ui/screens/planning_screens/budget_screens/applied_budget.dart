import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/widget/budget_tile.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class Applied extends StatelessWidget {
  const Applied({Key key, this.wallet}) : super(key: key);
  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      color: Style.backgroundColor,
      child: StreamBuilder<List<Budget>>(
          stream: _firestore.budgetStream(wallet.id),
          builder: (context, snapshot) {
            print('day la ham print goi tu current budget');
            List<Budget> budgets = snapshot.data ?? [];
            budgets.sort((b, a) => b.beginDate.compareTo(a.beginDate));
            for (int i = 0; i < budgets.length; i++) {
              if (DateTime.now()
                  .isBefore(budgets[i].endDate.add(Duration(days: 1)))) {
                budgets.removeAt(i);
                i--;
              }
            }
            if (budgets.length == 0)
              return Container(
                  color: Style.backgroundColor,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        color: Style.foregroundColor.withOpacity(0.12),
                        size: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'There are no budgets',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Style.foregroundColor.withOpacity(0.24),
                        ),
                      ),
                    ],
                  ));
            return ListView.builder(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemCount: budgets == null ? 0 : budgets.length,
              itemBuilder: (context, index) => Column(
                children: [
                  MyBudgetTile(
                    budget: budgets[index],
                    wallet: wallet,
                  ),
                  SizedBox(height: 5,),
                ],
              ),
            );
          }),
    );
  }
}
