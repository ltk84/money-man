import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ReportListTransaction extends StatefulWidget {
  final DateTime beginDate;
  final DateTime endDate;
  final Wallet currentWallet;
  final double totalMoney;
  const ReportListTransaction(
      {Key key,
      this.beginDate,
      this.endDate,
      this.totalMoney,
      this.currentWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportListTransaction();
}

class _ReportListTransaction extends State<ReportListTransaction> {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    } else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >= fontSizeText - 5) {
      setState(() {
        reachTop = 1;
      });
    } else {
      setState(() {
        reachTop = 0;
      });
    }
  }
  // sort theo date giảm dần
  DateTime _beginDate;
  DateTime _endDate;
  double total;
  double _totalMoney;
  @override
  void initState() {
    super.initState();
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    total = 0;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  bool CompareDate(DateTime a, DateTime b) {
    if (a.year < b.year) return true;
    if (a.year == b.year && a.month < b.month) return true;
    if (a.year == b.year && a.month == b.month && a.day <= b.day) return true;
    return false;
  }

  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: Text('Transaction List'),
        ),
        body: StreamBuilder<Object>(
          stream: _firestore.transactionStream(widget.currentWallet, 'full'),
          builder: (context, snapshot) {
            List<MyTransaction> transactionList = snapshot.data ?? [];
            List<List<MyTransaction>> transactionListSorted = [];
            List<DateTime> dateInChoosenTime = [];
            transactionList = transactionList
                .where((element) =>
            CompareDate(element.date, _endDate) &&
                CompareDate(_beginDate, element.date))
                .toList();
            transactionList.sort((a, b) => b.date.compareTo(a.date));
            transactionList.forEach((element) {
              if (!dateInChoosenTime.contains(element.date))
                dateInChoosenTime.add(element.date);
            });
            dateInChoosenTime.forEach((date) {
              final b = transactionList
                  .where((element) => element.date.compareTo(date) == 0);
              b.forEach((element) {
                element.category.type == "income"
                    ? total += element.amount
                    : total -= element.amount;
              });
              transactionListSorted.add(b.toList());
            });

            return buildDisplayTransactionByDate(transactionListSorted, total);
          }
        ));
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate, double total) {
    return Container(
      color: Colors.black,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          //primary: false,
          shrinkWrap: true,
          // itemCount: TRANSACTION_DATA.length + 1,
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
                      buildHeader(transactionListSortByDate, total),
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  Widget buildHeader(List<List<MyTransaction>> transListSortByDate, double total) {
          _totalMoney = 0;
          transListSortByDate.forEach((element) {
            element.forEach((e) {
              if (e.category.type == "income") {
                _totalMoney += e.amount;
              } else
                _totalMoney -= e.amount;
            });
          });
          return StickyHeader(
            header: SizedBox(height: 0),
            content: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border(
                        bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ))),
                padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 1.0,
                            height: 10,
                          ),
                          ColoredBox(color: Colors.black87)
                        ]),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(2, 2, 2, 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(_totalMoney >= 0 ? 'Income' : 'Outcome',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Montserrat',
                              )),
                          MoneySymbolFormatter(
                              text: _totalMoney,
                              currencyId: widget.currentWallet.currencyID,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                              )),
                        ]),
                  ),
                ])),
          );
  }

  Widget buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
          totalAmountInDay = 0;
          transListSortByDate[xIndex].forEach((element) {
            element.category.type == 'income'
                ? totalAmountInDay += element.amount
                : totalAmountInDay -= element.amount;
          });
          return Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    top: BorderSide(
                      color: Colors.black,
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
                      child: MoneySymbolFormatter(
                        text: totalAmountInDay,
                        currencyId: widget.currentWallet.currencyID,
                        textAlign: TextAlign.end,
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
                        await Navigator.push(
                            context,
                            PageTransition(
                                child: TransactionDetail(
                                  transaction: transListSortByDate[xIndex]
                                      [yIndex],
                                  wallet: widget.currentWallet,
                                ),
                                type: PageTransitionType.rightToLeft));
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
                              child: MoneySymbolFormatter(
                                      text: transListSortByDate[xIndex][yIndex]
                                      .amount,
                                      currencyId: widget.currentWallet.currencyID,
                                  textAlign: TextAlign.end,

                                      textStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: transListSortByDate[xIndex][yIndex]
                                                  .category
                                                  .type ==
                                              'income'
                                          ? Colors.green
                                          : Colors.red[600])
                                    ),
                             
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          );
  }
}
