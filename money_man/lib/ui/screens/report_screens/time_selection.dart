import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/time_range_info_model.dart';
import 'package:money_man/ui/style.dart';

import 'custom_time_range.dart';

class TimeRangeSelection extends StatefulWidget {
  // Mô tả cho khoảng thời gian. Ví dụ: "Tháng này", "Tháng sau", "Năm trước", "Năm nay".
  final dateDescription;

  // Ngày bắt đầu của khoảng thời gian.
  final beginDate;

  // Ngày kết thúc của khoảng thời gian.
  final endDate;

  TimeRangeSelection(
      {Key key,
      @required this.dateDescription,
      @required this.beginDate,
      @required this.endDate})
      : super(key: key);

  @override
  TimeRangeSelectionState createState() => TimeRangeSelectionState();
}

class TimeRangeSelectionState extends State<TimeRangeSelection> {
  // Mô tả cho khoảng thời gian. Ví dụ: "Tháng này", "Tháng sau", "Năm trước", "Năm nay".
  dynamic dateDescription;

  // Ngày bắt đầu của khoảng thời gian.
  dynamic beginDate;

  // Ngày kết thúc của khoảng thời gian.
  dynamic endDate;

  // Danh sách khoảng thời gian để người dùng chọn.
  List<dynamic> listInfo = [];

  @override
  void initState() {
    super.initState();

    // Lấy giá trị của tham số mô tả được truyền vào.
    dateDescription = widget.dateDescription;

    // Lấy giá trị của tham số ngày bắt đầu được truyền vào.
    beginDate = widget.beginDate;

    // Lấy giá trị của tham số ngày kết thúc được truyền vào.
    endDate = widget.endDate;

    // Đảm bảo danh sách trống.
    listInfo.clear();

    // Thêm khoảng thời gian "This month" và danh sách.
    listInfo.add(TimeRangeInfo(
        description: 'This month',
        begin: DateTime(DateTime.now().year, DateTime.now().month, 1), // Lấy ngày đầu tiên của tháng và năm hiện tại.
        end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0))); // Lấy ngày cuối cùng của tháng và năm hiện tại.
    listInfo.add(TimeRangeInfo(
        description: 'Custom',
        begin: dateDescription == 'Custom' ? beginDate : null, // Nếu giá trị ngày đầu tiên được truyền vào khác rỗng thì lấy.
        end: dateDescription == 'Custom' ? endDate : null)); // Nếu giá trị ngày đầu tiên được truyền vào khác rỗng thì lấy.
  }

  @override
  void didUpdateWidget(covariant TimeRangeSelection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Lấy giá trị của tham số mô tả được truyền vào.
    dateDescription = widget.dateDescription;

    // Lấy giá trị của tham số ngày bắt đầu được truyền vào.
    beginDate = widget.beginDate;

    // Lấy giá trị của tham số ngày kết thúc được truyền vào.
    endDate = widget.endDate;

    // Đảm bảo danh sách trống.
    listInfo.clear();

    // Thêm khoảng thời gian "This month" và danh sách.
    listInfo.add(TimeRangeInfo(
        description: 'This month',
        begin: DateTime(DateTime.now().year, DateTime.now().month, 1), // Lấy ngày đầu tiên của tháng và năm hiện tại.
        end: DateTime(DateTime.now().year, DateTime.now().month + 1, 0))); // Lấy ngày cuối cùng của tháng và năm hiện tại.
    listInfo.add(TimeRangeInfo(
        description: 'Custom',
        begin: dateDescription == 'Custom' ? beginDate : null, // Nếu giá trị ngày đầu tiên được truyền vào khác rỗng thì lấy.
        end: dateDescription == 'Custom' ? endDate : null)); // Nếu giá trị ngày đầu tiên được truyền vào khác rỗng thì lấy.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.boxBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.appBarColor,
          title: Text('Select Time Range',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,
              )),
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
        ),
        body: Container(
          color: Style.backgroundColor1,
          child: ListView.separated(
            itemCount: listInfo.length,
            separatorBuilder: (BuildContext context, int index) => Divider(),
            itemBuilder: (BuildContext context, int index) {
              // Lấy dạng chuỗi của biến ngày bắt đầu, nếu biến không tồn tại thì chuỗi sẽ bằng giá trị mặc định là "Day/Month/Year"
              String beginDateString = (listInfo[index].begin == null)
                  ? 'Day/Month/Year'
                  : DateFormat('dd/MM/yyyy').format(listInfo[index].begin);

              // Lấy dạng chuỗi của biến ngày kết thúc, nếu biến không tồn tại thì chuỗi sẽ bằng giá trị mặc định là "Day/Month/Year"
              String endDateString = (listInfo[index].end == null)
                  ? 'Day/Month/Year'
                  : DateFormat('dd/MM/yyyy').format(listInfo[index].end);

              return ListTile(
                onTap: () async {
                  if (listInfo[index].description == 'Custom') {
                    // Lấy kết quả giá trị tự chọn cho khoảng thời gian "Custom".
                    final result = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.boxBackgroundColor,
                        context: context,
                        builder: (context) => CustomTimeRange(
                            beginDate: dateDescription == 'Custom'
                                ? beginDate
                                : null,
                            endDate: dateDescription == 'Custom'
                                ? endDate
                                : null));

                    // Đảm bảo kết quả lấy được ở trên khác rỗng và có cùng kiểu dữ liệu với đối tượng khoảng thời gian.
                    if (result.runtimeType == listInfo[0].runtimeType &&
                        result != null) {
                      setState(() {
                        // Thay đổi đối tượng khoảng thời gian Custom ban đầu thành khoảng thời gian Custom mới vừa lấy được ở trên.
                        listInfo.removeLast();
                        listInfo.add(result);
                        dateDescription = listInfo[index].description;
                      });

                      // Trả về khoảng thời gian người dùng chọn ra bên ngoài.
                      Navigator.of(context).pop(result);
                    }
                  } else {
                    // Nếu khoảng thời gian người dùng chọn là "This month" thì kết quả sẽ có giá trị của đối tượng khoảng thời gian "This month"
                    // với ngày bắt đầu và ngày kết thúc đã được khai báo ở trên phần khởi tạo.
                    var result = TimeRangeInfo(
                        description: listInfo[index].description,
                        begin: listInfo[index].begin,
                        end: listInfo[index].end);
                    setState(() {
                      dateDescription = listInfo[index].description;
                    });
                    // Trả về khoảng thời gian người dùng chọn ra bên ngoài.
                    Navigator.of(context).pop(result);
                  }
                },
                title: Text(listInfo[index].description,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Style.foregroundColor,
                    )),
                subtitle: Text(beginDateString + " - " + endDateString,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.54),
                    )),
                trailing: dateDescription == listInfo[index].description
                    ? Icon(Icons.check_rounded, color: Style.primaryColor)
                    : null, // Phần này là để hiển thị xem khoảng thời gian nào đang được chọn. Là "This month" hay "Custom".
              );
            },
          ),
        ));
  }
}
