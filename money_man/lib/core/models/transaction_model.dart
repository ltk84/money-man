import 'package:flutter/material.dart';
import './category_model.dart';

class MyTransaction {
  String id;
  double amount;
  double extraAmountInfo;
  DateTime date;
  String note;
  String currencyID;
  MyCategory category;
  String budgetID;
  String eventID;
  String billID;
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
