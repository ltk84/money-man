import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/list_transaction_budget.dart';

class BudgetTransactionScreen extends StatefulWidget {
  Budget budget;
  Wallet wallet;
  BudgetTransactionScreen({Key key, this.budget, this.wallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BudgetTransactionScreen();
  }
}

class _BudgetTransactionScreen extends State<BudgetTransactionScreen>
    with TickerProviderStateMixin {
  Budget _budget;
  Wallet _eventWallet;
  List<DateTime> dateInChoosenTime = [];
  @override
  void initState() {
    _budget = widget.budget;
    _eventWallet = widget.wallet;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BudgetTransactionScreen oldWidget) {
    _budget = widget.budget;
    _eventWallet = widget.wallet;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return FutureBuilder<Object>(
        future: _firestore.getListOfTransactionWithCriteria(
            widget.budget.category.name, widget.wallet.id),
        builder: (context, snapshot) {
          double total = 0;
          List<MyTransaction> listTransaction = snapshot.data ?? [];
          for (int i = 0; i < listTransaction.length; i++) {
            if (listTransaction[i].date.isBefore(widget.budget.beginDate) ||
                listTransaction[i].date.isAfter(widget.budget.endDate)) {
              listTransaction.removeAt(i);
              i--;
            }
          }
          listTransaction.sort((a, b) => b.date.compareTo(a.date));
          return (listTransaction.length == 0)
              ? Scaffold(
                  backgroundColor: Colors.black,
                  appBar: new AppBar(
                    backgroundColor: Colors.black,
                    centerTitle: true,
                    elevation: 0,
                    title: Text('Transaction List'),
                  ),
                  body: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No transaction',
                      style: TextStyle(
                        fontSize: 45,
                        color: Colors.white54,
                      ),
                    ),
                  ))
              : ListTransactionBudget(
                  endDate: listTransaction[0].date,
                  beginDate: listTransaction[listTransaction.length - 1].date,
                  currentList: listTransaction,
                  totalMoney: total,
                  currentWallet: widget.wallet,
                );
        });
  }
}
