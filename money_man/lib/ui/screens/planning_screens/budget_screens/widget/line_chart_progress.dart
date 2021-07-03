import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LineCharts extends StatefulWidget {
  LineCharts({Key key, @required this.budget, this.todayRate, this.todayTaget})
      : super(key: key);
  final todayRate; // tỉ lệ ngày
  final todayTaget; // tỉ lệ spent/amoount
  final Budget budget; // budget hiện tại

  @override
  _LineChartsState createState() => _LineChartsState();
}

class _LineChartsState extends State<LineCharts> {
  // Điều chỉnh hiển thị ngày theo thứ tự ngày tháng năm
  String fomatDate(DateTime variable) {
    String result = DateFormat('dd/MM/yyyy').format(variable);
    return result;
  }

// Điều chỉnh hiển thị số tiền để dễ nhìn hơn, không phải đếm số 0
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

// Lấy giá trị lớn nhất của lược đồ
  double getMaxofY(Budget budget) {
    // ket thuc roi
    if (DateTime.now()
            .compareTo(widget.budget.endDate.add(Duration(days: 1))) >=
        0) {
      // lấy cái lớn hơn giữa spent và amount
      return budget.spent > budget.amount ? budget.spent : budget.amount;
    }
    // chưa bắt đầu
    if (DateTime.now().isBefore(budget.beginDate)) {
      // lấy amount thoi :v
      return budget.amount;
    } else {
      // tính toán nếu lúc kết thúc mà nó lớn hơn thì lấy cái lướn hơn, k thì lấy amount
      return budget.spent / widget.todayRate > budget.amount
          ? budget.spent / widget.todayRate
          : budget.amount;
    }
  }

// Này là lấy các điểm để tính toán trên lược đồ nè
  Future<List<FlSpot>> getSpot(
      Budget budget,
      FirebaseFireStoreService _firestore,
      double maxOfY,
      double todayRate) async {
    // truowngf hop chua bat dau thì làm gì có điểm nào :v nên cho đứng im tại chỗ
    if (DateTime.now().isBefore(budget.beginDate))
      return [
        FlSpot(0, 0),
        FlSpot(0, 0),
        FlSpot(0, 0),
        FlSpot(0, 0),
      ];
    // truong hop da ket thuc
    if (DateTime.now()
            .compareTo(widget.budget.endDate.add(Duration(days: 1))) >=
        0) {
      List<FlSpot> mSpot = [];
      var temp = budget.beginDate;
      var end = budget.endDate;
      // chia khoảng thời gian từ đầu tới cuối ra làm 6 khoảng, từ đó tính toán
      var difference = end.difference(budget.beginDate).inMinutes / 6;
      for (double i = 0; i < 6; i++) {
        temp = temp.add(Duration(minutes: difference.toInt()));
        var spent = await _firestore.calculateBudgetSpentFromDay(budget, temp);
        var yAxis = spent / maxOfY * 5;
        mSpot.add(FlSpot(i, yAxis));
      }
      return mSpot;
    }
    // cũng tương tự trên kia nhưng nó khác 1 xí :3 này phải nhân với todayRate để rút ngắn lại cái độ dài trục hoành
    List<FlSpot> mSpot = [];
    var temp = budget.beginDate;
    var end = DateTime.now();
    var difference = end.difference(budget.beginDate).inMinutes / 6;
    for (double i = 0; i < 7; i++) {
      temp = temp.add(Duration(minutes: difference.toInt()));
      var spent = await _firestore.calculateBudgetSpentFromDay(budget, temp);
      var yAxis = spent / maxOfY * 5;
      mSpot.add(FlSpot(i * todayRate, yAxis));
    }
    return mSpot;
  }

  @override
  Widget build(BuildContext context) {
    // Lấy để thực hiện hàm firebase
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
// Lấy giá trị max cho y nè
    var maxOfY = getMaxofY(widget.budget);
    const cutOffYValue = 0.0;
    // Style cho kí tự trong lược đồ
    var yearTextStyle = TextStyle(
        fontSize: 12,
        color: Style.foregroundColor,
        fontFamily: Style.fontFamily);
    TextStyle getTextStyle(double b) {
      return yearTextStyle;
    }

// Future để lấy mấy điểm đó nè
    return FutureBuilder<Object>(
        future: getSpot(widget.budget, _firestore, maxOfY, widget.todayRate),
        builder: (context, snapshot) {
          List<FlSpot> mSpot = snapshot.data ??
              [
                FlSpot(0, 0),
                FlSpot(0, 0),
                FlSpot(0, 0),
                FlSpot(0, 0),
                FlSpot(0, 0),
                FlSpot(0, 0),
              ];
          return Container(
            color: Style.backgroundColor,
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
                      spots: mSpot,
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
                    // này để ổn định cho khung đồ thị
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
                    // Này là phần chấm chấm
                    if (DateTime.now().compareTo(
                            widget.budget.endDate.add(Duration(days: 1))) <=
                        0)
                      LineChartBarData(
                        spots: [
                          mSpot.last,
                          FlSpot(
                              6,
                              widget.budget.spent /
                                  widget.todayRate *
                                  5 /
                                  maxOfY)
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
                              return fomatDate(widget.budget.endDate);
                            default:
                              return '';
                          }
                        }),
                    leftTitles: SideTitles(
                      margin: 20,
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
                      return FlLine(
                          color: Style.foregroundColor, strokeWidth: 0.2);
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
