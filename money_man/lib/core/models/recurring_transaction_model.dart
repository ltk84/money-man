import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:money_man/core/models/repeat_option_model.dart';

import './category_model.dart';
import './transaction_model.dart';
import './wallet_model.dart';

class RecurringTransaction {
  String id;
  MyCategory category;
  double amount;
  Wallet wallet;
  List<MyTransaction> transactionIdList;
  RepeatOption repeatOption;

  RecurringTransaction({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.wallet,
    @required this.transactionIdList,
    @required this.repeatOption,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.toMap(),
      'amount': amount,
      'wallet': wallet.toMap(),
      'transactionIdList': transactionIdList?.map((x) => x.toMap())?.toList(),
      'repeatOption': repeatOption.toMap(),
    };
  }

  factory RecurringTransaction.fromMap(Map<String, dynamic> data) {
    return RecurringTransaction(
      id: data['id'],
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      wallet: Wallet.fromMap(data['wallet']),
      transactionIdList: List<MyTransaction>.from(
          data['transactionIdList']?.map((x) => MyTransaction.fromMap(x))),
      repeatOption: RepeatOption.fromMap(data['repeatOption']),
    );
  }
}
