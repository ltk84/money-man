import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:money_man/core/models/repeat_option_model.dart';

import './category_model.dart';
import './transaction_model.dart';

class RecurringTransaction {
  String id;
  MyCategory category;
  double amount;
  String walletId;
  String note;
  List<String> transactionIdList;
  RepeatOption repeatOption;

  RecurringTransaction({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.walletId,
    @required this.note,
    @required this.transactionIdList,
    @required this.repeatOption,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.toMap(),
      'amount': amount,
      'walletId': walletId,
      'note': note,
      'transactionIdList': transactionIdList,
      'repeatOption': repeatOption.toMap(),
    };
  }

  factory RecurringTransaction.fromMap(Map<String, dynamic> data) {
    return RecurringTransaction(
      id: data['id'],
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      walletId: data['walletId'],
      note: data['note'],
      transactionIdList: List<String>.from(data['transactionIdList']),
      repeatOption: RepeatOption.fromMap(data['repeatOption']),
    );
  }

  RecurringTransaction.clone(RecurringTransaction source) {
    this.id = source.id;
    this.category = source.category;
    this.amount = source.amount;
    this.walletId = source.walletId;
    this.note = source.note;
    this.transactionIdList = source.transactionIdList;
    this.repeatOption = source.repeatOption;
  }
}
