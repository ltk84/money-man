import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/report_list_transaction_in_time.dart';

class BarChartInformation extends StatefulWidget{
  final List<MyTransaction> currentList;
  final DateTime beginDate;
  final DateTime endDate;
  BarChartInformation({Key key, this.currentList, this.beginDate, this.endDate}) : super(key: key);
  @override
  _BarChartInformation createState() => _BarChartInformation();
}
class  _BarChartInformation extends State<BarChartInformation> {
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

  List<MyTransaction> _transactionList = [];
  DateTime _beginDate;
  DateTime _endDate;
  List<dynamic> calculationList = [];

  List<String> timeRangeList = [];
  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    generateData(_beginDate, _endDate, timeRangeList, _transactionList);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }
  @override
  void didUpdateWidget(covariant BarChartInformation oldWidget) {
    _transactionList = widget.currentList?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    generateData(_beginDate, _endDate, timeRangeList, _transactionList);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 450,
      height: 450,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ))),
      padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        itemCount: timeRangeList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ReportListTransaction())
              );
            },
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(timeRangeList[index],
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    Column(
                      children: <Widget>[
                        Text( (calculationList[index].first == 0)?"0.0":
                            "+" + calculationList[index].first.toString(),
                            style: TextStyle(color: Colors.green , fontSize: 16, fontWeight: FontWeight.bold)),
                        Text( (calculationList[index].last == 0)?"0.0":
                            "-" + calculationList[index].last.toString(),
                            style: TextStyle(color: Colors.red[600], fontSize: 16, fontWeight: FontWeight.bold)),
                        Text((calculationList[index].first-calculationList[index].last)>= 0?
                        "+" + (calculationList[index].first-calculationList[index].last).toString()
                            :(calculationList[index].first-calculationList[index].last).toString(),
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  void generateData(DateTime beginDate, DateTime endDate, List<String> timeRangeList, List<MyTransaction> transactionList) {
    timeRangeList.clear();
    calculationList.clear();
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);
    if (value.duration >= Duration(days: 6)) {
      var x = (value.duration.inDays / 6).round();
      var firstDate = beginDate.subtract(Duration(days: 1));
      for (int i = 0; i < 6; i++) {
        firstDate = firstDate.add(Duration(days: 1));
        var secondDate = (i != 5) ? firstDate.add(Duration(days: x)) : endDate;
        var calculation = calculateByTimeRange(firstDate, secondDate, transactionList);
        if (calculation.first != 0 || calculation.last != 0)
        {
          calculationList.add(calculation);
          timeRangeList.add(firstDate.day.toString() +"/" + firstDate.month.toString()+"-" +
              secondDate.day.toString() +"/" + secondDate.month.toString());
        }
        firstDate = firstDate.add(Duration(days: x));
      }
    }
  }

  List<double> calculateByTimeRange(DateTime beginDate,
      DateTime endDate, List<MyTransaction> transactionList) {
    double income = 0;
    double expense = 0;

    transactionList.forEach((element) {
      if (element.date.compareTo(beginDate) >= 0 &&
          element.date.compareTo(endDate) <= 0) {
        if (element.category.type == 'expense')
          expense += element.amount;
        else
          income += element.amount;
      }
    });
    return [income, expense];
  }
}