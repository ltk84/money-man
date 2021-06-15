import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/report_screens/analytic_revenue_expenditure_screen.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/report_screens/analytic_pie_chart_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/utils.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:money_man/ui/screens/report_screens/share_screen.dart';
import 'package:money_man/ui/screens/report_screens/time_selection.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import '../../style.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:provider/provider.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';

class ReportScreen extends StatefulWidget {
  Wallet currentWallet;

  ReportScreen({Key key, this.currentWallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReportScreen();
  }
}

class _ReportScreen extends State<ReportScreen> with TickerProviderStateMixin {
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
  DateTime beginDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  String dateDescript = 'This month';

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
    _wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant ReportScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return DefaultTabController(
      length: 300,
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: new AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
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
                    //child: Container(
                    //color: Colors.transparent,
                    color: Colors.grey[reachAppBar == 1
                            ? (reachTop == 1 ? 800 : 850)
                            : 900]
                        .withOpacity(0.2),
                    //),
                  ),
                ),
              ),
            ),
            leadingWidth: 70,
            leading: GestureDetector(
              onTap: () async {
                buildShowDialog(context, _wallet.id);
              },
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    SuperIcon(
                      iconPath: _wallet.iconID,
                      size: 25.0,
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
            title: GestureDetector(
              onTap: () async {
                final result = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) => TimeRangeSelection(
                        dateDescription: dateDescript,
                        beginDate: beginDate,
                        endDate: endDate));
                if (result != null) {
                  setState(() {
                    dateDescript = result.description;
                    beginDate = result.begin;
                    endDate = result.end;
                  });
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      Text(
                        dateDescript,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(beginDate) +
                            " - " +
                            DateFormat('dd/MM/yyyy').format(endDate),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.ios_share, color: Colors.white),
                onPressed: () async {
                  final bytes1 = await Utils.capture(key1);
                  final bytes2 = await Utils.capture(key2);
                  final bytes3 = await Utils.capture(key3);

                  await setState(() {
                    this.bytes1 = bytes1;
                    this.bytes2 = bytes2;
                    this.bytes3 = bytes3;
                  });
                  showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) => ShareScreen(
                          bytes1: this.bytes1,
                          bytes2: this.bytes2,
                          bytes3: this.bytes3));
                },
              ),
            ],
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

                        if (!_expenseCategoryList.any((categoryElement) {
                          if (categoryElement.name == element.category.name)
                            return true;
                          else
                            return false;
                        })) {
                          _expenseCategoryList.add(element.category);
                        }
                        // if (!_expenseCategoryList.contains(element.category))
                        //   _expenseCategoryList.add(element.category);
                      }
                    } else {
                      closingBalance += element.amount;
                      if (element.date.compareTo(beginDate) >= 0) {
                        income += element.amount;
                        if (!_incomeCategoryList.any((categoryElement) {
                          if (categoryElement.name == element.category.name)
                            return true;
                          else
                            return false;
                        })) {
                          _incomeCategoryList.add(element.category);
                        }
                        // if (!_incomeCategoryList.contains(element.category))
                        //   _incomeCategoryList.add(element.category);
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
                        padding: EdgeInsets.symmetric(vertical: 15),
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
                        child: Column(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Opening balance',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    MoneySymbolFormatter(
                                      text: openingBalance,
                                      currencyId: _wallet.currencyID,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Closing balance',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    MoneySymbolFormatter(
                                      text: closingBalance,
                                      currencyId: _wallet.currencyID,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ]),
                      ),
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
                                      )),
                                  MoneySymbolFormatter(
                                      text: closingBalance - openingBalance,
                                      currencyId: _wallet.currencyID,
                                      textStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 22,
                                      ))
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AnalyticRevenueAndExpenditureScreen(
                                          currentWallet: _wallet,
                                          beginDate: beginDate,
                                          endDate: endDate,
                                        );
                                      });
                                },
                                child: Container(
                                  width: 450,
                                  height: 200,
                                  child: BarChartScreen(
                                      currentList: _transactionList,
                                      beginDate: beginDate,
                                      endDate: endDate),
                                ),
                              ),
                            ]);
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: WidgetToImage(
                                builder: (key) {
                                  this.key2 = key;

                                  return Column(
                                    children: <Widget>[
                                      Text(
                                        'Income',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      MoneySymbolFormatter(
                                        text: income,
                                        currencyId: _wallet.currencyID,
                                        textStyle: TextStyle(
                                          color: Colors.blueAccent,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          return showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AnalyticPieChartSreen(
                                                  currentList: _transactionList,
                                                  categoryList:
                                                      _incomeCategoryList,
                                                  currentWallet:
                                                      widget.currentWallet,
                                                  total: income,
                                                  content: 'Income',
                                                  color: Colors.green[600],
                                                );
                                              });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 25),
                                          width: 90,
                                          height: 90,
                                          child: PieChartScreen(
                                              isShowPercent: false,
                                              currentList: _transactionList,
                                              categoryList: _incomeCategoryList,
                                              total: income),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: WidgetToImage(
                                builder: (key) {
                                  this.key3 = key;

                                  return Column(children: <Widget>[
                                    Text(
                                      'Expense',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    MoneySymbolFormatter(
                                      text: expense,
                                      currencyId: _wallet.currencyID,
                                      textStyle: TextStyle(
                                        color: Colors.redAccent,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        return showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AnalyticPieChartSreen(
                                                currentList: _transactionList,
                                                categoryList:
                                                    _expenseCategoryList,
                                                total: expense,
                                                content: 'Expense',
                                                color: Colors.red,
                                                currentWallet:
                                                    widget.currentWallet,
                                              );
                                            });
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 25),
                                        width: 90,
                                        height: 90,
                                        child: PieChartScreen(
                                            isShowPercent: false,
                                            currentList: _transactionList,
                                            categoryList: _expenseCategoryList,
                                            total: expense),
                                      ),
                                    ),
                                  ]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.grey[900],
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: _auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
  }
}
