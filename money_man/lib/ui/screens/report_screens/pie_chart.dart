import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

//void main() => runApp(Piechart(lg));

class Piechart extends StatelessWidget {
  @override
  bool legend;
  Piechart(bool lg){
    legend = lg;
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _Piechart(legend),
    );
  }
}
class _Piechart extends StatelessWidget {
  bool _legend;
  _Piechart(bool lg){
    _legend = lg;
  }
  final Map<String, double> dataMap = {
    "Drink": 500,
    "Mean": 300,
    "Plan": 200,
    "Transport": 200,
  };
  List<Color> colorList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
  ];
  ChartType _chartType = ChartType.ring;
  bool _showCenterText = false;
  double _ringStrokeWidth = 32;
  double _chartLegendSpacing = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = false;

  bool _showChartValueBackground = true;
  bool _showChartValues =false;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;

  LegendOptions _options = LegendOptions(legendShape: BoxShape.circle );
  LegendPosition _legendPosition = LegendPosition.right;
  int k = 0;
  @override
  Widget build(BuildContext context) {
    final chart = PieChart(

      key: ValueKey(key),
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: _chartLegendSpacing,
      chartRadius: MediaQuery.of(context).size.width / 3.2 > 300
          ? 300
          : MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: _chartType,
      centerText: _showCenterText ? "Money" : null,
      legendOptions: LegendOptions(
        showLegendsInRow: _showLegendsInRow,
        legendPosition: _legendPosition,
        showLegends: (_legend == true)?true:false,
        legendShape: _options == BoxShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        legendTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.white
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: _showChartValueBackground,
        showChartValues: (_legend == true)?true:false,
        showChartValuesInPercentage: _showChartValuesInPercentage,
        showChartValuesOutside: _showChartValuesOutside,
      ),
      ringStrokeWidth: _ringStrokeWidth,
      emptyColor: Colors.white,
    );
    return Container(
      child:  chart,
    );
  }
}

