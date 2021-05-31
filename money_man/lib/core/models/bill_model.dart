import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:money_man/core/models/repeat_option_model.dart';

import './category_model.dart';
import './transaction_model.dart';
import './wallet_model.dart';

class Bill {
  MyCategory category;
  double amount;
  Wallet wallet;
  List<MyTransaction> transactionIdList;
  RepeatOption repeatOption;

  Bill({
    @required this.category,
    @required this.amount,
    @required this.wallet,
    @required this.transactionIdList,
    @required this.repeatOption,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'amount': amount,
      'wallet': wallet.toMap(),
      'transactionIdList': transactionIdList?.map((x) => x.toMap())?.toList(),
      'repeatOption': repeatOption.toMap(),
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      category: MyCategory.fromMap(map['category']),
      amount: map['amount'],
      wallet: Wallet.fromMap(map['wallet']),
      transactionIdList: List<MyTransaction>.from(
          map['transactionIdList']?.map((x) => MyTransaction.fromMap(x))),
      repeatOption: RepeatOption.fromMap(map['repeatOption']),
    );
  }
}
