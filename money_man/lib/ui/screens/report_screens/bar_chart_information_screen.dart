import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';

class BarChartInformationScreen extends StatefulWidget{
  @override
  _BarChartInformationScreen createState() =>  _BarChartInformationScreen();
}
class  _BarChartInformationScreen extends State<BarChartInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 300,
      width: 700,
      padding: EdgeInsets.all(5),
      child: Expanded(
        child: Barchart(),
      ),
    );
  }
}