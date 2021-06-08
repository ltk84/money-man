import 'dart:convert';

import 'package:flutter/cupertino.dart';

import './wallet_model.dart';

class Event {
  String id;
  String name;
  String iconPath;
  DateTime endDate;
  String walletId;
  bool isFinished;
  List<String> transactionIdList ;
  double spent;

  Event({
    @required this.id,
    @required this.name,
    @required this.iconPath,
    @required this.endDate,
    @required this.walletId,
    @required this.isFinished,
    @required this.transactionIdList,
    @required this.spent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconPath': iconPath,
      'endDate': endDate,
      'wallet': walletId,
      'isFinished': isFinished,
      'transactionIdList': transactionIdList,
      'spent': spent,
    };
  }

  factory Event.fromMap(Map<String, dynamic> data) {
    if (data == null) return null;

    return Event(
      id: data['id'],
      name: data['name'],
      iconPath: data['iconPath'],
      endDate: DateTime.tryParse(data['endDate'].toDate().toString()),
      walletId: data['wallet'],
      isFinished: data['isFinished'],
      transactionIdList: List<String>.from(data['transactionIdList']),
      spent: data['spent'],
    );
  }
}
