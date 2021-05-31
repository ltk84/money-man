import 'dart:convert';

import 'package:flutter/cupertino.dart';

import './category_model.dart';
import './wallet_model.dart';

class Budget {
  MyCategory category;
  double amount;
  double spent;
  Wallet wallet;
  bool isFinished;
  DateTime beginDate;
  DateTime endDate;
  bool isRepeat;

  Budget({
    @required this.category,
    @required this.amount,
    @required this.spent,
    @required this.wallet,
    @required this.isFinished,
    @required this.beginDate,
    @required this.endDate,
    @required this.isRepeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category.toMap(),
      'amount': amount,
      'spent': spent,
      'wallet': wallet.toMap(),
      'isFinished': isFinished,
      'beginDate': beginDate,
      'endDate': endDate,
      'isRepeat': isRepeat,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> data) {
    return Budget(
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      spent: data['spent'],
      wallet: Wallet.fromMap(data['wallet']),
      isFinished: data['isFinished'],
      beginDate: DateTime.tryParse(data['beginDate']),
      endDate: DateTime.tryParse(data['endDate']),
      isRepeat: data['isRepeat'],
    );
  }
}
