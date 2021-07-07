import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/ui/style.dart';

class PieChartScreen extends StatefulWidget {
  final List<MyTransaction> currentList;
  final List<MyCategory> categoryList;
  final bool isShowPercent;
  final double total;
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
  // Lấy danh sách các màu cho các thể loại để hiển thị lên pie chart.
  List<Color> colors = Style.pieChartCategoryColors;

  // Tổng số tiền.
  double total;

  // Biến để lấy vị trí đã chạm vào pie chart.
  int touchedIndex = -1;

  // Biến để hiển thị phần trăm pie chart.
  bool isShowPercent;

  // Danh sách transactions.
  List<MyTransaction> transactionList;

  // Danh sách các danh mục của các transaction.
  List<MyCategory> categoryList;

  // Danh sách tổng số tiền của từng danh mục.
  List<double> info = [];

  @override
  void initState() {
    super.initState();

    // Lấy các giá trị từ tham số đầu vào.
    transactionList = widget.currentList;
    categoryList = widget.categoryList;
    total = widget.total;
    isShowPercent = widget.isShowPercent;

    // Hàm lấy thông tin tổng số tiền của từng danh mục.
    generateData(categoryList, transactionList);
  }

  @override
  void didUpdateWidget(covariant PieChartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Lấy các giá trị từ tham số đầu vào.
    transactionList = widget.currentList ?? [];
    categoryList = widget.categoryList ?? [];
    total = widget.total;
    isShowPercent = widget.isShowPercent;

    // Hàm lấy thông tin tổng số tiền của từng danh mục.
    generateData(categoryList, transactionList);
  }

  // Hàm lấy thông tin tổng số tiền của từng danh mục.
  void generateData(
      List<MyCategory> categoryList, List<MyTransaction> transactionList) {
    // Đảm bảo danh sách thông tin được làm trống.
    info.clear();

    // Thực thi tính toán các thông tin trên tất cả danh mục hiện có.
    categoryList.forEach((element) {
      info.add(calculateByCategory(element, transactionList));
    });
  }

  // Hàm tính toán tổng số tiền của từng danh mục trong danh sách transactions.
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
          scale: isShowPercent ? 1.6 : 1,
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
                              // Xử lý chạm trong pie chart.
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
          padding: EdgeInsets.symmetric(horizontal: isShowPercent ? 50 : 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    categoryList.length,
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
                                  // Vì số lượng danh mục có thể lớn hơn danh sách màu của danh mục. Nên nếu số thứ tự bị vượt quá, màu của danh mục đó sẽ theo màu mặc định được cài đặt trong Style.dart
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                categoryList[index].name,
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: index < colors.length ? colors[index] : Style.pieChartExtendedCategoryColor,
                                  // Vì số lượng danh mục có thể lớn hơn danh sách màu của danh mục.
                                  // Nên nếu số thứ tự bị vượt quá, màu của danh mục đó sẽ theo màu mặc định được cài đặt trong Style.dart.
                                ),
                              )
                            ],
                          ),
                        ),
                  )
              ),
              if (isShowPercent)
                Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      categoryList.length,
                          (index) =>
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 2),
                                child: Text(
                                  ((info[index] / total) * 100).toStringAsFixed(2) + '%',
                                  style: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: index < colors.length ? colors[index] : Style.pieChartExtendedCategoryColor,
                                    // Vì số lượng danh mục có thể lớn hơn danh sách màu của danh mục.
                                    // Nên nếu số thứ tự bị vượt quá, màu của danh mục đó sẽ theo màu mặc định được cài đặt trong Style.dart.
                                  ),
                                ),
                              ),
                            )),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return (categoryList.length != 0)
        ? List.generate(categoryList.length, (i) {
            final isTouched = i == touchedIndex;
            final radius = isTouched ? 28.0 : 18.0;
            final widgetSize = isTouched ? 40.0 : 20.0;
            final double fontTitleSize = isTouched ? 17 : 8.5;

            if (total == 0)
              total = 1;
            var value = ((info[i] / total) * 100);

            return PieChartSectionData(
              // Vì số lượng danh mục có thể lớn hơn danh sách màu của danh mục.
              // Nên nếu số thứ tự bị vượt quá, màu của danh mục đó sẽ theo màu mặc định được cài đặt trong Style.dart.
              color: i < colors.length ? colors[i] : Style.pieChartExtendedCategoryColor,
              value: value == 0 ? 1 : value,
              showTitle: isShowPercent,
              title: value.toStringAsFixed(2) + '%',
              titlePositionPercentageOffset: isTouched ? 2.3 : 2.20,
              radius: radius,
              titleStyle: TextStyle(
                  color: i < colors.length ? colors[i] : Style.pieChartExtendedCategoryColor,
                  // Vì số lượng danh mục có thể lớn hơn danh sách màu của danh mục.
                  // Nên nếu số thứ tự bị vượt quá, màu của danh mục đó sẽ theo màu mặc định được cài đặt trong Style.dart.
                  fontSize: fontTitleSize,
                  fontWeight: FontWeight.w500,
                  fontFamily: Style.fontFamily),
              badgeWidget: Badge(
                categoryList[i].iconID, // category icon.
                size: widgetSize,
                borderColor: i < colors.length ? colors[i] : Style.pieChartExtendedCategoryColor,
                // Vì số lượng danh mục có thể lớn hơn danh sách màu của danh mục.
                // Nên nếu số thứ tự bị vượt quá, màu của danh mục đó sẽ theo màu mặc định được cài đặt trong Style.dart.
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
    return (categoryList.length != 0)
        ? List.generate(categoryList.length, (i) {
            final radius = 8.0;

            if (total == 0)
              total = 1;
            var value = ((info[i] / total) * 100);

            return PieChartSectionData(
              color: i < colors.length
                  ? colors[i].withOpacity(0.4)
                  : Style.pieChartExtendedCategoryColor.withOpacity(0.4),
              value: value == 0 ? 1 : value,
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

class Badge extends StatelessWidget {
  final String svgAsset;
  final double size;
  final Color borderColor;

  const Badge(this.svgAsset, {
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
