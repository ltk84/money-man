import 'package:flutter/cupertino.dart';

class Event {
  // id của event
  String id;
  // tên của event
  String name;
  // đường dấn icon của event (icon id)
  String iconPath;
  // ngày kết thúc event
  DateTime endDate;
  // id wallet của event
  String walletId;
  // biến control event đã hết hạn hay chưa?
  bool isFinished;
  // danh sách các transaction
  List<String> transactionIdList;
  // số tiền đã spent của các transaction
  double spent;
  //
  bool finishedByHand;
  //
  bool autofinish;

  Event({
    @required this.id,
    @required this.name,
    @required this.iconPath,
    @required this.endDate,
    @required this.walletId,
    @required this.isFinished,
    @required this.transactionIdList,
    @required this.spent,
    @required this.finishedByHand,
    @required this.autofinish,
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
      'finishedByHand': finishedByHand,
      'autofinish': autofinish
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
      finishedByHand: data['finishedByHand'],
      autofinish: data['autofinish'],
    );
  }
}
