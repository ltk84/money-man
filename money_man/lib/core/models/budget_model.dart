import 'package:flutter/cupertino.dart';

import './category_model.dart';

class Budget {
  // id của budget
  String id;
  // category của budget
  MyCategory category;
  // số tiền của budget
  double amount;
  // sô tiền đã được chi của budget
  double spent;
  // id wallet của budget
  String walletId;
  // biến xác định budget đã xong hay chưa?
  bool isFinished;
  // thời điểm bắt đầu
  DateTime beginDate;
  // thời điểm kêt thúc
  DateTime endDate;
  // xác định budget có lặp lại hay không?
  bool isRepeat;
  // tên của budgets
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
