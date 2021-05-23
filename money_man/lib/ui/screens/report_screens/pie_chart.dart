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
  double total;
  PieChartScreen({Key key, @required this.currentList, @required this.categoryList, @required this.total }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChartScreenState();
}

class PieChartScreenState extends State<PieChartScreen>  {
  double _total;
  int touchedIndex = -1;
  List<MyTransaction> _transactionList;
  List<MyCategory> _categoryList;
  List<double> _info = [];


  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList;
    _categoryList = widget.categoryList;
    _total = widget.total;
    generateData(_categoryList, _transactionList);
  }

  @override
  void didUpdateWidget(covariant PieChartScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _transactionList = widget.currentList ?? [];
    _categoryList = widget.categoryList ?? [];
    _total = widget.total;
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
    return AspectRatio(
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
                centerSpaceRadius: 20,
                sections: showingSections()),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return (_categoryList.length != 0) ? List.generate(
        _categoryList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 30.0 : 20.0;
      final widgetSize = isTouched ? 40.0 : 20.0;

      var value = ((_info[i]/_total)*100).round();

      // RandomColor _randomColor = RandomColor();
      // Color _color = _randomColor.randomColor(
      //   colorHue: _categoryList[0].type == 'expense' ? ColorHue.green : ColorHue.green,
      //   colorBrightness: ColorBrightness.dark,
      //   colorSaturation: ColorSaturation.highSaturation
      // );

      List<Color> colors = [
        Color(0xFFFFF200), Color(0xFFFC6600), Color(0xFFD30000), Color(0xFFFC0FC0), Color(0xFFB200ED),
        Color(0xFF0018F9), Color(0xFF3BB143), Color(0xFF7C4700), Color(0xFF828282), Color(0xFFF8DE7E),
        Color(0xFFF9A602), Color(0xFFFA8072), Color(0xFFE0115F), Color(0xFFB43757), Color(0xFF131E3A),
        Color(0xFF0B6623), Color(0xFF4B3A26), Color(0xFF787276), Color(0xFFFCD12A), Color(0xFFFFBF00),
        Color(0xFFC21807), Color(0xFFFBAED2), Color(0xFF8660CD), Color(0xFF89CFEF), Color(0xFF00A86B),
        Color(0xFF997950), Color(0xFFBEBDB8), Color(0xFFEFFD5F), Color(0xFF000080), Color(0xFF2B1700),
      ];

      return PieChartSectionData(
        color: colors[i],
        value: value.toDouble(),
        showTitle: false,
        //title: value.toString() + '%',
        radius: radius,
        // titleStyle: TextStyle(
        //     fontSize: fontSize,
        //     fontWeight: FontWeight.bold,
        //     color: const Color(0xffffffff)),
        badgeWidget: _Badge(
          'assets/icons/hotdog.svg', // category icon.
          size: widgetSize,
          borderColor: colors[i],
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
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}