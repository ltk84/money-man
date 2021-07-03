import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/repeat_option_model.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/expandable_widget.dart';

class RepeatOptionScreen extends StatefulWidget {
  final RepeatOption repeatOption;
  RepeatOptionScreen({
    Key key,
    @required this.repeatOption,
  }) : super(key: key);

  @override
  _RepeatOptionScreenState createState() => _RepeatOptionScreenState();
}

class _RepeatOptionScreenState extends State<RepeatOptionScreen> {
  // Danh sách tần số và biến lưu thứ tự được chọn.
  List<String> frequencyList;
  int selectedFrequencyIndex;

  // Kiểu tần số.
  String freqType;

  // Thông tin khoảng thời gian.
  int rangeAmount;
  DateTime beginDateTime;
  DateTime endDateTime;
  int repeatTime;

// Thông tin người dùng chọn (chọn mở rộng phần nào, phần nào đang được chọn).
  bool expandOption;
  int selectedOption;

  // Kiểu của phần được chọn, được mở rộng.
  bool expandTypeOption;
  int selectedTypeOption;

  // Biến lưuu thông tin tùy chọn lặp lại.
  RepeatOption repeatOption;

  @override
  void initState() {
    // Khoi tao

    repeatOption = widget.repeatOption;

    // Này là để lấy Frequency đang chọn để quyết định đơn vị của rangeAmount là ngày, tuần, tháng hay là năm.
    frequencyList = ['daily', 'weekly', 'monthly', 'yearly'];
    selectedFrequencyIndex = frequencyList.indexOf(repeatOption.frequency);

    // Biến để lưu chuỗi đơn vị cho rangeAmount.
    if (selectedFrequencyIndex == 0) {
      freqType = 'day';
    } else if (selectedFrequencyIndex == 1) {
      freqType = 'week';
    } else if (selectedFrequencyIndex == 2) {
      freqType = 'month';
    } else {
      freqType = 'year';
    }

    // Biến để lưu các giá trị tùy chọn.
    rangeAmount = repeatOption.rangeAmount;
    beginDateTime = repeatOption.beginDateTime;
    endDateTime = repeatOption.extraTypeInfo is DateTime == false
        ? beginDateTime.add(Duration(days: 1))
        : repeatOption.extraTypeInfo;
    repeatTime = repeatOption.type == 'for' ? repeatOption.extraTypeInfo : 1;

    // Biến triggẻ để xử lý các tùy chọn.
    expandOption = false;
    selectedOption = 0;

    // Biến trigger để xử lý chọn loại lặp lại.
    expandTypeOption = false;
    if (repeatOption.type == 'forever') {
      selectedTypeOption = 1;
    } else if (repeatOption.type == 'until') {
      selectedTypeOption = 2;
    } else {
      selectedTypeOption = 3;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Style.backgroundColor1,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Style.boxBackgroundColor2,
          elevation: 0.0,
          leading: CloseButton(
            color: Style.foregroundColor,
            onPressed: () {
              Navigator.of(context).pop(repeatOption);
            },
          ),
          title: Text('Repeat Options',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,
              )),
          centerTitle: true,
        ),
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
                color: Style.boxBackgroundColor,
                margin: EdgeInsets.only(top: 30.0),
                child: Column(children: [
                  // Phần chọn Frequency
                  Column(
                    children: [
                      // Nút ấn để expand phần chọn Frequency
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedOption != 1) {
                                selectedOption = 1;
                                expandOption = true;
                              } else
                                expandOption = !expandOption;
                            });
                          },
                          child: buildFrequencyOption(
                              display: 'Repeat ' +
                                  frequencyList[selectedFrequencyIndex])),

                      // Phần expand để chọn Frequency
                      ExpandableWidget(
                        expand: selectedOption != 1 ? false : expandOption,
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                              color: Style.boxBackgroundColor,
                              border: Border(
                                  bottom: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ))),
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                                brightness: Brightness.dark,
                                textTheme: CupertinoTextThemeData(
                                    pickerTextStyle: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ))),
                            child: CupertinoPicker.builder(
                                childCount: frequencyList.length,
                                itemExtent: 30,
                                scrollController: FixedExtentScrollController(
                                    initialItem: selectedFrequencyIndex),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    selectedFrequencyIndex = index;
                                    freqType = getFreqTypeString(
                                        selectedFrequencyIndex);
                                    repeatOption.frequency =
                                        frequencyList[selectedFrequencyIndex];
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: Text(
                                      'Repeat ' + frequencyList[index],
                                    ),
                                  );
                                }),
                          ),
                        ),
                      )
                    ],
                  ),

                  // Phần chọn Range Amount
                  Column(
                    children: [
                      // Nút ấn để expand phần chọn Range Amount
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedOption != 2) {
                                selectedOption = 2;
                                expandOption = true;
                              } else
                                expandOption = !expandOption;
                            });
                          },
                          child: buildRangeOption(
                              display: rangeAmount.toString() +
                                  ' ' +
                                  freqType +
                                  ((rangeAmount == 1) ? '' : 's'))),

                      // Phần expand để chọn Range Amount
                      ExpandableWidget(
                        expand: selectedOption != 2 ? false : expandOption,
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                              color: Style.boxBackgroundColor,
                              border: Border(
                                  bottom: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ))),
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                                brightness: Brightness.dark,
                                textTheme: CupertinoTextThemeData(
                                    pickerTextStyle: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ))),
                            child: CupertinoPicker.builder(
                                itemExtent: 30,
                                scrollController: FixedExtentScrollController(
                                    initialItem: rangeAmount - 1),
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    rangeAmount = index + 1;
                                    repeatOption.rangeAmount = rangeAmount;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  if (index >= 0) {
                                    return Center(
                                      child: Text(
                                        (index + 1).toString() +
                                            ' ' +
                                            freqType +
                                            ((index == 0) ? '' : 's'),
                                      ),
                                    );
                                  }
                                }),
                          ),
                        ),
                      )
                    ],
                  ),

                  // Phần chọn Begin Date
                  Column(
                    children: [
                      // Nút ấn để expand phần chọn Begin Date
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedOption != 3) {
                                selectedOption = 3;
                                expandOption = true;
                              } else
                                expandOption = !expandOption;
                            });
                          },
                          child: buildBeginDateOption(
                              display: DateFormat('dd/MM/yyyy')
                                  .format(beginDateTime))),

                      // Phần expand để chọn Begin Date
                      ExpandableWidget(
                        expand: selectedOption != 3 ? false : expandOption,
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                              color: Style.boxBackgroundColor,
                              border: Border(
                                  bottom: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ))),
                          child: CupertinoTheme(
                            data: CupertinoThemeData(
                                brightness: Brightness.dark,
                                textTheme: CupertinoTextThemeData(
                                    dateTimePickerTextStyle: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ))),
                            child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                minimumDate: beginDateTime,
                                initialDateTime: beginDateTime,
                                onDateTimeChanged: (val) {
                                  setState(() {
                                    beginDateTime = val;
                                    endDateTime =
                                        beginDateTime.add(Duration(days: 1));
                                    repeatOption.beginDateTime = beginDateTime;
                                  });
                                }),
                          ),
                        ),
                      )
                    ],
                  ),
                ])),

            // Phần dưới này là phần chọn loại lặp lại.
            Container(
                color: Style.boxBackgroundColor,
                margin: EdgeInsets.only(top: 30.0),
                child: Column(children: [
                  // Đây là phần chọn type Forever.
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTypeOption = 1;
                          repeatOption.type = 'forever';
                        });
                      },
                      child: buildForeverOption(
                          selected: selectedTypeOption == 1)),

                  // Đây là phần chọn type Until.
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedTypeOption != 2) {
                            selectedTypeOption = 2;
                            expandTypeOption = true;
                            repeatOption.type = 'until';
                            repeatOption.extraTypeInfo = endDateTime;
                          } else
                            expandTypeOption = !expandTypeOption;
                        });
                      },
                      child: buildEndingDateOption(
                          display: DateFormat('dd/MM/yyyy').format(endDateTime),
                          selected: selectedTypeOption == 2)),
                  ExpandableWidget(
                    expand: selectedTypeOption != 2 ? false : expandTypeOption,
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                          color: Style.boxBackgroundColor,
                          border: Border(
                              bottom: BorderSide(
                            color: Style.foregroundColor.withOpacity(0.12),
                            width: 0.5,
                          ))),
                      child: CupertinoTheme(
                        data: CupertinoThemeData(
                            brightness: Brightness.dark,
                            textTheme: CupertinoTextThemeData(
                                dateTimePickerTextStyle: TextStyle(
                              color: Style.foregroundColor,
                              fontFamily: Style.fontFamily,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ))),
                        child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            minimumDate: beginDateTime,
                            initialDateTime: endDateTime,
                            onDateTimeChanged: (val) {
                              setState(() {
                                endDateTime = val;
                                repeatOption.extraTypeInfo = endDateTime;
                              });
                            }),
                      ),
                    ),
                  ),

                  // Đây là phần chọn type For.
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedTypeOption != 3) {
                            selectedTypeOption = 3;
                            expandTypeOption = true;
                            repeatOption.type = 'for';
                            repeatOption.extraTypeInfo = repeatTime;
                          } else
                            expandTypeOption = !expandTypeOption;
                        });
                      },
                      child: buildRepeatTimeOption(
                          display: repeatTime.toString() +
                              ' time' +
                              (repeatTime == 1 ? '' : 's'),
                          selected: selectedTypeOption == 3)),
                  ExpandableWidget(
                    expand: selectedTypeOption != 3 ? false : expandTypeOption,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                          color: Style.boxBackgroundColor,
                          border: Border(
                              bottom: BorderSide(
                            color: Style.foregroundColor.withOpacity(0.12),
                            width: 0.5,
                          ))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80.0,
                            child: TextFormField(
                              initialValue: repeatTime.toString(),
                              onChanged: (value) {
                                setState(() {
                                  repeatTime = int.parse(value);
                                  repeatOption.extraTypeInfo = repeatTime;
                                  print(repeatOption.extraTypeInfo);
                                });
                              },
                              style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontSize: 15.0,
                                color: Style.foregroundColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                              keyboardAppearance: Brightness.dark,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(8, 10, 8, 0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.24),
                                      width: 0.5,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Style.foregroundColor
                                          .withOpacity(0.24),
                                      width: 0.5,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Text('time(s)',
                              style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                                color: Style.foregroundColor.withOpacity(0.7),
                              )),
                        ],
                      ),
                    ),
                  ),
                ])),
          ],
        ));
  }

  Widget buildFrequencyOption({@required String display}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.5,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Frequency',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor,
              )),
          Text(display,
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor.withOpacity(0.38),
              )),
        ],
      ),
    );
  }

  Widget buildRangeOption({@required String display}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.5,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Every',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor,
              )),
          Text(display,
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor.withOpacity(0.38),
              )),
        ],
      ),
    );
  }

  Widget buildBeginDateOption({@required String display}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.5,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('From',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor,
              )),
          Text(display,
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor.withOpacity(0.38),
              )),
        ],
      ),
    );
  }

  Widget buildForeverOption({@required bool selected}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.5,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Forever',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor,
              )),
          !selected
              ? Container()
              : Icon(Icons.check, color: Style.successColor, size: 20.0),
        ],
      ),
    );
  }

  Widget buildEndingDateOption(
      {@required String display, @required bool selected}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.5,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Until',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor,
              )),
          !selected
              ? Container()
              : Text(display,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor.withOpacity(0.38),
                  )),
          !selected
              ? Container()
              : Icon(Icons.check, color: Style.successColor, size: 20.0),
        ],
      ),
    );
  }

  Widget buildRepeatTimeOption({@required String display, @required selected}) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 12, 15, 12),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.5,
          ))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('For',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Style.foregroundColor,
              )),
          !selected
              ? Container()
              : Text(display,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor.withOpacity(0.38),
                  )),
          !selected
              ? Container()
              : Icon(Icons.check, color: Style.successColor, size: 20.0),
        ],
      ),
    );
  }

  // Hàm lấy đơn vị cho tần số.
  String getFreqTypeString(int indexFreq) {
    switch (indexFreq) {
      case 0:
        return 'day';
        break;
      case 1:
        return 'week';
        break;
      case 2:
        return 'month';
        break;
      case 3:
        return 'year';
        break;
    }
  }
}
