import 'dart:convert';

import 'package:flutter/cupertino.dart';

import './wallet_model.dart';

class Event {
  String name;
  String iconPath;
  DateTime endDate;
  Wallet wallet;
  bool isFinished;
  List<String> transactionIdList;
  double spent;

  Event({
    @required this.name,
    @required this.iconPath,
    @required this.endDate,
    @required this.wallet,
    @required this.isFinished,
    @required this.transactionIdList,
    @required this.spent,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconPath': iconPath,
      'endDate': endDate,
      'wallet': wallet.toMap(),
      'isFinished': isFinished,
      'transactionIdList': transactionIdList,
      'spent': spent,
    };
  }

  factory Event.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    return Event(
      name: data['name'],
      iconPath: data['iconPath'],
      endDate: DateTime.tryParse(data['endDate']),
      wallet: Wallet.fromMap(data['wallet']),
      isFinished: data['isFinished'],
      transactionIdList: List<String>.from(data['transactionIdList']),
      spent: data['spent'],
    );
  }
}
