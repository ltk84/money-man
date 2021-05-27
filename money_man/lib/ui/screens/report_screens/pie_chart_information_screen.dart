
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/categoryModel.dart';

class PieChartInformationScreen extends StatefulWidget {
  List<MyTransaction> currentList;
  List<MyCategory> categoryList;
  Color color;
  PieChartInformationScreen({Key key, @required this.currentList, @required this.categoryList , @required this.color}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PieChartInformationScreen();
}

class _PieChartInformationScreen extends State<PieChartInformationScreen>  {
  double _total;
  int touchedIndex = -1;
  List<MyTransaction> _transactionList;
  List<MyCategory> _categoryList;
  List<double> _info = [];
  Color _color;
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;
  List<MyCategory> _listCategoryReport = [];
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
  bool isContained(MyCategory currentCategory, List<MyCategory> categoryList)
  {
    if(categoryList.isEmpty) return false;
    int n = 0;
    categoryList.forEach((element) {
      if(element.name == currentCategory.name)
        n+=1;
    });
    if(n == 1)
      return true;
    return false;
  }
  void generateData (List<MyCategory> categoryList, List<MyTransaction> transactionList) {

    categoryList.forEach((element) {
      if(!isContained(element,_listCategoryReport))
      {
        _listCategoryReport.add(element);
      }
    });
    _listCategoryReport.forEach((element) {
      _info.add(calculateByCategory(element, transactionList));
    });
  }

  double calculateByCategory(MyCategory category, List<MyTransaction> transactionList) {
    double sum = 0;
    transactionList.forEach((element) {
      if (element.category.name == category.name)
        sum += element.amount;
    });
    return sum;
  }
  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList;
    _categoryList = widget.categoryList;
    _controller = ScrollController();
    _color = widget.color;
    _controller.addListener(_scrollListener);
    generateData(_categoryList, _transactionList);
  }

  @override
  void didUpdateWidget(covariant PieChartInformationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _transactionList = widget.currentList ?? [];
    _categoryList = widget.categoryList ?? [];
    _controller = ScrollController();
    _color = widget.color;
    _controller.addListener(_scrollListener);

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450,
      height: 450,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.yellow,
                width: 1.0,
              ))),
      padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        itemCount: _listCategoryReport.length,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_listCategoryReport[index].name,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Column(
                    children: <Widget>[
                      Text(_info[index].toString(),
                          style: TextStyle(color: _color, fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
              Container(
                height: 25,
              )
            ],
          );
        },
      ),
    );
  }
}