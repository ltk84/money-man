import 'package:flutter/material.dart';
import 'package:money_man/core/models/categoryModel.dart';

class MyTransaction {
  String id;
  double amount;
  DateTime date;
  String note;
  String currencyID;
  MyCategory category;
  String budgetID;
  String eventID;
  String billID;
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
            budgetID: data['budgetID'] ?? "",
            eventID: data['eventID'] ?? "",
            billID: data['billID']) ??
        "";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'currencyID': currencyID,
      'category': category.toMap(),
      'note': note ?? "",
      'budgetID': budgetID ?? null,
      'eventID': eventID ?? null,
      'billID': billID ?? null,
    };
  }
}
