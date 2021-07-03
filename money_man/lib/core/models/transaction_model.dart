import 'package:flutter/material.dart';
import './category_model.dart';

class MyTransaction {
  // id của transaction
  String id;
  // số tiền của transaction
  double amount;
  // số tiền extra nếu category của transaction là debt/loan
  double extraAmountInfo;
  // ngày thực hiện transaction
  DateTime date;
  // note của transaction
  String note;
  // id của đơn vị tiền tệ của transaction
  String currencyID;
  // thể loại của transaction
  MyCategory category;
  String budgetID;
  // id event của transaction
  String eventID;
  String billID;
  // contact của transaction
  String contact;

  MyTransaction({
    @required this.id,
    @required this.amount,
    @required this.date,
    this.note,
    @required this.currencyID,
    @required this.category,
    this.budgetID,
    this.eventID,
    this.billID,
    this.contact,
    this.extraAmountInfo,
  });

  factory MyTransaction.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    return MyTransaction(
        id: data['id'],
        amount: data['amount'],
        date: DateTime.tryParse(data['date'].toDate().toString()),
        currencyID: data['currencyID'],
        category: MyCategory.fromMap(data['category']),
        note: data['note'],
        budgetID: data['budgetID'],
        eventID: data['eventID'] ?? '',
        billID: data['billID'],
        contact: data['contact'],
        extraAmountInfo: data['extraAmountInfo']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'currencyID': currencyID,
      'category': category.toMap(),
      'note': note ?? "",
      'budgetID': budgetID,
      'eventID': eventID ?? '',
      'billID': billID,
      'contact': contact,
      'extraAmountInfo': extraAmountInfo,
    };
  }
}
