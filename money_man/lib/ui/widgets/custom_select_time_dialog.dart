import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:money_man/ui/style.dart';

import 'custom_alert.dart';

class CustomSelectTimeDialog extends StatefulWidget {
  @override
  _CustomSelectTimeDialogState createState() => _CustomSelectTimeDialogState();
}

class _CustomSelectTimeDialogState extends State<CustomSelectTimeDialog> with SingleTickerProviderStateMixin {
  //Tạo controller animation cho animation
  AnimationController controller;
  //Tạo animation
  Animation<double> scaleAnimation;

  //Thời gian bắt đầu
  DateTime beginDate;
  //Thời gian kết thúc
  DateTime endDate;
  // string biểu diễn ngày bắt đầu
  String beginDisplay;
  // string biểu diễn ngày kết thúc
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
            color: Style.boxBackgroundColor,
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
                  fontFamily: Style.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                )
              ),
              SizedBox(height: 20.0),
              Center(
                child: Column(
                  children: [
                    Text(
                        'From',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Style.foregroundColor.withOpacity(0.7),
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
                              color: Style.foregroundColor.withOpacity(0.38),
                            )
                          )
                        ),
                        child: Text(
                            beginDisplay ?? 'Choose date',
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 16,
                              fontWeight: beginDisplay == null ? FontWeight.w400 : FontWeight.w600,
                              color: beginDisplay == null ? Style.foregroundColor.withOpacity(0.12): Style.foregroundColor,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // hiển thị dialog chọn thời gian khi nhấn vào
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
                              cancelStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor
                              ),
                              doneStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor
                              ),
                              itemStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor
                              ),
                              backgroundColor: Style.boxBackgroundColor,
                            ));
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                        'To',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Style.foregroundColor.withOpacity(0.7),
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
                                  color: Style.foregroundColor.withOpacity(0.38),
                                )
                            )
                        ),
                        child: Text(
                            endDisplay ?? 'Choose date',
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 16,
                              fontWeight: endDisplay == null ? FontWeight.w400 : FontWeight.w600,
                              color: endDisplay == null ? Style.foregroundColor.withOpacity(0.12): Style.foregroundColor,
                            ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // Hiển thị dialog chọn thời gian khi nhấn vào
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
                              cancelStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor
                              ),
                              doneStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor
                              ),
                              itemStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor
                              ),
                              backgroundColor: Style.boxBackgroundColor,
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
                          fontFamily: Style.fontFamily,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Style.primaryColor,
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
                          _showAlertDialog("Ending date must be after starting date,\nplease try again.");
                        }
                      },
                      child: Text(
                          'DONE',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: (beginDate == null || endDate == null)
                                ? Style.primaryColor.withOpacity(0.4)
                                : Style.primaryColor,
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

  // Hàm hiển thị dialog khi gặp lỗi chọn ngày
  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
