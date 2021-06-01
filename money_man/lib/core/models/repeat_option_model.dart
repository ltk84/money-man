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
    this.frequency = 'daily',
    this.rangeAmount = 1,
    this.extraAmountInfo,
    this.beginDateTime,
    this.type = 'forever',
    this.extraTypeInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'frequency': frequency,
      'rangeAmount': rangeAmount,
      'extraAmountInfo': extraAmountInfo,
      'beginDateTime': beginDateTime.millisecondsSinceEpoch,
      'type': type,
      'extraTypeInfo': extraTypeInfo,
    };
  }

  factory RepeatOption.fromMap(Map<String, dynamic> map) {
    return RepeatOption(
      frequency: map['frequency'],
      rangeAmount: map['rangeAmount'],
      extraAmountInfo: map['extraAmountInfo'],
      beginDateTime: DateTime.tryParse(map['beginDateTime']),
      type: map['type'],
      extraTypeInfo: map['extraTypeInfo'],
    );
  }
}
