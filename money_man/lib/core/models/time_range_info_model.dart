import 'package:flutter/cupertino.dart';

class TimeRangeInfo {
  // mô tả của time range
  String description;
  // thời điểm bắt đầu
  DateTime begin;
  // thời điểm kết thúc
  DateTime end;

  TimeRangeInfo(
      {@required this.description, @required this.begin, @required this.end});
}
