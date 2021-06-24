import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return FutureBuilder<Object>(
        future: _firestore.getListOfTransactionWithCriteriaForBudget(
            widget.budget.category.name, widget.wallet.id),
        builder: (context, snapshot) {
          double total = 0;
          List<MyTransaction> listTransaction = snapshot.data ?? [];
          print('current length: ${listTransaction.length}');

          for (int i = 0; i < listTransaction.length; i++) {
            if (listTransaction[i].date.compareTo(widget.budget.beginDate) <
                    0 ||
                listTransaction[i].date.compareTo(
                        widget.budget.endDate.add(Duration(days: 1))) >=
                    0) {
              listTransaction.removeAt(i);
              i--;
            }
          }

          listTransaction.sort((a, b) => b.date.compareTo(a.date));
          return Scaffold(
            backgroundColor: Color(0xff1a1a1a),
            appBar: AppBar(
              backgroundColor: Color(0xff333333),
              centerTitle: true,
              elevation: 0,
              title: Text(
                'Transaction List',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
            ),
            body: listTransaction.length == 0
                ? Container(
                    color: Style.backgroundColor,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: Style.foregroundColor.withOpacity(0.24),
                          size: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'There are no transactions',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Style.foregroundColor.withOpacity(0.36),
                          ),
                        ),
                      ],
                    ))
                : buildDisplayTransactionByDate(filterData(listTransaction)),
          );
        });
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate) {
    return Container(
      color: Color(0xff1a1a1a),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            transactionListSortByDate[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  Container buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
    return (transListSortByDate[xIndex].length != 0)
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    top: BorderSide(
                      color: Color(0xff1a1a1a),
                      width: 1.0,
                    ))),
            child: StickyHeader(
              header: Container(
                color: Colors.grey[900],
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: Text(
                          DateFormat("dd")
                              .format(transListSortByDate[xIndex][0].date),
                          style:
                              TextStyle(fontSize: 30.0, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Text(
                          DateFormat("EEEE")
                                  .format(transListSortByDate[xIndex][0].date)
                                  .toString() +
                              '\n' +
                              DateFormat("MMMM yyyy")
                                  .format(transListSortByDate[xIndex][0].date)
                                  .toString(),
                          // 'hello',
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.grey[500])),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: MoneySymbolFormatter(
                          text: totalAmountInDay,
                          currencyId: widget.wallet.currencyID,
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: transListSortByDate[xIndex].length,
                  itemBuilder: (context, yIndex) {
                    return GestureDetector(
                      onTap: () async {
                        /*Navigator.push(
                            context,
                            PageTransition(
                                child: TransactionDetail(
                                  transaction: transListSortByDate[xIndex]
                                      [yIndex],
                                  wallet: widget.wallet,
                                ),
                                type: PageTransitionType.rightToLeft));
                        setState(() {});*/
                        var res = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => TransactionDetail(
                                      transaction: transListSortByDate[xIndex]
                                          [yIndex],
                                      wallet: widget.wallet,
                                    )));
                        setState(() {});
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: SuperIcon(
                                  iconPath: transListSortByDate[xIndex][yIndex]
                                      .category
                                      .iconID,
                                  size: 30,
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                              child: Text(
                                  transListSortByDate[xIndex][yIndex]
                                      .category
                                      .name,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: MoneySymbolFormatter(
                                  text: transListSortByDate[xIndex][yIndex]
                                      .amount,
                                  currencyId: widget.wallet.currencyID,
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: transListSortByDate[xIndex][yIndex]
                                                  .category
                                                  .type ==
                                              'income'
                                          ? Colors.green
                                          : Colors.red[600]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        : Container(
            height: 0.1,
          );
  }

  List<List<MyTransaction>> filterData(List<MyTransaction> transactionList) {
    var _transactionList = transactionList;
    List<List<MyTransaction>> transactionListSorted = [];
    List<DateTime> dateInChoosenTime = [];
    transactionList.sort((a, b) => b.date.compareTo(a.date));
    transactionList.forEach((element) {
      if (!dateInChoosenTime.contains(element.date))
        dateInChoosenTime.add(element.date);
    });
    dateInChoosenTime.forEach((date) {
      final b = _transactionList
          .where((element) => element.date.compareTo(date) == 0);
      transactionListSorted.add(b.toList());
    });
    return transactionListSorted;
  }
}
