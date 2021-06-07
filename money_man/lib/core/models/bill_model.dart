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
  List<MyTransaction> transactionIdList;
  RepeatOption repeatOption;
  bool isFinished;
  List<DateTime> dueDates;

  Bill({
    @required this.id,
    @required this.category,
    @required this.amount,
    @required this.note,
    @required this.walletId,
    @required this.transactionIdList,
    @required this.repeatOption,
    @required this.isFinished,
    this.dueDates,
  }) {
    this.dueDates = [];
    initDueDate ();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.toMap(),
      'amount': amount,
      'note': note,
      'walletId': walletId,
      'transactionIdList': transactionIdList?.map((x) => x.toMap())?.toList(),
      'repeatOption': repeatOption.toMap(),
      'isFinished': isFinished,
      'dueDates': dueDates
    };
  }

  factory Bill.fromMap(Map<String, dynamic> data) {
    return Bill(
      id: data['id'],
      category: MyCategory.fromMap(data['category']),
      amount: data['amount'],
      note: data['note'],
      walletId: data['walletId'],
      transactionIdList: List<MyTransaction>.from(
          data['transactionIdList']?.map((x) => MyTransaction.fromMap(x))),
      repeatOption: RepeatOption.fromMap(data['repeatOption']),
      isFinished: data['isFinished'],
      dueDates: List<DateTime>.from(data['dueDates']?.map((x) =>
          DateTime.tryParse(x.toDate().toString()))),
    );
  }

  void initDueDate () {
    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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

    var timeRange = now.difference(repeatOption.beginDateTime).inDays;
    if (repeatOption.beginDateTime.compareTo(now) >= 0) {
      if (!dueDates.contains(repeatOption.beginDateTime))
        dueDates.add(repeatOption.beginDateTime);
    } else {
      if (timeRange % freq == 0) {
        if (!dueDates.contains(now))
          dueDates.add(now);
      } else {
        var realDue = now.add(Duration(days: freq - (timeRange % freq)));
        if (!dueDates.contains(realDue))
          dueDates.add(realDue);
      }
    }
  }

  void updateDueDate () {
    if (!isFinished) {
      var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

      if (now.compareTo(repeatOption.beginDateTime) >= 0) {
        if (repeatOption.type == 'until' && now.isAfter(repeatOption.extraTypeInfo)) {
          isFinished = true;
          return;
        } else if (repeatOption.type == 'for' && repeatOption.extraTypeInfo == 0) {
          isFinished = true;
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
          if (!dueDates.contains(nextDue))
            dueDates.add(nextDue);
          if (repeatOption.type == 'for')
            repeatOption.extraTypeInfo--;
        }
      }
    }
  }


}
