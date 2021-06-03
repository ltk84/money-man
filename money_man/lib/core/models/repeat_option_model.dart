import 'dart:convert';

import 'package:flutter/cupertino.dart';

class RepeatOption {
  static List<String> frequencyList = ['daily', 'weekly', 'monthly', 'yearly'];
  static List<String> typeList = ['forever', 'for', 'until'];

  String frequency;
  int rangeAmount;
  dynamic extraAmountInfo;
  DateTime beginDateTime;
  String type;
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
    print('alo');
    print(map['extraAmountInfo']);
    return RepeatOption(
      frequency: map['frequency'],
      rangeAmount: map['rangeAmount'],
      extraAmountInfo: map['extraAmountInfo'],
      beginDateTime:
          DateTime.tryParse(map['beginDateTime'].toDate().toString()) ?? '',
      type: map['type'],
      extraTypeInfo: int.tryParse(map['extraTypeInfo'].toString()) ??
          DateTime.tryParse(map['extraTypeInfo'].toString()) ??
          '',
    );
  }
}
