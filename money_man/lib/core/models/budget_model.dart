import 'package:flutter/cupertino.dart';

import './category_model.dart';

class Budget {
  String id;
  MyCategory category;
  double amount;
  double spent;
  String walletId;
  bool isFinished;
  DateTime beginDate;
  DateTime endDate;
  bool isRepeat;
  String label;

  Budget({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.spent,
    @required this.walletId,
    @required this.isFinished,
    @required this.beginDate,
    @required this.endDate,
    @required this.isRepeat,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.toMap(),
      'amount': amount,
      'spent': spent,
      'walletId': walletId,
      'isFinished': isFinished,
      'beginDate': beginDate,
      'endDate': endDate,
      'isRepeat': isRepeat,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> data) {
    return Budget(
      id: data['id'],
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      spent: data['spent'],
      walletId: data['walletId'],
      isFinished: data['isFinished'],
      beginDate: DateTime.tryParse(data['beginDate'].toDate().toString()),
      endDate: DateTime.tryParse(data['endDate'].toDate().toString()),
      isRepeat: data['isRepeat'],
    );
  }
}
