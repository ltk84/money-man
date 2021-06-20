import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/time_range_info_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/time_range.dart';
import 'package:money_man/ui/screens/report_screens/custom_time_range.dart';
import 'package:money_man/ui/screens/report_screens/time_selection.dart';

class SelectTimeRangeScreen extends StatefulWidget {
  @override
  _SelectTimeRangeScreenState createState() => _SelectTimeRangeScreenState();
}

class _SelectTimeRangeScreenState extends State<SelectTimeRangeScreen> {
  @override
  BudgetTimeRange budgetTimeRange;
  var beginDate;
  var endDate;
  var dateDescript;
  String GetSubTitileOfTheWeek(DateTime today) {
    var firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var endDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    String result = DateFormat('dd/MM').format(firstDayOfWeek) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfWeek);
    return result;
  }

  BudgetTimeRange GetmTimeRangeWeek(DateTime today) {
    var firstDayOfWeek = today.subtract(Duration(days: today.weekday - 1));
    //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    var endDayOfWeek = firstDayOfWeek.add(Duration(days: 6));
    return new BudgetTimeRange(
        beginDay: firstDayOfWeek,
        endDay: endDayOfWeek,
        description: 'This week');
  }

  String GetSubTitleOfTheMonth(DateTime today) {
    var firstDayOfMonth = today.subtract(Duration(days: today.day - 1));
    var endDayOfMonth =
        DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));
    String result = DateFormat('dd/MM').format(firstDayOfMonth) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfMonth);
    return result;
  }

  BudgetTimeRange GetmTimeRangeMonth(DateTime today) {
    var firstDayOfMonth = today.subtract(Duration(days: today.day - 1));
    var endDayOfMonth =
        DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfMonth,
        endDay: endDayOfMonth,
        description:
            DateTime.now().isBefore(today) ? 'Next month' : 'This month');
  }

  String GetSubTitleOfTheQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    String result = DateFormat('dd/MM').format(firstDayOfQuarter) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfQuarter);
    return result;
  }

  BudgetTimeRange GetmTimeRangeQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfQuarter,
        endDay: endDayOfQuarter,
        description: 'This quarter');
  }

  String GetSubTitleOfTheNextQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 5;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    String result = DateFormat('dd/MM').format(firstDayOfQuarter) +
        ' - ' +
        DateFormat('dd/MM').format(endDayOfQuarter);
    return result;
  }

  BudgetTimeRange GetmTimeRangeNextQuarter(DateTime today) {
    double quarterNumber = (today.month - 1) / 3 + 5;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfQuarter,
        endDay: endDayOfQuarter,
        description: 'Next quarter');
  }

  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    return Theme(
      data: ThemeData(fontFamily: 'Montserrat'),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Container(alignment: Alignment.center, child: Text('Back')),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xff222222),
          title: Text(
            'Select time range',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
        ),
        body: Container(
          color: Color(0xff1a1a1a),
          child: ListView(
            children: [
              Container(
                child: buildTimeRangeListTile(
                    title: 'This week',
                    subTitle: GetSubTitileOfTheWeek(today),
                    mTimeRange: GetmTimeRangeWeek(today)),
              ),
              Divider(
                color: Color(0xff333333),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'This month',
                    subTitle: GetSubTitleOfTheMonth(today),
                    mTimeRange: GetmTimeRangeMonth(today)),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'This quarter',
                    subTitle: GetSubTitleOfTheQuarter(today),
                    mTimeRange: GetmTimeRangeQuarter(today)),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'This year',
                    subTitle: '01/01 - 31/12',
                    mTimeRange: new BudgetTimeRange(
                        beginDay: new DateTime(today.year, 1, 1),
                        endDay: new DateTime(today.year, 12, 31),
                        description: "This year")),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'Next month',
                    subTitle: GetSubTitleOfTheMonth(
                        new DateTime(today.year, today.month + 1, today.day)),
                    mTimeRange: GetmTimeRangeMonth(
                        new DateTime(today.year, today.month + 1, today.day))),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'Next quarter',
                    subTitle: GetSubTitleOfTheNextQuarter(
                        new DateTime(today.year, today.month + 3, today.day)),
                    mTimeRange: GetmTimeRangeNextQuarter(
                        new DateTime(today.year, today.month + 3, today.day))),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'Next year',
                    subTitle:
                        '01/01/${today.year + 1} - 31/12/${today.year + 1}',
                    mTimeRange: new BudgetTimeRange(
                        beginDay: new DateTime(today.year + 1, 1, 1),
                        endDay: new DateTime(today.year + 1, 12, 31),
                        description: "Next year")),
              ),
              Container(
                child: buildTimeRangeListTile(
                    title: 'Custom time range',
                    subTitle: 'dd/MM/YYYY - dd/MM/YYYY',
                    mCustom: true),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeRangeListTile(
      {String title = "title",
      String subTitle = "sub tittle",
      bool mCustom = false,
      BudgetTimeRange mTimeRange = null}) {
    return Container(
      padding: EdgeInsets.only(left: 50),
      child: ListTile(
        onTap: mCustom
            ? () async {
                print('psoidjb oker');
                TimeRangeInfo result = await showCupertinoModalBottomSheet(
                    //TimeRangeInfor
                    isDismissible: true,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) => CustomTimeRange(
                        beginDate: beginDate, endDate: endDate));
                if (result != null) {
                  setState(() {
                    mTimeRange = new BudgetTimeRange(
                        beginDay: result.begin, endDay: result.end);
                  });
                  Navigator.of(context).pop(mTimeRange);
                }
              }
            : () {
                Navigator.of(context).pop(mTimeRange);
              },
        title: Text(
          title,
          style:
              TextStyle(color: white, fontFamily: 'Montserrat', fontSize: 17),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(color: Colors.white38, fontSize: 14),
        ),
      ),
    );
  }
}
