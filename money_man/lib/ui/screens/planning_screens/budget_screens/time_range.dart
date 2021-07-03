import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

// Này là class lưu trữ time range
class BudgetTimeRange {
  DateTime beginDay; // ngày bắt đầu
  DateTime endDay; // ngày kết thúc
  String description; // mô tả: tháng này ,....
  BudgetTimeRange(
      {@required this.beginDay, @required this.endDay, this.description});

// Này là để trả về chi tiết theo định dạnh dd/MM
  String getStringOfTimeRange() {
    String result = DateFormat('dd/MM').format(beginDay) +
        ' - ' +
        DateFormat('dd/MM').format(endDay);
    return result;
  }

// Lấy label theo tuần này, tháng này, năm này,... logic tương tự của budget tile
  String getBudgetLabel() {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    DateTime begin = this.beginDay;
    DateTime end = this.endDay;
    if (end.weekday == 7 &&
        begin.weekday == 1 &&
        begin.compareTo(today) <= 0 &&
        end.compareTo(today) >= 0) return 'This week';
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == today.month &&
        begin.month == end.month &&
        begin.compareTo(today) <= 0 &&
        end.compareTo(today) >= 0) return 'This month';
    var temp = DateTime(today.year, today.month + 1, today.day, 1);
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == temp.month &&
        begin.compareTo(temp) <= 0 &&
        end.compareTo(temp) >= 0) return 'Next month';

    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));

    if (begin.compareTo(firstDayOfQuarter) == 0 &&
        end.compareTo(endDayOfQuarter) == 0) return 'This quarter';

    double nextQuarterNumber = (today.month - 1) / 3 + 6;
    DateTime firstDayOfNQuarter =
        new DateTime(today.year, nextQuarterNumber.toInt(), 1);
    final endDayOfNQuarter =
        new DateTime(today.year, nextQuarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    print('1$firstDayOfNQuarter');
    print(begin);
    if (begin.compareTo(firstDayOfNQuarter) == 0 &&
        end.compareTo(endDayOfNQuarter) == 0) return 'Next quarter';

    if (begin.compareTo(DateTime(today.year, 1, 1)) == 0 &&
        end.compareTo(DateTime(today.year, 12, 31)) == 0) return 'This year';

    if (begin.compareTo(DateTime(today.year + 1, 1, 1)) == 0 &&
        end.compareTo(DateTime(today.year + 1, 12, 31)) == 0)
      return 'Next year';
    return 'Custom';
  }
}
