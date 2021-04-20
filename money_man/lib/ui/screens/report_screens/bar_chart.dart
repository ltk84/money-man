import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts ;

void main() => runApp(Barchart());

class Barchart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
class Transaction{
  final String time;
  final int money;
  final charts.Color barColor;

  Transaction(
      {@required this.time,
        @required this.money,
        @required this.barColor});
}
class HomePage extends StatelessWidget {
  final List<Transaction> data = [
    Transaction(
      time: "2008",
      money: 1000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2009",
      money: 1100,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2010",
      money: 1200,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2011",
      money: 1000,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2012",
      money: 850,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2013",
      money: 770,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2014",
      money: 760,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Transaction(
      time: "2015",
      money: 550,
      barColor: charts.ColorUtil.fromDartColor(Colors.red),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Transaction, String>> series = [
      charts.Series(
          id: "Transaction",
          data: data,
          domainFn: (Transaction series, _) => series.time,
          measureFn: (Transaction series, _) => series.money,
          colorFn: (Transaction series, _) => series.barColor)
    ];
    return Container(
      height: 400,
      padding: EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(
                "Report all balance",
                style: Theme.of(context).textTheme.body2,
              ),
              Expanded(
                child: charts.BarChart(series, animate: true),
              )
            ],
          ),
        ),
      ),
    );
  }
}
