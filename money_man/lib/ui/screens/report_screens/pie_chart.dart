import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:random_color/random_color.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class PieChartScreen extends StatefulWidget {
  List<MyTransaction> currentList;
  List<MyCategory> categoryList;
  bool isShowPercent;
  double total;
  PieChartScreen({Key key, @required this.currentList, @required this.isShowPercent,@required this.categoryList, @required this.total, }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChartScreenState();
}

class PieChartScreenState extends State<PieChartScreen>  {
  double _total;
  int touchedIndex = -1;
  bool _isShowPercent;
  List<MyTransaction> _transactionList;
  List<MyCategory> _categoryList;
  List<double> _info = [];

  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList;
    _categoryList = widget.categoryList;
    _total = widget.total;
    _isShowPercent = widget.isShowPercent;
    generateData(_categoryList, _transactionList);
  }

  @override
  void didUpdateWidget(covariant PieChartScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _transactionList = widget.currentList ?? [];
    _categoryList = widget.categoryList ?? [];
    _total = widget.total;
    _isShowPercent = widget.isShowPercent;
    generateData(_categoryList, _transactionList);
  }

  void generateData (List<MyCategory> categoryList, List<MyTransaction> transactionList) {
    categoryList.forEach((element) {
      _info.add(calculateByCategory(element,transactionList));
    });
  }

  double calculateByCategory(MyCategory category, List<MyTransaction> transactionList) {
    double sum = 0;
    transactionList.forEach((element) {
      if (element.category == category)
        sum += element.amount;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          AspectRatio(
            aspectRatio: 1.3,
            child: Container(
              color: Colors.transparent,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      borderData: FlBorderData(
                        show: false,
                      ),
                      startDegreeOffset: 270,
                      sectionsSpace: 0,
                      centerSpaceRadius: 17,
                      sections: showingSubSections()),
                ),
              ),
            ),
          ),
          AspectRatio(
            aspectRatio: 1.3,
            child: Container(
              color: Colors.transparent,
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;
                          if (desiredTouch && pieTouchResponse.touchedSection != null) {
                            touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      startDegreeOffset: 270,
                      sectionsSpace: 0,
                      centerSpaceRadius: 25,
                      sections: showingSections()),
                ),
              ),
            ),
          ),
        ]
    );
  }

  List<PieChartSectionData> showingSections() {
    return (_categoryList.length != 0) ? List.generate(
        _categoryList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 28.0 : 18.0;
      final widgetSize = isTouched ? 40.0 : 20.0;

      var value = ((_info[i]/_total)*100).round();

      List<Color> colors = [
        Color(0xFF678f8f).withOpacity(0.5),
        Color(0xFF23cc9c),
        Color(0xFF2981d9),
        Color(0xFFe3b82b),
        Color(0xFFe68429),
        Color(0xFFcf3f1f),
        Color(0xFFbf137a),
        Color(0xFF621bbf),
      ];
      return PieChartSectionData(
        color: i < colors.length ? colors[i] : Colors.grey,
        value: value.toDouble(),
        showTitle: _isShowPercent,
        //title: value.toString() + '%',
        radius: radius,
        titleStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700 ,
            fontFamily: 'Montserrat' ),
        badgeWidget: _Badge(
          _categoryList[i].iconID, // category icon.
          size: _isShowPercent ? 30 : widgetSize,
          borderColor: i < colors.length ? colors[i] : Colors.grey,
        ),
        badgePositionPercentageOffset: .98,
      );
    }) : List.generate(1, (i) {
      return PieChartSectionData(
        color: Colors.grey[900],
        value: 100,
        showTitle: false,
        radius: 15.0,
      );
    });
  }
  List<PieChartSectionData> showingSubSections() {
    return (_categoryList.length != 0) ? List.generate(
        _categoryList.length, (i) {
      //final isTouched = i == touchedIndex;
      //final fontSize = isTouched ? 16.0 : 14.0;
      final radius = 8.0;
      final widgetSize = 20.0;

      var value = ((_info[i]/_total)*100).round();
      List<Color> colors = [
        Color(0xFF678f8f).withOpacity(0.5),
        Color(0xFF23cc9c),
        Color(0xFF2981d9),
        Color(0xFFe3b82b),
        Color(0xFFe68429),
        Color(0xFFcf3f1f),
        Color(0xFFbf137a),
        Color(0xFF621bbf),
      ];

      return PieChartSectionData(
        color: i < colors.length ? colors[i].withOpacity(0.4) : Colors.grey.withOpacity(0.4),
        value: value.toDouble(),
        showTitle: false,
        radius: radius,
      );
    }) : List.generate(1, (i) {
      return PieChartSectionData(
        color: Colors.grey[900],
        value: 100,
        showTitle: false,
        radius: 15.0,
      );
    });
  }
}

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const _Badge(
      this.svgAsset, {
        Key key,
        @required this.size,
        @required this.borderColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      //padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}