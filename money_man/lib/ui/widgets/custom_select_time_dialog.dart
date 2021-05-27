import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import 'custom_alert.dart';

class CustomSelectTimeDialog extends StatefulWidget {
  @override
  _CustomSelectTimeDialogState createState() => _CustomSelectTimeDialogState();
}

class _CustomSelectTimeDialogState extends State<CustomSelectTimeDialog> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  DateTime beginDate;
  DateTime endDate;
  String beginDisplay;
  String endDisplay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0,10.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  'Select time range',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )
              ),
              SizedBox(height: 20.0),
              Center(
                child: Column(
                  children: [
                    Text(
                        'From',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        )
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.white38,
                            )
                          )
                        ),
                        child: Text(
                            beginDisplay ?? 'Choose date',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: beginDisplay == null ? FontWeight.w400 : FontWeight.w600,
                              color: beginDisplay == null ? Colors.white12: Colors.white,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                    Text(
                        'To',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        )
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.white38,
                                )
                            )
                        ),
                        child: Text(
                            endDisplay ?? 'Choose date',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: endDisplay == null ? FontWeight.w400 : FontWeight.w600,
                              color: endDisplay == null ? Colors.white12: Colors.white,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
                      child: Text(
                          'CANCEL',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2FB49C),
                        )
                      )
                  ),
                  TextButton(
                      onPressed: (beginDate == null || endDate == null)
                          ? null
                          :  () {
                        if (beginDate != null &&
                            endDate != null &&
                            beginDate.compareTo(endDate) < 0) {
                          Navigator.pop(context, [beginDate, endDate]);
                        }
                        else {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false, // user must tap button!
                            barrierColor: Colors.black54,
                            builder: (BuildContext context) {
                              return CustomAlert(content: "End date can't be before or the same with begin date.");
                            },
                          );
                        }
                      },
                      child: Text(
                          'DONE',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: (beginDate == null || endDate == null)
                                ? Color(0xFF2FB49C).withOpacity(0.4)
                                : Color(0xFF2FB49C),
                          )
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
