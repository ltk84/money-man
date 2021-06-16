import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/ui/style.dart';

class BarChartScreen extends StatefulWidget {
  final List<MyTransaction> currentList;
  final DateTime beginDate;
  final DateTime endDate;
  BarChartScreen({Key key, this.currentList, this.beginDate, this.endDate})
      : super(key: key);
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

  void generateData(
      DateTime beginDate,
      DateTime endDate,
      List<String> timeRangeList,
      List<MyTransaction> transactionList,
      List<BarChartGroupData> rawBarGroups) {
    rawBarGroups.clear();
    timeRangeList.clear();
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);
    int dayRange = (value.duration >= Duration(days: 6)) ? 6
        : (value.duration.inDays == 0) ? 1 : value.duration.inDays;
    List<dynamic> calculationList = [];
    var x = (value.duration.inDays / dayRange).round();
    var firstDate = beginDate.subtract(Duration(days: 1));
    for (int i = 0; i < dayRange; i++) {
      firstDate = firstDate.add(Duration(days: 1));
      var secondDate = (i != dayRange - 1) ? firstDate.add(Duration(days: x)) : endDate;

      var calculation =
          calculateByTimeRange(firstDate, secondDate, transactionList);
      calculationList.add(calculation);
      double temp = calculation.first > calculation.last
          ? calculation.first
          : calculation.last;
      if (temp > _maximumAmount) _maximumAmount = temp;
      timeRangeList
          .add(firstDate.day.toString() + "-" + secondDate.day.toString());
      firstDate = firstDate.add(Duration(days: x));
    }
    if (!calculationList.isEmpty) {
      for (int i = 0; i < calculationList.length; i++) {
        var barGroup = makeGroupData(
            i,
            (calculationList[i].first * 19) / _maximumAmount.round(),
            (calculationList[i].last * 19) / _maximumAmount.round());
        rawBarGroups.add(barGroup);
      }
    }
  }

  List<double> calculateByTimeRange(DateTime beginDate, DateTime endDate,
      List<MyTransaction> transactionList) {
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

  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList ?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    _maximumAmount = 1;
    // _maximumAmount = (_transactionList != null && _transactionList.isNotEmpty)
    //     ? _transactionList.map<double>((e) => e.amount).reduce(max)
    //     : 10000;
    generateData(
        _beginDate, _endDate, timeRangeList, _transactionList, rawBarGroups);
    showingBarGroups = rawBarGroups;
  }

  @override
  void didUpdateWidget(covariant BarChartScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _transactionList = widget.currentList ?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    _maximumAmount = 1;

    // _maximumAmount = (_transactionList != null && _transactionList.isNotEmpty)
    //     ? _transactionList.map<double>((e) => e.amount).reduce(max)
    //     : 10000;
    generateData(
        _beginDate, _endDate, timeRangeList, _transactionList, rawBarGroups);
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

                            touchedGroupIndex =
                                response.spot.touchedBarGroupIndex;

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
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                    sum += rod.y;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
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
                          margin: 10,
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
                          margin: 10,
                          reservedSize: 50,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            } else if (value == 10) {
                              return (_maximumAmount / 2).round().toString();
                            } else if (value == 20) {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: width*2,
                            width: width,
                            decoration: BoxDecoration(
                              color: leftBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                              'Total income',
                              style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0,
                                color: foregroundColor.withOpacity(0.54),
                              )
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: width*2,
                            width: width,
                            decoration: BoxDecoration(
                              color: rightBarColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                              'Total expense',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: foregroundColor.withOpacity(0.54),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 6),
                            height: 14,
                            width: 2,
                            color: foregroundColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                              'Amount',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: foregroundColor.withOpacity(0.54),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            height: 2,
                            width: 14,
                            color: foregroundColor,
                          ),
                          SizedBox(width: 10),
                          Text(
                              'Time range (day)',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                              color: foregroundColor.withOpacity(0.54),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Container(
              //           height: width*2,
              //           width: width,
              //           decoration: BoxDecoration(
              //             color: leftBarColor,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         SizedBox(height: 10),
              //         Container(
              //           height: 14,
              //           width: 2,
              //           color: foregroundColor,
              //         ),
              //       ],
              //     ),
              //     SizedBox(width: 10),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('Total income'),
              //         SizedBox(height: 10),
              //         Text('Amount'),
              //       ],
              //     ),
              //     SizedBox(width: 80),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Container(
              //           height: width*2,
              //           width: width,
              //           decoration: BoxDecoration(
              //             color: rightBarColor,
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //         ),
              //         SizedBox(height: 10),
              //         Container(
              //           height: 2,
              //           width: 14,
              //           color: foregroundColor,
              //         ),
              //       ],
              //     ),
              //     SizedBox(width: 10),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text('Total expense'),
              //         SizedBox(height: 10),
              //         Text('Time range (day)'),
              //       ],
              //     ),
              //     // Column(
              //     //   crossAxisAlignment: CrossAxisAlignment.start,
              //     //   children: [
              //     //     Row(
              //     //       mainAxisAlignment: MainAxisAlignment.center,
              //     //       children: [
              //     //         Container(
              //     //           height: width*2,
              //     //           width: width,
              //     //           decoration: BoxDecoration(
              //     //             color: leftBarColor,
              //     //             borderRadius: BorderRadius.circular(10),
              //     //           ),
              //     //         ),
              //     //         SizedBox(width: 10,),
              //     //         Text('Total income'),
              //     //       ],
              //     //     ),
              //     //     Row(
              //     //       mainAxisAlignment: MainAxisAlignment.center,
              //     //       children: [
              //     //         Container(
              //     //           height: width*2,
              //     //           width: width,
              //     //           color: foregroundColor,
              //     //         ),
              //     //         SizedBox(width: 10,),
              //     //         Text('Amount'),
              //     //       ],
              //     //     )
              //     //   ],
              //     // ),
              //     // SizedBox(width: 80,),
              //     // Column(
              //     //   crossAxisAlignment: CrossAxisAlignment.start,
              //     //   children: [
              //     //     Row(
              //     //       mainAxisAlignment: MainAxisAlignment.center,
              //     //       children: [
              //     //         Container(
              //     //           height: width*2,
              //     //           width: width,
              //     //           decoration: BoxDecoration(
              //     //             color: rightBarColor,
              //     //             borderRadius: BorderRadius.circular(10),
              //     //           ),
              //     //         ),
              //     //         SizedBox(width: 10,),
              //     //         Text('Total expense'),
              //     //       ],
              //     //     ),
              //     //     Row(
              //     //       mainAxisAlignment: MainAxisAlignment.center,
              //     //       children: [
              //     //         Container(
              //     //           height: width*2,
              //     //           width: width,
              //     //           color: foregroundColor,
              //     //         ),
              //     //         SizedBox(width: 10,),
              //     //         Text('Time range (day)'),
              //     //       ],
              //     //     )
              //     //   ],
              //     // ),
              //   ],
              // ),
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
