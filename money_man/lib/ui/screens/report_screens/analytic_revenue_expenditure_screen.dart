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
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
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

  final double fontSizeText = 29.7;
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
        appBar: AppBar(
            leading: BackButton(),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRect(
              child: AnimatedOpacity(
                opacity: reachAppBar == 1 ? 1 : 0,
                duration: Duration(milliseconds: 0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: reachTop == 1 ? 25 : 500,
                      sigmaY: 25,
                      tileMode: TileMode.values[0]),
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds:
                        reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                    color: Colors.grey[reachAppBar == 1
                        ? (reachTop == 1 ? 800 : 850)
                        : 900]
                        .withOpacity(0.2),
                  ),
                ),
              ),
            ),
            title: AnimatedOpacity(
                opacity: reachTop == 1 ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Text('Net Income',
                    style: TextStyle(
                      color: foregroundColor,
                      fontFamily: fontFamily,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                    ))
            )
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
                color: backgroundColor,
                child: ListView(
                  controller: _controller,
                  physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        color: backgroundColor,
                      child: Column(
                        children: [
                          Column(
                            children: <Widget>[
                              Text('Net Income',
                                  style: TextStyle(
                                    color: foregroundColor.withOpacity(0.7),
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  )
                              ),
                              MoneySymbolFormatter(
                                  text: closingBalance - openingBalance,
                                  currencyId: _wallet.currencyID,
                                  textStyle: TextStyle(
                                    color: (closingBalance - openingBalance) > 0 ? incomeColor
                                        : (closingBalance - openingBalance) == 0 ? foregroundColor : expenseColor,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 26,
                                    height: 1.5,
                                  ))
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
                        ],
                      )
                    ),
                    Container(
                      child: BarChartInformation(
                        currentList: _transactionList,
                        beginDate: beginDate,
                        endDate: endDate,
                        currentWallet: widget.currentWallet,
                      ),
                    )
                  ],
                ),
              );
            }));
  }
}
