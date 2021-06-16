import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart_information_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:provider/provider.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';

class AnalyticRevenueAndExpenditureScreen extends StatefulWidget {
  Wallet currentWallet;
  final DateTime endDate;
  final DateTime beginDate;
  AnalyticRevenueAndExpenditureScreen({
    Key key,
    this.currentWallet,
    this.endDate,
    this.beginDate,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AnalyticRevenueAndExpenditureScreen();
  }
}

class _AnalyticRevenueAndExpenditureScreen
    extends State<AnalyticRevenueAndExpenditureScreen>
    with TickerProviderStateMixin {
  GlobalKey key1;
  GlobalKey key2;
  GlobalKey key3;
  Uint8List bytes1;
  Uint8List bytes2;
  Uint8List bytes3;

  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;
  DateTime beginDate;
  DateTime endDate;

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

  Wallet _wallet;

  // Khởi tạo mốc thời gian cần thống kê.
  String dateDescript = 'This month';

  @override
  void initState() {
    beginDate = widget.beginDate;
    endDate = widget.endDate;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'a')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(
      covariant AnalyticRevenueAndExpenditureScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'a',
            iconID: 'b');
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        body: StreamBuilder<Object>(
            stream: _firestore.transactionStream(_wallet, 'full'),
            builder: (context, snapshot) {
              List<MyTransaction> _transactionList = snapshot.data ?? [];
              List<MyCategory> _incomeCategoryList = [];
              List<MyCategory> _expenseCategoryList = [];

              double openingBalance = 0;
              double closingBalance = 0;
              double income = 0;
              double expense = 0;

              _transactionList.forEach((element) {
                if (element.date.isBefore(beginDate)) {
                  if (element.category.type == 'expense')
                    openingBalance -= element.amount;
                  else
                    openingBalance += element.amount;
                }
                if (element.date.compareTo(endDate) <= 0) {
                  if (element.category.type == 'expense') {
                    closingBalance -= element.amount;
                    if (element.date.compareTo(beginDate) >= 0) {
                      expense += element.amount;
                      if (!_expenseCategoryList.contains(element.category))
                        _expenseCategoryList.add(element.category);
                    }
                  } else {
                    closingBalance += element.amount;
                    if (element.date.compareTo(beginDate) >= 0) {
                      income += element.amount;
                      if (!_incomeCategoryList.contains(element.category))
                        _incomeCategoryList.add(element.category);
                    }
                  }
                }
              });
              _transactionList = _transactionList
                  .where((element) =>
                      element.date.compareTo(beginDate) >= 0 &&
                      element.date.compareTo(endDate) <= 0)
                  .toList();
              return Container(
                color: Colors.black,
                child: ListView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[900],
                                width: 1.0,
                              ),
                              top: BorderSide(
                                color: Colors.grey[900],
                                width: 1.0,
                              ))),
                      child: WidgetToImage(
                        builder: (key) {
                          this.key1 = key;

                          return Column(children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('Net Income',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30,
                                    )),
                                Text(
                                    (closingBalance - openingBalance)
                                        .toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 22,
                                    )),
                              ],
                            ),
                            Container(
                              width: 450,
                              height: 200,
                              child: BarChartScreen(
                                  currentList: _transactionList,
                                  beginDate: beginDate,
                                  endDate: endDate),
                            ),
                            Container(
                              child: BarChartInformation(
                                currentList: _transactionList,
                                beginDate: beginDate,
                                endDate: endDate,
                                currentWallet: widget.currentWallet,

                              ),
                            )
                          ]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
