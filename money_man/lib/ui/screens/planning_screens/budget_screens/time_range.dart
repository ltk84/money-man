import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BudgetTimeRange {
  DateTime beginDay;
  DateTime endDay;
  String description;
  BudgetTimeRange(
      {@required this.beginDay, @required this.endDay, this.description});

  String TimeRangeString() {
    String result = DateFormat('dd/MM').format(beginDay) +
        ' - ' +
        DateFormat('dd/MM').format(endDay);
    return result;
  }

  String getBudgetLabel() {
    DateTime today = DateTime.now();
    DateTime begin = this.beginDay;
    DateTime end = this.endDay;
    if (end.weekday == 7 &&
        begin.weekday == 1 &&
        begin.isBefore(today.add(Duration(days: 1))) &&
        end.isAfter(today.subtract(Duration(days: 1)))) return 'This week';
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == today.month &&
        begin.month == end.month &&
        begin.isBefore(today) &&
        end.isAfter(today)) return 'This month';
    var temp = DateTime(today.year, today.month + 1, today.day);
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == temp.month &&
        begin.isBefore(temp) &&
        end.isAfter(temp)) return 'Next month';

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
