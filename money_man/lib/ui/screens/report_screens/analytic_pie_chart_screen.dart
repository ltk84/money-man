import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart_information_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/utils.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:money_man/ui/screens/report_screens/share_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/expandable_widget.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class AnalyticPieChartSreen extends StatefulWidget {
  final Wallet currentWallet;
  final String type;
  final DateTime endDate;
  final DateTime beginDate;

  AnalyticPieChartSreen(
      {Key key,
      @required this.currentWallet,
      @required this.type,
      @required this.beginDate,
      @required this.endDate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AnalyticPieChartSreen();
}

class _AnalyticPieChartSreen extends State<AnalyticPieChartSreen> {
  String _content;
  Color _color;

  int touchedIndex = -1;
  GlobalKey key1;
  Uint8List bytes1;
  bool expandDetail;
  DateTime beginDate;
  DateTime endDate;

  final double fontSizeText = 35;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;
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

  @override
  void initState() {
    super.initState();
    beginDate = widget.beginDate;
    endDate = widget.endDate;

    _content = widget.type == 'expense' ? 'Expense' : 'Income';
    _color = widget.type == 'expense' ? expenseColor : incomeColor2;

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    expandDetail = false;
    _wallet = widget.currentWallet == null
        ? Wallet(
        id: 'id',
        name: 'defaultName',
        amount: 0,
        currencyID: 'USD',
        iconID: 'a')
        : widget.currentWallet;
  }
  //
  // @override
  // void didUpdateWidget(covariant AnalyticPieChartSreen oldWidget) {
  //   //_transactionList = widget.currentList ?? [];
  //   //_categoryList = widget.categoryList ?? [];
  //   _total = widget.total;
  //   _content = widget.content;
  //   _controller = ScrollController();
  //   _color = widget.color;
  //   _controller.addListener(_scrollListener);
  //   super.didUpdateWidget(oldWidget);
  // }
  @override
  void didUpdateWidget(covariant AnalyticPieChartSreen oldWidget) {
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
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'alo',
              child: Icon(Icons.arrow_back_ios, color: foregroundColor),
            ),
          ),
          //centerTitle: true,
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
          // title: AnimatedOpacity(
          //     opacity: reachTop == 1 ? 1 : 0,
          //     duration: Duration(milliseconds: 100),
          //     child: Text(_content,
          //         style: TextStyle(
          //           color: foregroundColor,
          //           fontFamily: fontFamily,
          //           fontSize: 17.0,
          //           fontWeight: FontWeight.w600,
          //         ))
          // ),
          actions: <Widget>[
            Hero(
              tag: 'shareButton',
              child: MaterialButton(
                child: const Icon(Icons.ios_share, color: Colors.white),
                onPressed: () async {
                  final bytes1 = await Utils.capture(key1);

                  await setState(() {
                    this.bytes1 = bytes1;
                  });
                  showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) =>
                          ShareScreen(
                              bytes1: this.bytes1,
                              bytes2: null,
                              bytes3: null));
                },
              ),
            ),
          ],
        ),
        body: StreamBuilder<Object>(
          stream: _firestore.transactionStream(_wallet, 'full'),
          builder: (context, snapshot) {
            List<MyTransaction> _transactionList = snapshot.data ?? [];
            List<MyCategory> _categoryList = [];

            double total = 0;

            _transactionList.forEach((element) {
              if (element.date.compareTo(endDate) <= 0) {
                if (element.category.type == widget.type) {
                  if (element.date.compareTo(beginDate) >= 0) {
                    total += element.amount;
                    if (!_categoryList.any((categoryElement) {
                      if (categoryElement.name == element.category.name)
                        return true;
                      else
                        return false;
                    })) {
                      _categoryList.add(element.category);
                    }
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
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: WidgetToImage(
                      builder: (key) {
                        this.key1 = key;

                        return Container(
                          color: backgroundColor, // để lúc export ra không bị transparent.
                          child: Column(children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(_content,
                                  style: TextStyle(
                                    color: foregroundColor.withOpacity(0.7),
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                MoneySymbolFormatter(
                                  text: total,
                                  currencyId: _wallet.currencyID,
                                  textStyle: TextStyle(
                                    color: _color,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                PieChartScreen(
                                    isShowPercent: true,
                                    currentList: _transactionList,
                                    categoryList: _categoryList,
                                    total: total),
                              ],
                            ),
                            SizedBox(height: 20,),
                            GestureDetector(
                              onTap: () async {
                                await setState(() {
                                  expandDetail = !expandDetail;
                                  print(_controller.position.maxScrollExtent.toString());
                                });
                                if (expandDetail)
                                  _controller.animateTo(
                                    _categoryList.length == 0
                                      ? 0
                                      : _categoryList.length.toDouble()*67.4 - 193.2 + .05494505494505,
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                  //_controller.jumpTo(100);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: boxBackgroundColor,
                                    border: Border(
                                        top: BorderSide(
                                          color: foregroundColor.withOpacity(0.12),
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: foregroundColor.withOpacity(0.12),
                                          width: 1,
                                        )
                                    )
                                ),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View amount',
                                      style: TextStyle(
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.0,
                                        color: foregroundColor,
                                      )
                                    ),
                                    Icon(Icons.arrow_drop_down, color: foregroundColor.withOpacity(0.54)),
                                  ],
                                ),
                              ),
                            ),
                            ExpandableWidget(
                              expand: expandDetail,
                              child: PieChartInformationScreen(
                                currentList: _transactionList,
                                categoryList: _categoryList,
                                currentWallet: _wallet,
                                color: _color,
                              ),
                            )
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
