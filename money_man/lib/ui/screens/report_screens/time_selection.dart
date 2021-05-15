import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';

import 'custom_time_range.dart';

class TimeRangeSelection extends StatefulWidget{
  @override
  TimeRangeSelectionState createState() =>  TimeRangeSelectionState();
}
class  TimeRangeSelectionState extends State<TimeRangeSelection>{
  List<TimeRangeInfo> listInfo = [
    TimeRangeInfo(
        'This month',
        DateTime(DateTime.now().year, DateTime.now().month, 1),
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0)
    ),
    TimeRangeInfo(
        'Custom',
        null,
        null
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          leadingWidth: 70.0,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Select Time Range',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0)),
          leading: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )
          ),
        ),
      body: ListView.separated(
        itemCount: listInfo.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (BuildContext context, int index) {
          String beginDate = (listInfo[index].begin == null) ? '--' : DateFormat('dd/MM/yyyy').format(listInfo[index].begin);
          String endDate = (listInfo[index].end == null) ? '--' : DateFormat('dd/MM/yyyy').format(listInfo[index].end);

          return ListTile(
            onTap: () {
              if (listInfo[index].description == 'Custom') {
                showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) => CustomTimeRange()
                );
              }
              else {
                final result = [listInfo[index].begin, listInfo[index].end, listInfo[index].description];
                Navigator.of(context).pop(result);
              }
            },
            title: Text(listInfo[index].description,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              )
            ),
            subtitle: Text(beginDate + " - " + endDate,
                style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500],
              )
            ),
            trailing: Icon(Icons.check, color: Colors.blueAccent),
          );
        },
      )
    );
  }
}

class TimeRangeInfo {
  String description;
  DateTime begin;
  DateTime end;

  TimeRangeInfo(this.description, this.begin, this.end);
}