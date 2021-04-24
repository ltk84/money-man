import 'package:flutter/material.dart';

class Wallet {
  String id;
  String name;
  int amount;
  String currencyID;
  String iconID;
  Wallet({
    @required this.id,
    @required this.name,
    @required this.amount,
    @required this.currencyID,
    @required this.iconID,
  });

  factory Wallet.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;
    return Wallet(
      id: data['id'],
      name: data['name'],
      amount: data['amount'],
      currencyID: data['currencyID'],
      iconID: data['iconID'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'currencyID': currencyID,
      'iconID': iconID,
    };
  }
}
