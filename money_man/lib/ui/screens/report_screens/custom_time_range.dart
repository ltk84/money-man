import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/time_range_info_model.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomTimeRange extends StatefulWidget {
  final beginDate;
  final endDate;

  CustomTimeRange({Key key, @required this.beginDate, @required this.endDate})
      : super(key: key);
  @override
  CustomTimeRangeState createState() => CustomTimeRangeState();
}

class CustomTimeRangeState extends State<CustomTimeRange> {
  DateTime realBeginDate;
  DateTime realEndDate;

  @override
  void initState() {
    super.initState();
    realBeginDate = widget.beginDate;
    realEndDate = widget.endDate;
  }

  @override
  void didUpdateWidget(covariant CustomTimeRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    realBeginDate = widget.beginDate;
    realEndDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    // Lấy giá trị ngày bắt đầu từ tham số truyền vào.
    String beginDate = realBeginDate != null
        ? DateFormat('dd/MM/yyyy').format(realBeginDate)
        : 'Choose begin date';

    // Lấy giá trị ngày kết thúc từ tham số truyền vào.
    String endDate = realEndDate != null
        ? DateFormat('dd/MM/yyyy').format(realEndDate)
        : 'Choose end date';

    return Scaffold(
        backgroundColor: Style.boxBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.appBarColor,
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
                // Đảm bảo phải có giá trị ngày bắt đầu và ngày kết thúc được chọn một cách hợp lệ thì mới có thể trả về kết quả.
                onPressed: (realBeginDate == null || realEndDate == null)
                    ? null
                    : () {
                        if (realBeginDate != null &&
                            realEndDate != null &&
                            realBeginDate.compareTo(realEndDate) <= 0)
                          Navigator.of(context).pop(TimeRangeInfo(
                              description: 'Custom',
                              begin: realBeginDate,
                              end: realEndDate));
                        else {
                          // Ngày kết thúc nhỏ hơn ngày bắt đầu và một trong hai bằng rỗng thì sẽ hiện lên thông báo lỗi.
                          showAlertDialog();
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
                    fontWeight: FontWeight.w600,
                  ),
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
                child: Text('Begin date',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Style.foregroundColor.withOpacity(0.54),
                    )),
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
                    });
                  },
                      locale: LocaleType.en,
                      theme: DatePickerTheme(
                        cancelStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor),
                        doneStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor),
                        itemStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor),
                        backgroundColor: Style.boxBackgroundColor,
                      ));
                },
                tileColor: Colors.transparent,
                title: Text(beginDate,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: beginDate != 'Choose begin date'
                          ? Style.foregroundColor
                          : Style.foregroundColor.withOpacity(0.24),
                    )),
                trailing: Icon(Icons.chevron_right,
                    color: Style.foregroundColor.withOpacity(0.54)),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 8, 8, 2),
                child: Text('End date',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Style.foregroundColor.withOpacity(0.54),
                    )),
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
                            color: Style.foregroundColor),
                        doneStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor),
                        itemStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor),
                        backgroundColor: Style.boxBackgroundColor,
                      ));
                },
                tileColor: Colors.transparent,
                title: Text(endDate,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: endDate != 'Choose end date'
                          ? Style.foregroundColor
                          : Style.foregroundColor.withOpacity(0.24),
                    )),
                trailing: Icon(Icons.chevron_right,
                    color: Style.foregroundColor.withOpacity(0.54)),
              ),
            ],
          ),
        ));
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(
            content: "End date must be after begin date,\nplease try again.");
      },
    );
  }
}
