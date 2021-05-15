import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomTimeRange extends StatefulWidget{
  @override
  CustomTimeRangeState createState() =>  CustomTimeRangeState();
}
class  CustomTimeRangeState extends State<CustomTimeRange>{
  String _beginDate = 'Begin date';
  String _endDate = 'End date';
  DateTime realBeginDate;
  DateTime realEndDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Custom',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0)),

          leadingWidth: 250.0,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white),
                Text('Back', style: Theme.of(context).textTheme.headline6)
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  if (realBeginDate != null
                      && realEndDate != null
                      && realBeginDate.compareTo(realEndDate) <= 0)
                    Navigator.of(context).pop([realBeginDate, realEndDate, 'Custom']);
                  else
                    Alert(context: context, title: "FilledStacks", desc: "Flutter is awesome.").show();
                },
                child: Text('Done', style: Theme.of(context).textTheme.headline6)
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 25),
              child: ListTile (
                onTap: () {
                  DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    onConfirm: (date) {
                      setState(() {
                        realBeginDate = date;
                        _beginDate = DateFormat('dd/MM/yyyy').format(date);
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                    theme: DatePickerTheme(
                      cancelStyle: TextStyle(color: Colors.white),
                      doneStyle: TextStyle(color: Colors.white),
                      itemStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.grey[900],
                    )
                  );
                },
                tileColor: Colors.transparent,
                title: Text(_beginDate,
                    style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  )
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey[500]),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: ListTile (
                onTap: () {
                  DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    onConfirm: (date) {
                      setState(() {
                        realEndDate = date;
                        _endDate = DateFormat('dd/MM/yyyy').format(date);
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                    theme: DatePickerTheme(
                      cancelStyle: TextStyle(color: Colors.white),
                      doneStyle: TextStyle(color: Colors.white),
                      itemStyle: TextStyle(color: Colors.white),
                      backgroundColor: Colors.grey[900],
                    )
                  );
                },
                tileColor: Colors.transparent,
                title: Text(_endDate,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  )
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey[500]),
              ),
            )
          ],
        )
    );
  }
}