import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class LineCharts extends StatefulWidget {
  LineCharts({Key key, @required this.budget, this.todayRate, this.todayTaget})
      : super(key: key);
  final todayRate;
  final todayTaget;

  final Budget budget;

  @override
  _LineChartsState createState() => _LineChartsState();
}

class _LineChartsState extends State<LineCharts> {
  String fomatDate(DateTime variable) {
    return 'kkk';
  }

  String fomatMonney(double money) {
    if (money > 1000000000)
      return (money / 1000000000).toStringAsFixed(1) + 'B';
    else if (money > 1000000)
      return (money / 1000000).toStringAsFixed(1) + 'M';
    else if (money > 1000)
      return (money / 1000).toStringAsFixed(1) + 'K';
    else
      return money.toStringAsFixed(1);
  }

  double getMaxofY(Budget budget) {
    if (widget.todayRate > 1) {
      return budget.spent > budget.amount ? budget.spent : budget.amount;
    }
    if (widget.todayRate < 0) {
      return budget.amount;
    } else {
      return budget.spent / widget.todayRate > budget.amount
          ? budget.spent / widget.todayRate
          : budget.amount;
    }
  }

  Future<List<FlSpot>> getSpot(
      Budget budget,
      FirebaseFireStoreService _firestore,
      double maxOfY,
      double todayRate) async {
    if (DateTime.now().isBefore(budget.beginDate))
      return [
        FlSpot(0, 0),
        FlSpot(0, 0),
        FlSpot(0, 0),
        FlSpot(0, 0),
      ];

    List<FlSpot> mSpot = [];
    var temp = budget.beginDate;
    var end = budget.endDate.isBefore(DateTime.now())
        ? budget.endDate
        : DateTime.now();
    var difference = end.difference(budget.beginDate).inMinutes / 6;
    for (double i = 0; i < 7; i++) {
      temp = temp.add(Duration(minutes: difference.toInt()));
      var spent = await _firestore.calculateBudgetSpentFromDay(budget, temp);
      var YAxix = spent / maxOfY * 5;
      mSpot.add(FlSpot(i * todayRate, YAxix));
    }
    return mSpot;
  }

  List<FlSpot> GetmSpot(List<FlSpot> mSpot1) {
    mSpot1.add(FlSpot(6,
        widget.budget.spent / widget.todayRate * 5 / getMaxofY(widget.budget)));
    return mSpot1;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    var maxOfY = getMaxofY(widget.budget);
    const cutOffYValue = 0.0;
    const yearTextStyle =
        TextStyle(fontSize: 10, color: Colors.white, fontFamily: 'Montserrat');

    TextStyle getTextStyle(double b) {
      return yearTextStyle;
    }

    return FutureBuilder<Object>(
        future: getSpot(widget.budget, _firestore, maxOfY, widget.todayRate),
        builder: (context, snapshot) {
          List<FlSpot> mSpot = snapshot.data ??
              [
                FlSpot(0, 0),
                FlSpot(0, 0),
                FlSpot(0, 0),
                FlSpot(0, 0),
              ];
          //var mSpot2 = GetmSpot(mSpot);
          return Container(
            padding: EdgeInsets.only(left: 15),
            child: SizedBox(
              width: 330,
              height: 160,
              child: LineChart(
                LineChartData(
                  extraLinesData: ExtraLinesData(horizontalLines: [
                    HorizontalLine(
                      y: widget.budget.amount / maxOfY * 5,
                      color: Colors.redAccent,
                      strokeWidth: 1,
                    ),
                  ]),
                  lineTouchData: LineTouchData(enabled: false),
                  lineBarsData: [
                    // Này là để điều chỉnh cái đồ thị
                    LineChartBarData(
                      spots: 1 == 1
                          ? mSpot
                          : widget.todayRate < 0
                              ? [
                                  FlSpot(0, 0),
                                  FlSpot(0, 0),
                                  FlSpot(0, 0),
                                  FlSpot(0, 0),
                                ]
                              : widget.todayRate > 1
                                  ? [
                                      FlSpot(0, 0),
                                      FlSpot(1, 0),
                                      FlSpot(2, 0),
                                      FlSpot(3, 0),
                                      FlSpot(4, 0),
                                      FlSpot(5, 0),
                                      FlSpot(6, 0),
                                    ]
                                  : [],
                      isCurved: false,
                      barWidth: 2,
                      colors: [
                        Color(0xFF2FB49C),
                      ],
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.green.withOpacity(0.5)],
                        cutOffY: cutOffYValue,
                        applyCutOffY: true,
                      ),
                      aboveBarData: BarAreaData(
                        show: true,
                        colors: [Colors.red.withOpacity(0.6)],
                        cutOffY: cutOffYValue,
                        applyCutOffY: true,
                      ),
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 0),
                        FlSpot(0, 0),
                        FlSpot(0, 0),
                        FlSpot(0, 0),
                        FlSpot(0, 0),
                        FlSpot(0, 0),
                        FlSpot(0, 0),
                      ], //mSpot2,
                      isCurved: false,
                      barWidth: 2,
                      colors: [
                        Color(0xFF2FB49C),
                      ],
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.green.withOpacity(0)],
                        cutOffY: cutOffYValue,
                        applyCutOffY: true,
                      ),
                      aboveBarData: BarAreaData(
                        show: true,
                        colors: [Colors.red.withOpacity(0.6)],
                        cutOffY: cutOffYValue,
                        applyCutOffY: true,
                      ),
                      dashArray: [2, 4],
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                    LineChartBarData(
                      spots: [
                        mSpot.last,
                        FlSpot(6,
                            widget.budget.spent / widget.todayRate * 5 / maxOfY)
                      ], //mSpot2,
                      isCurved: false,
                      barWidth: 2,
                      colors: [
                        Color(0xFF2FB49C),
                      ],
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.white.withOpacity(0.2)],
                        cutOffY: cutOffYValue,
                        applyCutOffY: true,
                      ),
                      aboveBarData: BarAreaData(
                        show: true,
                        colors: [Colors.red.withOpacity(0.6)],
                        cutOffY: cutOffYValue,
                        applyCutOffY: true,
                      ),
                      dashArray: [2, 4],
                      dotData: FlDotData(
                        show: false,
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 6,
                  // Này để điều chỉnh những vị trí giá trị biểu thị trên đề thị nề
                  titlesData: FlTitlesData(
                    bottomTitles: SideTitles(
                        margin: 10,
                        showTitles: true,
                        reservedSize: 6,
                        getTextStyles: getTextStyle,
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 0:
                              return fomatDate(widget.budget.beginDate);
                            case 6:
                              return '2019';
                              return '';
                          }
                        }),
                    leftTitles: SideTitles(
                      margin: 15,
                      getTextStyles: getTextStyle,
                      showTitles: true,
                      // này là giá trị của các cột nè, val chạy từ 0 tới maxY
                      getTitles: (value) {
                        if (value == 0) return '0.0';
                        return '${fomatMonney(value * maxOfY / 5)}';
                      },
                    ),
                  ),
                  // Này là để điều chỉnh grid của cái nền đồ thị
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (double value) {
                      return FlLine(color: Colors.white, strokeWidth: 0.2);
                    },
                    checkToShowHorizontalLine: (double value) {
                      return true;
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
