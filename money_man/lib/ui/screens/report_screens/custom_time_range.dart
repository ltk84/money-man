import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/time_range_info_model.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CustomTimeRange extends StatefulWidget {
  final beginDate;
  final endDate;

  CustomTimeRange({Key key, @required this.beginDate, @required this.endDate})
      : super(key: key);
  @override
  CustomTimeRangeState createState() => CustomTimeRangeState();
}

class CustomTimeRangeState extends State<CustomTimeRange> {
  // String _beginDate = 'Begin date';
  // String _endDate = 'End date';
  DateTime realBeginDate;
  DateTime realEndDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    realBeginDate = widget.beginDate;
    realEndDate = widget.endDate;
  }

  @override
  void didUpdateWidget(covariant CustomTimeRange oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    realBeginDate = widget.beginDate;
    realEndDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    String _beginDate = realBeginDate != null
        ? DateFormat('dd/MM/yyyy').format(realBeginDate)
        : 'Begin date';
    String _endDate = realEndDate != null
        ? DateFormat('dd/MM/yyyy').format(realEndDate)
        : 'End date';

    return Scaffold(
        backgroundColor: Style.boxBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.boxBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Custom',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,
              )),
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
          actions: [
            TextButton(
                onPressed: (realBeginDate == null || realEndDate == null)
                    ? null
                    : () {
                        if (realBeginDate != null &&
                            realEndDate != null &&
                            realBeginDate.compareTo(realEndDate) < 0)
                          Navigator.of(context).pop(TimeRangeInfo(
                              description: 'Custom',
                              begin: realBeginDate,
                              end: realEndDate));
                        else {
                          _showAlertDialog();
                        }
                      },
                child: Text(
                  'Done',
                  style: TextStyle(
                      color: (realBeginDate == null || realEndDate == null)
                          ? Style.foregroundColor.withOpacity(0.24)
                          : Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,),
                ))
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Style.backgroundColor1,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 8, 2),
                child: Text(
                  'Begin date',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Style.foregroundColor.withOpacity(0.54),
                  )
                ),
              ),
              ListTile(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      currentTime: realBeginDate == null
                          ? DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day)
                          : realBeginDate,
                      showTitleActions: true, onConfirm: (date) {
                    setState(() {
                      // Bước xét DateFormat này là do realBeginDate có thể bị lệch giờ,
                      // dẫn đến hiện tượng không so sánh được DateTime của transaction (không có giờ phút giây).
                      // DateFormat này để cho realBeginDate có trùng giờ với DateTime của transaction (không có giờ phút giây).
                      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                      String formattedDate = dateFormat.format(date);
                      realBeginDate = dateFormat.parse(formattedDate);
                      //_beginDate = DateFormat('dd/MM/yyyy').format(date);
                    });
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
                tileColor: Colors.transparent,
                title: Text(_beginDate,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _beginDate != 'Choose begin date' ? Style.foregroundColor : Style.foregroundColor.withOpacity(0.24),
                    )),
                trailing: Icon(Icons.chevron_right, color: Style.foregroundColor.withOpacity(0.54)),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 8, 2),
                child: Text(
                    'End date',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Style.foregroundColor.withOpacity(0.54),
                    )
                ),
              ),
              ListTile(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      currentTime: realEndDate == null
                          ? DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day)
                          : realEndDate,
                      showTitleActions: true, onConfirm: (date) {
                    setState(() {
                      // Bước xét DateFormat này là do realEndDate có thể bị lệch giờ,
                      // dẫn đến hiện tượng không so sánh được DateTime của transaction (không có giờ phút giây).
                      // DateFormat này để cho realEndDate có trùng giờ với DateTime của transaction (không có giờ phút giây).
                      DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                      String formattedDate = dateFormat.format(date);
                      realEndDate = dateFormat.parse(formattedDate);
                      //_endDate = DateFormat('dd/MM/yyyy').format(date);
                    });
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
                tileColor: Colors.transparent,
                title: Text(_endDate,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: _endDate != 'Choose end date' ? Style.foregroundColor : Style.foregroundColor.withOpacity(0.24),
                    )),
                trailing: Icon(Icons.chevron_right, color: Style.foregroundColor.withOpacity(0.54)),
              ),
            )
          ],
        ));
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(
            content: "End date muse be after begin date,\nplease try again.");
      },
    );
  }
}
