import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'dart:math';

class BarChartScreen extends StatefulWidget {
  List<MyTransaction> currentList;
  DateTime beginDate;
  DateTime endDate;

  BarChartScreen({Key key, this.currentList, this.beginDate, this.endDate}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BarChartScreenState();
}

class BarChartScreenState extends State<BarChartScreen> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups;

  List<MyTransaction> _transactionList;
  DateTime _beginDate;
  DateTime _endDate;
  double _maximumAmount;

  List<String> timeRangeList = [];

  int touchedGroupIndex;

  void generateData (DateTime beginDate, DateTime endDate, List<String> timeRangeList, List<MyTransaction> transactionList, List<BarChartGroupData> rawBarGroups){
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);
    if (value.duration >= Duration(days: 6))
    {
      var x = (value.duration.inDays/6).round();
      var firstDate = beginDate.day.toInt() - 1;
      for (int i = 0; i < 6; i++) {
        firstDate += 1;
        var secondDate = (i != 5) ? firstDate + x : endDate.day.toInt();

        var calculation = calculateByTimeRange(beginDate, endDate, transactionList);
        var barGroup = makeGroupData(i, calculation.first, calculation.last);
        rawBarGroups.add(barGroup);

        timeRangeList.add(firstDate.toString() + "-" + secondDate.toString());
        firstDate += x;
      }
    }
  }

  List<double> calculateByTimeRange(DateTime beginDate, DateTime endDate, List<MyTransaction> transactionList) {
    double income = 0;
    double expense = 0;

    transactionList.forEach((element) {
      if (element.date.compareTo(beginDate) >= 0 && element.date.compareTo(endDate) <= 0) {
        if (element.category.type == 'expense')
          expense += element.amount;
        else
          income += element.amount;
      }
    });
    return [income, expense];
  }

  @override
  void initState() {
    super.initState();
    // final barGroup1 = makeGroupData(0, 5, 12);
    // final barGroup2 = makeGroupData(1, 16, 12);
    // final barGroup3 = makeGroupData(2, 18, 5);
    // final barGroup4 = makeGroupData(3, 20, 16);
    // final barGroup5 = makeGroupData(4, 17, 6);
    // final barGroup6 = makeGroupData(5, 19, 1.5);
    // final barGroup7 = makeGroupData(6, 10, 1.5);
    //
    // final items = [
    //   barGroup1,
    //   barGroup2,
    //   barGroup3,
    //   barGroup4,
    //   barGroup5,
    //   barGroup6,
    //   // barGroup7,
    // ];
    //
    // rawBarGroups = items;

    _transactionList = widget.currentList;
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    _maximumAmount = (_transactionList != null && _transactionList.isNotEmpty)
        ? _transactionList.map<double>((e) => e.amount).reduce(max)
        : 10000;

    generateData(_beginDate, _endDate, timeRangeList, _transactionList, rawBarGroups);
    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: <Widget>[
              //     makeTransactionsIcon(),
              //     const SizedBox(
              //       width: 38,
              //     ),
              //     const Text(
              //       'Transactions',
              //       style: TextStyle(color: Colors.white, fontSize: 22),
              //     ),
              //     const SizedBox(
              //       width: 4,
              //     ),
              //     const Text(
              //       'state',
              //       style: TextStyle(color: Color(0xff77839a), fontSize: 16),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 38,
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      // barTouchData: BarTouchData(
                      //     touchTooltipData: BarTouchTooltipData(
                      //       tooltipBgColor: Colors.grey,
                      //       getTooltipItem: (_a, _b, _c, _d) => null,
                      //     ),
                      //     touchCallback: (response) {
                      //       if (response.spot == null) {
                      //         setState(() {
                      //           touchedGroupIndex = -1;
                      //           showingBarGroups = List.of(rawBarGroups);
                      //         });
                      //         return;
                      //       }
                      //
                      //       touchedGroupIndex = response.spot.touchedBarGroupIndex;
                      //
                      //       setState(() {
                      //         if (response.touchInput is PointerExitEvent ||
                      //             response.touchInput is PointerUpEvent) {
                      //           touchedGroupIndex = -1;
                      //           showingBarGroups = List.of(rawBarGroups);
                      //         } else {
                      //           showingBarGroups = List.of(rawBarGroups);
                      //           if (touchedGroupIndex != -1) {
                      //             double sum = 0;
                      //             for (BarChartRodData rod
                      //             in showingBarGroups[touchedGroupIndex].barRods) {
                      //               sum += rod.y;
                      //             }
                      //             final avg =
                      //                 sum / showingBarGroups[touchedGroupIndex].barRods.length;
                      //
                      //             showingBarGroups[touchedGroupIndex] =
                      //                 showingBarGroups[touchedGroupIndex].copyWith(
                      //                   barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                      //                     return rod.copyWith(y: avg);
                      //                   }).toList(),
                      //                 );
                      //           }
                      //         }
                      //       });
                      //     }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            // switch (value.toInt()) {
                            //   case 0:
                            //     return 'Mn';
                            //   case 1:
                            //     return 'Te';
                            //   case 2:
                            //     return 'Wd';
                            //   case 3:
                            //     return 'Tu';
                            //   default:
                            //     return '';
                            // }
                            return timeRangeList[value.toInt()];
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                          margin: 32,
                          reservedSize: 25,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            } else if (value == 10) {
                              return (_maximumAmount/2).round().toString();
                            } else if (value == 19) {
                              return _maximumAmount.round().toString();
                            } else {
                              return '';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }
}