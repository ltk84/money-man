import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'dart:math';

class BarChartScreen extends StatefulWidget {
  final List<MyTransaction> currentList;
  final DateTime beginDate;
  final DateTime endDate;
  BarChartScreen({Key key, this.currentList, this.beginDate, this.endDate}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BarChartScreenState();
}

class BarChartScreenState extends State<BarChartScreen> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  List<MyTransaction> _transactionList = [];
  DateTime _beginDate;
  DateTime _endDate;
  double _maximumAmount;

  List<String> timeRangeList = [];

  int touchedGroupIndex;

  void generateData (DateTime beginDate, DateTime endDate, List<String> timeRangeList, List<MyTransaction> transactionList, List<BarChartGroupData> rawBarGroups){
    rawBarGroups.clear();
    timeRangeList.clear();
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);
    if (value.duration >= Duration(days: 6))
    {
      var x = (value.duration.inDays/6).round();
      var firstDate = beginDate.subtract(Duration(days: 1));
      for (int i = 0; i < 6; i++) {
        firstDate = firstDate.add(Duration(days: 1));
        var secondDate = (i != 5) ? firstDate.add(Duration(days: x)) : endDate;

        var calculation = calculateByTimeRange(firstDate, secondDate, transactionList);
        var barGroup = makeGroupData(i, (calculation.first*19)/_maximumAmount.round(), (calculation.last*19)/_maximumAmount.round());
        rawBarGroups.add(barGroup);

        timeRangeList.add(firstDate.day.toString() + "-" + secondDate.day.toString());
        firstDate = firstDate.add(Duration(days: x));
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
  void didUpdateWidget(covariant BarChartScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _transactionList = widget.currentList ?? [];

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
        //color: const Color(0xff2c4260),
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex = response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is PointerExitEvent ||
                                  response.touchInput is PointerUpEvent) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                  in showingBarGroups[touchedGroupIndex].barRods) {
                                    sum += rod.y;
                                  }
                                  final avg =
                                      sum / showingBarGroups[touchedGroupIndex].barRods.length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex].copyWith(
                                        barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                                          return rod.copyWith(y: avg);
                                        }).toList(),
                                      );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                          margin: 5,
                          getTitles: (double value) {
                            return timeRangeList[value.toInt()];
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                          ),
                          margin: 5,
                          reservedSize: 50,
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
                      gridData: FlGridData(
                        show: true,
                        checkToShowHorizontalLine: (value) => value % 2 == 0,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.white24,
                          strokeWidth: 1,
                        ),
                        drawHorizontalLine: true,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          top: BorderSide(
                            color: Colors.white24,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.white24,
                            width: 1,
                          ),
                        ),
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