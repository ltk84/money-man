import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineCharts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const cutOffYValue = 0.0;
    const yearTextStyle = TextStyle(
        fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold);

    TextStyle getTextStyle(double b) {
      return yearTextStyle;
    }

    return SizedBox(
      width: 330,
      height: 180,
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 0),
                FlSpot(1, 1),
                FlSpot(2, 3),
                FlSpot(3, 3),
                FlSpot(4, 5),
              ],
              isCurved: false,
              barWidth: 2,
              colors: [
                Color(0xFF2FB49C),
              ],
              belowBarData: BarAreaData(
                show: true,
                colors: [Colors.yellow.withOpacity(0)],
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
          ],
          minY: 0,
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 6,
                getTextStyles: getTextStyle,
                getTitles: (value) {
                  switch (value.toInt()) {
                    case 0:
                      return '2015';
                    case 1:
                      return '2016';
                    case 2:
                      return '2017';
                    case 3:
                      return '2018';
                    case 4:
                      return '2019';
                    default:
                      return '';
                  }
                }),
            leftTitles: SideTitles(
              getTextStyles: getTextStyle,
              showTitles: true,
              getTitles: (value) {
                return '\$ ${value + 20}';
              },
            ),
          ),
          axisTitleData: FlAxisTitleData(
              leftTitle: AxisTitle(
                  textStyle: yearTextStyle,
                  showTitle: true,
                  titleText: 'Value',
                  margin: 10),
              bottomTitle: AxisTitle(
                  showTitle: true,
                  margin: 10,
                  titleText: 'Year',
                  textStyle: yearTextStyle,
                  textAlign: TextAlign.right)),
          gridData: FlGridData(
            show: true,
            getDrawingHorizontalLine: (double value) {
              return FlLine(
                  color:
                      value == 2 ? Colors.red : Colors.white.withOpacity(0.2),
                  strokeWidth: 1);
            },
            checkToShowHorizontalLine: (double value) {
              return value == 5 ||
                  value == 1 ||
                  value == 2 ||
                  value == 3 ||
                  value == 4;
            },
          ),
        ),
      ),
    );
  }
}
