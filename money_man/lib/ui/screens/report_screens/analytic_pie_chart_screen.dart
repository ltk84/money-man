import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart_information_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:random_color/random_color.dart';

class AnalyticPieChartSreen extends StatefulWidget {
  List<MyTransaction> currentList;
  List<MyCategory> categoryList;
  final Wallet currentWallet;
  String content;
  Color color;
  double total;

  AnalyticPieChartSreen(
      {Key key,
      @required this.currentList,
      @required this.categoryList,
      @required this.total,
      @required this.content,
      @required this.color,
      this.currentWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AnalyticPieChartSreen();
}

class _AnalyticPieChartSreen extends State<AnalyticPieChartSreen> {
  double _total;
  int touchedIndex = -1;
  Color _color;
  List<MyTransaction> _transactionList;
  List<MyCategory> _categoryList;
  List<double> _info = [];
  String _content;
  GlobalKey key1;

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

  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList;
    _categoryList = widget.categoryList;
    _total = widget.total;
    _content = widget.content;
    _color = widget.color;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  void didUpdateWidget(covariant AnalyticPieChartSreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _transactionList = widget.currentList ?? [];
    _categoryList = widget.categoryList ?? [];
    _total = widget.total;
    _content = widget.content;
    _color = widget.color;
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
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
                      Text(_content,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          )),
                      Text(_total.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                          )),
                    ],
                  ),
                  Container(
                    height: 30,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    child: PieChartScreen(
                        isShowPercent: true,
                        currentList: _transactionList,
                        categoryList: _categoryList,
                        total: _total),
                  ),
                  Container(
                    child: PieChartInformationScreen(
                      currentList: _transactionList,
                      categoryList: _categoryList,
                      currentWallet: widget.currentWallet,
                      color: _color,
                    ),
                  )
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
