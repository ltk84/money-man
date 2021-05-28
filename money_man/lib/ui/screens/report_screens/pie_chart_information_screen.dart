
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/iconModel.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/ui/screens/report_screens/report_list_transaction_in_time.dart';

class PieChartInformationScreen extends StatefulWidget {
  List<MyTransaction> currentList;
  List<MyCategory> categoryList;
  final Wallet currentWallet;
  Color color;
  PieChartInformationScreen({Key key,@required this.currentList, @required this.categoryList , @required this.color, this.currentWallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PieChartInformationScreen();
}

class _PieChartInformationScreen extends State<PieChartInformationScreen>  {
  double _total;
  int touchedIndex = -1;
  List<MyTransaction> _transactionList;
  List<List<MyTransaction>> _listTransactionOfEachCatecory = [];
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
  int b=0;
  double calculateByCategory(MyCategory category, List<MyTransaction> transactionList) {
    double sum = 0;
    DateTime _endDate;
    transactionList.forEach((element) {
      if (element.category.name == category.name) {
        sum += element.amount;
      }
    });
    final b = transactionList.where(
            (element) => element.category.name == category.name);
    _listTransactionOfEachCatecory.add(b.toList());
    _listTransactionOfEachCatecory[_listTransactionOfEachCatecory.length-1].sort((a, b) => b.date.compareTo(a.date));
    return sum;
  }
  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList;
    _transactionList.sort((a, b) => b.date.compareTo(a.date));
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
    _transactionList.sort((a, b) => b.date.compareTo(a.date));
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
          return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ReportListTransaction(
                            currentList: _listTransactionOfEachCatecory[index],
                            endDate: _listTransactionOfEachCatecory[index][0].date,
                            beginDate: _listTransactionOfEachCatecory[index][_listTransactionOfEachCatecory[index].length-1].date,
                            totalMoney: _listTransactionOfEachCatecory[index][0].category.type== 'expense'? -_info[index] : _info[index] ,
                            currentWallet: widget.currentWallet,
                          )
                      )
                  );
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                            child: SuperIcon(
                              iconPath:_listCategoryReport[index].iconID,
                              size: 35,
                            )
                        ),
                        Expanded(child: Text(_listCategoryReport[index].name,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),),
                        Column(
                          children: <Widget>[
                            Text(_listCategoryReport[index].type == 'expense'?
                            '-' + _info[index].toString() :
                            '+' + _info[index].toString(),
                                style: TextStyle(color: _color, fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 25,
                    )
                  ],
                ),
          );
        },
      ),
    );
  }
}