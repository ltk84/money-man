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
}
