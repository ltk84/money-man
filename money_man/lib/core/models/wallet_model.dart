import 'package:flutter/material.dart';

class Wallet {
  // id của wallet
  String id;
  // tên của wallet
  String name;
  // số tiền của wallet
  double amount;
  // id tiền tệ của wallet
  String currencyID;
  // id icon của wallet
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
      amount: data['amount'].toDouble(),
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
