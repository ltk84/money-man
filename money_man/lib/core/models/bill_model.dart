import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:money_man/core/models/repeat_option_model.dart';

import './category_model.dart';
import './transaction_model.dart';
import './wallet_model.dart';

class Bill {
  String id;
  MyCategory category;
  double amount;
  String note;
  String walletId;
  List<MyTransaction> transactionIdList;
  RepeatOption repeatOption;
  bool isFinished;

  Bill({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.note,
    @required this.walletId,
    @required this.transactionIdList,
    @required this.repeatOption,
    @required this.isFinished,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.toMap(),
      'amount': amount,
      'note': note,
      'wallet': walletId,
      'transactionIdList': transactionIdList?.map((x) => x.toMap())?.toList(),
      'repeatOption': repeatOption.toMap(),
      'isFinised': isFinished
    };
  }

  factory Bill.fromMap(Map<String, dynamic> data) {
    return Bill(
      id: data['id'],
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      note: data['note'],
      walletId: data['walletId'],
      transactionIdList: List<MyTransaction>.from(
          data['transactionIdList']?.map((x) => MyTransaction.fromMap(x))),
      repeatOption: RepeatOption.fromMap(data['repeatOption']),
      isFinished: data['isFinished'],
    );
  }
}
