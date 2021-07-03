import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/time_range_info_model.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/time_range.dart';
import 'package:money_man/ui/screens/report_screens/custom_time_range.dart';
import 'package:money_man/ui/style.dart';

class SelectTimeRangeScreen extends StatefulWidget {
  @override
  _SelectTimeRangeScreenState createState() => _SelectTimeRangeScreenState();
}

class _SelectTimeRangeScreenState extends State<SelectTimeRangeScreen> {
  BudgetTimeRange budgetTimeRange;
  var beginDate;
  var endDate;
  var dateDescript;

  // Lấy mô tả cho tuần
  String getSubTitleOfTheWeek(DateTime today) {
    // Tuần có ngày bắt đầu là hôm nay trừ cho weekday và ngày kết thúc + thêm 6
    var firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    var endDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    String result = DateFormat('dd/MM').format(firstDayOfWeek) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfWeek);
    return result;
  }

// Lấy timerange cho tuần
  BudgetTimeRange getMyTimeRangeWeek(DateTime today) {
    // Tuần có ngày bắt đầu là hôm nay trừ cho weekday và ngày kết thúc + thêm 6

    var firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    firstDayOfWeek =
        DateTime(firstDayOfWeek.year, firstDayOfWeek.month, firstDayOfWeek.day);
    var endDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    return new BudgetTimeRange(
        beginDay: firstDayOfWeek,
        endDay: endDayOfWeek,
        description: 'This week');
  }

// Lấy title cho tháng
  String getSubTitleOfTheMonth(DateTime today) {
    //Tháng bắt đầu từ ngày hôm nay trừ cho n-1 ngày và kết thúc bằng ngày đầu tiên của tháng sau -1
    var firstDayOfMonth = today.subtract(Duration(days: today.day - 1));
    firstDayOfMonth = DateTime(
        firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day);
    var endDayOfMonth =
        DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));
    String result = DateFormat('dd/MM').format(firstDayOfMonth) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfMonth);
    return result;
  }

// Lấy time range cho tháng
  BudgetTimeRange getMyTimeRangeMonth(DateTime today) {
    //Tháng bắt đầu từ ngày hôm nay trừ cho n-1 ngày và kết thúc bằng ngày đầu tiên của tháng sau -1
    var firstDayOfMonth = today.subtract(Duration(days: today.day - 1));
    firstDayOfMonth = DateTime(
        firstDayOfMonth.year, firstDayOfMonth.month, firstDayOfMonth.day);
    var endDayOfMonth =
        DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfMonth,
        endDay: endDayOfMonth,
        description:
            DateTime.now().isBefore(today) ? 'Next month' : 'This month');
  }

// Lấy mô tả cho quý
  String getSubTitleOfTheQuarter(DateTime today) {
    // Quý thì sử dụng công thức trừ tháng như dưới, ngày kết thúc tương tự ở trên
    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    String result = DateFormat('dd/MM').format(firstDayOfQuarter) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfQuarter);
    return result;
  }

// Lấy time range cho quý
  BudgetTimeRange getMyTimeRangeOfTheQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfQuarter,
        endDay: endDayOfQuarter,
        description: 'This quarter');
  }

// Tương tự nhưng cho quý tiếp theo (cộng today thêm 3 tháng :v)
  String getSubTitleForNextQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 5;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    String result = DateFormat('dd/MM').format(firstDayOfQuarter) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfQuarter);
    return result;
  }

// Lấy timerange cho quý sau, tương tự
  BudgetTimeRange getMyTimeRangeForNextQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 5;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfQuarter,
        endDay: endDayOfQuarter,
        description: 'Next quarter');
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    return Theme(
      data: ThemeData(fontFamily: 'Montserrat'),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Back',
                  style: TextStyle(
                      fontFamily: Style.fontFamily,
                      color: Style.foregroundColor),
                )),
            // Thoát
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.appBarColor,
          title: Text(
            'Select time range',
            style: TextStyle(
                fontFamily: 'Montserrat', color: Style.foregroundColor),
          ),
        ),
        body: Container(
          color: Style.backgroundColor,
          // Chọn vào nào thì trả về khoảng thời gian của đó
          child: ListView(
            children: [
              // Biểu thị cho khoảng thời gian của tuần này
              Container(
                child: buildTimeRangeListTile(
                    title: 'This week',
                    subTitle: getSubTitleOfTheWeek(today),
                    mTimeRange: getMyTimeRangeWeek(today)),
              ),
              // Biểu thị cho khoảng thời gian của tháng này
              Container(
                child: buildTimeRangeListTile(
                    title: 'This month',
                    subTitle: getSubTitleOfTheMonth(today),
                    mTimeRange: getMyTimeRangeMonth(today)),
              ),
              // Biểu thị cho khoảng thời gian của quý này
              Container(
                child: buildTimeRangeListTile(
                    title: 'This quarter',
                    subTitle: getSubTitleOfTheQuarter(today),
                    mTimeRange: getMyTimeRangeOfTheQuarter(today)),
              ),
              // Biểu thị cho khoảng thời gian của năm nay
              Container(
                child: buildTimeRangeListTile(
                    title: 'This year',
                    subTitle: '01/01 - 31/12',
                    mTimeRange: new BudgetTimeRange(
                        beginDay: new DateTime(today.year, 1, 1),
                        endDay: new DateTime(today.year, 12, 31),
                        description: "This year")),
              ),
              // Biểu thị cho khoảng thời gian của tháng tới
              Container(
                child: buildTimeRangeListTile(
                    title: 'Next month',
                    subTitle: getSubTitleOfTheMonth(
                        new DateTime(today.year, today.month + 1, today.day)),
                    mTimeRange: getMyTimeRangeMonth(
                        new DateTime(today.year, today.month + 1, today.day))),
              ),
              // Biểu thị cho quý tới
              Container(
                child: buildTimeRangeListTile(
                    title: 'Next quarter',
                    subTitle: getSubTitleForNextQuarter(
                        new DateTime(today.year, today.month + 3, today.day)),
                    mTimeRange: getMyTimeRangeForNextQuarter(
                        new DateTime(today.year, today.month + 3, today.day))),
              ),
              // Biểu thị cho năm tới
              Container(
                child: buildTimeRangeListTile(
                    title: 'Next year',
                    subTitle:
                        '01/01/${today.year + 1} - 31/12/${today.year + 1}',
                    mTimeRange: new BudgetTimeRange(
                        beginDay: new DateTime(today.year + 1, 1, 1),
                        endDay: new DateTime(today.year + 1, 12, 31),
                        description: "Next year")),
              ),
              // Biểu thị cho tùy chọn, nhấn vào để chuyển đến màn hình chọn khoảng thời gian
              Container(
                child: buildTimeRangeListTile(
                    title: 'Custom time range',
                    subTitle: 'dd/MM/YYYY - dd/MM/YYYY',
                    mCustom: true),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Này là hàm thực thi việc tạo các listile

  Widget buildTimeRangeListTile(
      {String title =
          "title", // title là chuối văn bản chữ để mô tả tháng này tuần này,...
      String subTitle = "sub tittle", // này là hiển thị ngày một cách chính xác
      bool mCustom =
          false, // Biến để nhận diện xem đây có phải là chọn khoảng thời gian tùy chỉnh không,  mặc định là không
      BudgetTimeRange mTimeRange}) {
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: mCustom
                // Nếu là custom thì chuyển hướng đến trang chọn custom, rồi trả về cho trang trước
                ? () async {
                    TimeRangeInfo result = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.backgroundColor,
                        context: context,
                        builder: (context) => CustomTimeRange(
                            beginDate: beginDate, endDate: endDate));
                    if (result != null) {
                      setState(() {
                        mTimeRange = new BudgetTimeRange(
                            beginDay: result.begin, endDay: result.end);
                      });
                      Navigator.of(context).pop(mTimeRange);
                    }
                  }
                // Còn kkhoong phải là custome thì trả về trực tiếp
                : () {
                    Navigator.of(context).pop(mTimeRange);
                  },
            title: Text(
              title,
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: 'Montserrat',
                  fontSize: 17),
            ),
            subtitle: Text(
              subTitle,
              style: TextStyle(color: Style.foregroundColor, fontSize: 14),
            ),
          ),
          Divider(
            color: Style.boxBackgroundColor2,
          )
        ],
      ),
    );
  }
}
