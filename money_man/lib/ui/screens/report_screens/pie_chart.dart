import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/ui/screens/report_screens/indicator_pie_chart.dart';
import 'package:money_man/ui/style.dart';

/// Icons by svgrepo.com (https://www.svgrepo.com/collection/job-and-professions-3/)
class PieChartScreen extends StatefulWidget {
  List<MyTransaction> currentList;
  List<MyCategory> categoryList;
  bool isShowPercent;
  double total;
  PieChartScreen({
    Key key,
    @required this.currentList,
    @required this.isShowPercent,
    @required this.categoryList,
    @required this.total,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => PieChartScreenState();
}

class PieChartScreenState extends State<PieChartScreen> {
  List<Color> colors = Style.pieChartCategoryColors;
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

  void generateData(
      List<MyCategory> categoryList, List<MyTransaction> transactionList) {
    _info.clear();
    categoryList.forEach((element) {
      _info.add(calculateByCategory(element, transactionList));
    });
  }

  double calculateByCategory(
      MyCategory category, List<MyTransaction> transactionList) {
    double sum = 0;
    transactionList.forEach((element) {
      if (element.category.name == category.name) sum += element.amount;
    });
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.scale(
          scale: _isShowPercent ? 1.6 : 1,
          child: Stack(children: [
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
                        pieTouchData: PieTouchData(
                            touchCallback: (pieTouchResponse) {
                              setState(() {
                                final desiredTouch =
                                    pieTouchResponse
                                        .touchInput is! PointerExitEvent &&
                                        pieTouchResponse
                                            .touchInput is! PointerUpEvent;
                                if (desiredTouch &&
                                    pieTouchResponse.touchedSection != null) {
                                  touchedIndex =
                                      pieTouchResponse.touchedSection
                                          .touchedSectionIndex;
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
          ]),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: _isShowPercent ? 50 : 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    _categoryList.length,
                        (index) =>
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle, // BoxShape.circle,
                                  color: index < colors.length ? colors[index] : Style.pieChartExtendedCategoryColor,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                _categoryList[index].name,
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: index < colors.length ? colors[index] : Style.pieChartExtendedCategoryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                  )
              ),
              if (_isShowPercent)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      _categoryList.length,
                          (index) =>
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  ((_info[index] / _total) * 100).toStringAsFixed(2) + '%',
                                  style: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: index < colors.length ? colors[index] : Style.pieChartExtendedCategoryColor,
                                  ),
                                ),
                              )
                    )
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return (_categoryList.length != 0)
        ? List.generate(_categoryList.length, (i) {
            final isTouched = i == touchedIndex;
            final fontSize = isTouched ? 16.0 : 14.0;
            final radius = isTouched ? 28.0 : 18.0;
            final widgetSize = isTouched ? 40.0 : 20.0;
            final double fontTitleSize = isTouched ? 17 : 8.5;

            var value = ((_info[i] / _total) * 100);

            return PieChartSectionData(
              color: i < colors.length ? colors[i] : Style.pieChartExtendedCategoryColor,
              value: value,
              showTitle: _isShowPercent,
              title: value.toStringAsFixed(2) + '%',
              titlePositionPercentageOffset: isTouched ? 2.3 : 2.20,
              radius: radius,
              titleStyle: TextStyle(
                  color: i < colors.length ? colors[i] : Style.pieChartExtendedCategoryColor,
                  fontSize: fontTitleSize,
                  fontWeight: FontWeight.w500,
                  fontFamily: Style.fontFamily),
              badgeWidget: _Badge(
                _categoryList[i].iconID, // category icon.
                size: widgetSize,
                borderColor: i < colors.length ? colors[i] : Style.pieChartExtendedCategoryColor,
              ),
              badgePositionPercentageOffset: .98,
            );
          })
        : List.generate(1, (i) {
            return PieChartSectionData(
              color: Style.boxBackgroundColor,
              value: 100,
              showTitle: false,
              radius: 15.0,
            );
          });
  }

  List<PieChartSectionData> showingSubSections() {
    return (_categoryList.length != 0)
        ? List.generate(_categoryList.length, (i) {
            //final isTouched = i == touchedIndex;
            //final fontSize = isTouched ? 16.0 : 14.0;
            final radius = 8.0;
            final widgetSize = 20.0;

            var value = ((_info[i] / _total) * 100);

            return PieChartSectionData(
              color: i < colors.length
                  ? colors[i].withOpacity(0.4)
                  : Style.pieChartExtendedCategoryColor.withOpacity(0.4),
              value: value.toDouble(),
              showTitle: false,
              radius: radius,
            );
          })
        : List.generate(1, (i) {
            return PieChartSectionData(
              color: Style.boxBackgroundColor,
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

  const _Badge(this.svgAsset, {
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
