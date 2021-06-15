import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:money_man/core/models/repeat_option_model.dart';

import './category_model.dart';
import './transaction_model.dart';
import './wallet_model.dart';

class Bill {
  String id;
  MyCategory category;
  double amount;
  String note;
  String walletId;
  List<String> transactionIdList;
  RepeatOption repeatOption;
  bool isFinished;
  List<DateTime> dueDates;
  List<DateTime> paidDueDates;

  Bill({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.note,
    @required this.walletId,
    @required this.transactionIdList,
    @required this.repeatOption,
    @required this.isFinished,
    @required this.dueDates,
    @required this.paidDueDates,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.toMap(),
      'amount': amount,
      'note': note,
      'walletId': walletId,
      'transactionIdList': transactionIdList,
      'repeatOption': repeatOption.toMap(),
      'isFinished': isFinished,
      'dueDates': dueDates,
      'paidDueDates': paidDueDates,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> data) {
    return Bill(
      id: data['id'],
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      note: data['note'],
      walletId: data['walletId'],
      transactionIdList: List<String>.from(
          data['transactionIdList']?.map((x) => x)),
      repeatOption: RepeatOption.fromMap(data['repeatOption']),
      isFinished: data['isFinished'],
      dueDates: List<DateTime>.from(data['dueDates']?.map((x) =>
          DateTime.tryParse(x.toDate().toString()))),
      paidDueDates: List<DateTime>.from(data['paidDueDates']?.map((x) =>
          DateTime.tryParse(x.toDate().toString()))),
    );
  }

  void updateDueDate () {
    if (!isFinished) {
      var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      if (now.compareTo(repeatOption.beginDateTime) >= 0) {
        if (repeatOption.type == 'until' && now.isAfter(repeatOption.extraTypeInfo)) {
          //isFinished = true;
          return;
        } else if (repeatOption.type == 'for' && repeatOption.extraTypeInfo - 1 == 0) {
          //isFinished = true;
          return;
        }
        var timeRange = now.difference(repeatOption.beginDateTime).inDays;
        int freq;

        switch (repeatOption.frequency)
        {
          case 'daily':
            freq = repeatOption.rangeAmount;
            break;
          case 'weekly':
            freq = 7 * repeatOption.rangeAmount;
            break;
          case 'monthly':
            int dayOfMonth = DateTime(now.year, now.month + 1, 0).day;
            freq = dayOfMonth * repeatOption.rangeAmount;
            break;
          case 'yearly':
            bool isLeap = DateTime(now.year, 3, 0).day == 29;
            int dayOfYear = isLeap ? 366 : 365;
            freq = dayOfYear  * repeatOption.rangeAmount;
            break;
        }

        if (timeRange % freq == 0) {
          DateTime nextDue;
          nextDue = now.add(Duration(days: freq));
          if (!paidDueDates.contains(nextDue)) {
            if (!dueDates.contains(nextDue)) {
              dueDates.add(nextDue);
              if (repeatOption.type == 'for')
                repeatOption.extraTypeInfo--;
            }
          }
        }
      }
    }
  }


}
