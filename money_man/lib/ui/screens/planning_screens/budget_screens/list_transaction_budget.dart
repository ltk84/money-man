import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ListTransactionBudget extends StatefulWidget {
  final DateTime beginDate;
  final DateTime endDate;
  final Wallet currentWallet;
  final List<MyTransaction> currentList;
  final double totalMoney;
  final Event event;
  const ListTransactionBudget(
      {Key key,
      this.beginDate,
      this.endDate,
      this.currentList,
      this.totalMoney,
      this.currentWallet,
      this.event})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ListTransactionBudget();
}

class _ListTransactionBudget extends State<ListTransactionBudget> {
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

  // list các list transaction đã lọc
  List<List<MyTransaction>> transactionListSorted = [];
  List<MyTransaction> _transactionList;
  List<DateTime> dateInChoosenTime = [];
  // sort theo date giảm dần
  DateTime _beginDate;
  DateTime _endDate;
  int total;
  double _totalMoney;
  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList ?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    total = 0;
    _totalMoney = widget.totalMoney;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    filterData(_transactionList, _beginDate, _endDate);
  }

  @override
  void didUpdateWidget(covariant ListTransactionBudget oldWidget) {
    _transactionList = widget.currentList ?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    _controller = ScrollController();
    _totalMoney = widget.totalMoney;
    total = 0;
    _controller.addListener(_scrollListener);
  }

  void filterData(List<MyTransaction> transactionList, DateTime beginDate,
      DateTime endDate) {
    transactionList = transactionList
        .where((element) =>
            element.date.day <= endDate.day &&
            element.date.month <= endDate.month &&
            element.date.year <= endDate.year &&
            element.date.day >= beginDate.day &&
            element.date.month >= beginDate.month &&
            element.date.year >= beginDate.year)
        .toList();
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
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        title: Text('Transaction List'),
      ),
      body: buildDisplayTransactionByDate(transactionListSorted, _totalMoney),
    );
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
                      buildHeader(total),
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  StickyHeader buildHeader(double total) {
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
                    Text('$total đ',
                        style: TextStyle(
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
                      child: Text(totalAmountInDay.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
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
                      onTap: () {
                        Navigator.push(
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
                              child: Text(
                                  transListSortByDate[xIndex][yIndex]
                                      .amount
                                      .toString(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: transListSortByDate[xIndex][yIndex]
                                                  .category
                                                  .type ==
                                              'income'
                                          ? Colors.green
                                          : Colors.red[600])),
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
}
