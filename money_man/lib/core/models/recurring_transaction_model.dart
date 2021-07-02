import 'package:flutter/cupertino.dart';
import 'package:money_man/core/models/repeat_option_model.dart';
import './category_model.dart';

class RecurringTransaction {
  // id của recurring transaction
  String id;
  // category của recurring transaction
  MyCategory category;
  // số tiền của recurring transaction
  double amount;
  // id wallet của recurring transaction
  String walletId;
  // note của recurring transaction
  String note;
  // danh sách các transaction
  List<String> transactionIdList;
  // tùy chọn lặp lại
  RepeatOption repeatOption;
  // biến kiểm soát recurring transaction đã hoàn thành hay chưa?
  bool isFinished;

  RecurringTransaction({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.walletId,
    @required this.note,
    @required this.transactionIdList,
    @required this.repeatOption,
    @required this.isFinished,
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
      'isFinished': isFinished,
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
      isFinished: data['isFinished'],
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
    this.isFinished = source.isFinished;
  }
}
