import 'package:flutter/cupertino.dart';

class RepeatOption {
  // sự lặp lại
  String frequency;
  // khoảng thời gian lặp lại
  int rangeAmount;
  // thông tin thêm tùy vào frequency
  dynamic extraAmountInfo;
  // thời điểm bắt đầu
  DateTime beginDateTime;
  // thể loại
  String type;
  // thông tin thêm của thể loại tùy vào thể loại
  dynamic extraTypeInfo;

  RepeatOption({
    @required this.frequency,
    @required this.rangeAmount,
    @required this.extraAmountInfo,
    @required this.beginDateTime,
    @required this.type,
    @required this.extraTypeInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency,
      'rangeAmount': rangeAmount,
      'extraAmountInfo': extraAmountInfo ?? '',
      'beginDateTime': beginDateTime,
      'type': type,
      'extraTypeInfo': extraTypeInfo ?? '',
    };
  }

  factory RepeatOption.fromMap(Map<String, dynamic> map) {
    return RepeatOption(
      frequency: map['frequency'],
      rangeAmount: map['rangeAmount'],
      extraAmountInfo: map['extraAmountInfo'],
      beginDateTime:
          DateTime.tryParse(map['beginDateTime'].toDate().toString()) ?? '',
      type: map['type'],
      extraTypeInfo: map['extraTypeInfo'] == ''
          ? map['extraTypeInfo']
          : int.tryParse(map['extraTypeInfo'].toString()) != null
              ? int.tryParse(map['extraTypeInfo'].toString())
              : DateTime.tryParse(map['extraTypeInfo'].toDate().toString()),
    );
  }
}
