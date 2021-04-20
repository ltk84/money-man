import 'package:flutter/material.dart';

class MyTransaction {
  String id;
  double amount;
  DateTime date;
  String note;
  String currencyID;
  String catergoryID;
  String budgetID;
  String eventID;
  String billID;
  MyTransaction({
    @required this.id,
    @required this.amount,
    @required this.date,
    this.note,
    @required this.currencyID,
    @required this.catergoryID,
    this.budgetID,
    this.eventID,
    this.billID,
  });

  factory MyTransaction.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return MyTransaction(
        id: data['id'],
        amount: data['amount'],
        date: data['date'],
        currencyID: data['currencyID'],
        catergoryID: data['catergoryID'],
        note: data['note'] ?? "",
        budgetID: data['budgetID'] ?? null,
        eventID: data['eventID'] ?? null,
        billID: data['billID'] ?? null);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'date': date,
      'currencyID': currencyID,
      'catergoryID': catergoryID,
      'note': note ?? "",
      'budgetID': budgetID ?? null,
      'eventID': eventID ?? null,
      'billID': billID ?? null,
    };
  }
}
