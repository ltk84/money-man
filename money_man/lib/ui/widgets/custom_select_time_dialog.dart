import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'custom_alert.dart';

class CustomSelectTimeDialog extends StatefulWidget {
  @override
  _CustomSelectTimeDialogState createState() => _CustomSelectTimeDialogState();
}

class _CustomSelectTimeDialogState extends State<CustomSelectTimeDialog> {
  DateTime beginDate;
  DateTime endDate;
  String beginDisplay;
  String endDisplay;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Select time range'),
            Center(
              child: Column(
                children: [
                  Text('From'),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    child: Text(beginDisplay ?? 'Choose date'),
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          currentTime: beginDate == null
                              ? DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day)
                              : beginDate,
                          showTitleActions: true, onConfirm: (date) {
                        if (date != null) {
                          setState(() {
                            beginDate = date;
                            beginDisplay = beginDate == null
                                ? 'Select date'
                                : beginDate ==
                                        DateTime.parse(DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now()))
                                    ? 'Today'
                                    : beginDate ==
                                            DateTime.parse(DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now()
                                                    .add(Duration(days: 1))))
                                        ? 'Tomorrow'
                                        : beginDate ==
                                                DateTime.parse(DateFormat(
                                                        "yyyy-MM-dd")
                                                    .format(DateTime.now()
                                                        .subtract(
                                                            Duration(days: 1))))
                                            ? 'Yesterday'
                                            : DateFormat('EEEE, dd-MM-yyyy')
                                                .format(beginDate);
                          });
                        }
                      },
                          locale: LocaleType.en,
                          theme: DatePickerTheme(
                            cancelStyle: TextStyle(color: Colors.white),
                            doneStyle: TextStyle(color: Colors.white),
                            itemStyle: TextStyle(color: Colors.white),
                            backgroundColor: Colors.grey[900],
                          ));
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('To'),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    child: Text(endDisplay ?? 'Choose date'),
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          currentTime: endDate == null
                              ? DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day)
                              : endDate,
                          showTitleActions: true, onConfirm: (date) {
                        if (date != null) {
                          setState(() {
                            endDate = date;
                            endDisplay = endDate == null
                                ? 'Select date'
                                : endDate ==
                                        DateTime.parse(DateFormat("yyyy-MM-dd")
                                            .format(DateTime.now()))
                                    ? 'Today'
                                    : endDate ==
                                            DateTime.parse(DateFormat("yyyy-MM-dd")
                                                .format(DateTime.now()
                                                    .add(Duration(days: 1))))
                                        ? 'Tomorrow'
                                        : endDate ==
                                                DateTime.parse(DateFormat(
                                                        "yyyy-MM-dd")
                                                    .format(DateTime.now()
                                                        .subtract(
                                                            Duration(days: 1))))
                                            ? 'Yesterday'
                                            : DateFormat('EEEE, dd-MM-yyyy')
                                                .format(endDate);
                          });
                        }
                      },
                          locale: LocaleType.en,
                          theme: DatePickerTheme(
                            cancelStyle: TextStyle(color: Colors.white),
                            doneStyle: TextStyle(color: Colors.white),
                            itemStyle: TextStyle(color: Colors.white),
                            backgroundColor: Colors.grey[900],
                          ));
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL')),
                TextButton(
                    onPressed: () {
                      if (beginDate == null) {
                        _showAlertDialog('Please pick starting date');
                      } else if (endDate == null) {
                        _showAlertDialog('Please pick end date');
                      } else if (beginDate.compareTo(endDate) >= 0) {
                        _showAlertDialog(
                            'Ending date must be after starting date');
                      } else {
                        Navigator.pop(context, [beginDate, endDate]);
                      }
                    },
                    child: Text('SELECT TIME')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
