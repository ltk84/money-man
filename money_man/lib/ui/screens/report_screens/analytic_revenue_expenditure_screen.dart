import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';

class AnalyticRevenueAndExpenditure extends StatefulWidget{
  @override
  _AnalyticRevenueAndExpenditure createState() => _AnalyticRevenueAndExpenditure();
}
class NetIncome{
  final String time;
  final int money;

  NetIncome(
      {@required this.time,
        @required this.money,});
}
class _AnalyticRevenueAndExpenditure  extends State<AnalyticRevenueAndExpenditure>{
  @override
  final List<NetIncome> data = [
    NetIncome(
      time: "2008",
      money: 1000,
    ),
    NetIncome(
      time: "2009",
      money: 1100,
    ),
    NetIncome(
      time: "2010",
      money: 1200,
    ),
    NetIncome(
      time: "2011",
      money: 1000,
    ),
    NetIncome(
      time: "2012",
      money: 850,
    ),
    NetIncome(
      time: "2013",
      money: 770,
    ),
    NetIncome(
      time: "2014",
      money: 760,
    ),
    NetIncome(
      time: "2015",
      money: 550,
    ),
  ];
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
          backgroundColor:Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(0,10,100,10),
                        child: Column(
                          children: <Widget>[
                            Text('Net Income',style: TextStyle(color: Colors.white)),
                            Text('100\$',style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      width: 450,
                      height:200,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 450,
                            height: 200,
                            child: Barchart(),
                          ),
                          IconButton(
                              icon: Icon(Icons.web_outlined),
                              color: Colors.transparent,
                              iconSize: 300,
                              onPressed: (){
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Barchart();
                                    });
                              }
                          )
                        ],
                      )
                  ),
                ]
            ),
          ],
        ),
      ),
    );
  }
}