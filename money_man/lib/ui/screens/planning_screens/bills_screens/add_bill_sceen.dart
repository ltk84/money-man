import 'dart:ui';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/repeat_option_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/screens/categories_screens/categories_bill_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/repeat_option_screen.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/shared_screens/note_srcreen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddBillScreen extends StatefulWidget {
  final Wallet currentWallet;

  AddBillScreen({Key key, @required this.currentWallet}) : super(key: key);

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  // Biến lưu ví đang được chọn.
  Wallet selectedWallet;

  // Khởi tạo cái biến lưu thông tin hóa đơn.
  String currencySymbol;
  double amount;
  MyCategory category;
  String note;
  RepeatOption repeatOption;
  List<DateTime> dueDates;
  String repeatDescription;

  // Lấy ngày hiện tại.
  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    super.initState();
    // Cập nhật giá trị mặc định cho các biến.
    selectedWallet = widget.currentWallet;
    currencySymbol =
        CurrencyService().findByCode(selectedWallet.currencyID).symbol;
    repeatOption = RepeatOption(
        frequency: 'daily',
        rangeAmount: 1,
        extraAmountInfo: 'day',
        beginDateTime: now,
        type: 'forever',
        extraTypeInfo: null);
    repeatDescription = updateRepeatDescription();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);

    // Lấy mô tả cho tùy chọn lặp lại.
    repeatDescription = updateRepeatDescription();

    return StreamBuilder<Object>(
        stream: firestore.billStream(selectedWallet.id),
        builder: (context, snapshot) {
          List<Bill> listBills = snapshot.data ?? [];
          return Scaffold(
              backgroundColor: Style.backgroundColor1,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Style.appBarColor,
                elevation: 0.0,
                leading: CloseButton(
                  color: Style.foregroundColor,
                ),
                title: Text('Add Bill',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )),
                centerTitle: true,
                actions: [
                  TextButton(
                    onPressed: () async {
                      if (amount == null) {
                        showAlertDialog('Please enter amount!');
                      } else if (category == null) {
                        showAlertDialog('Please pick category!');
                      } else if (listBills.any((element) =>
                          element.category.name == category.name)) {
                        showAlertDialog(
                            'This category has already been used,\nplease pick again!');
                      } else {
                        dueDates = initDueDate();
                        var bill = Bill(
                          id: 'id',
                          category: category,
                          amount: amount,
                          walletId: selectedWallet.id,
                          note: note,
                          transactionIdList: [],
                          repeatOption: repeatOption,
                          isFinished: false,
                          dueDates: dueDates,
                          paidDueDates: [],
                        );

                        await firestore.addBill(bill, selectedWallet);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                  ),
                ],
              ),
              body: ListView(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(
                          color: Style.boxBackgroundColor,
                          border: Border(
                              top: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ),
                              bottom: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ))),
                      child: Column(children: [
                        // Hàm build Amount Input.
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              final resultAmount =
                                  await showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          EnterAmountScreen());
                              if (resultAmount != null)
                                setState(() {
                                  print(resultAmount);
                                  this.amount = double.parse(resultAmount);
                                });
                            },
                            child: buildAmountInput(
                              amount: amount,
                            )),

                        // Divider ngăn cách giữa các input field.
                        Container(
                          margin: EdgeInsets.only(left: 70),
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 1,
                          ),
                        ),

                        // Hàm build Category Selection.
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              final selectCate =
                                  await showCupertinoModalBottomSheet(
                                      isDismissible: true,
                                      backgroundColor: Style.boxBackgroundColor,
                                      context: context,
                                      builder: (context) =>
                                          CategoriesBillScreen());
                              if (selectCate != null) {
                                setState(() {
                                  this.category = selectCate;
                                });
                              }
                            },
                            child: buildCategorySelection(
                              display: this.category == null
                                  ? null
                                  : this.category.name,
                              iconPath: this.category == null
                                  ? null
                                  : this.category.iconID,
                            )),

                        // Divider ngăn cách giữa các input field.
                        Container(
                          margin: EdgeInsets.only(left: 70, top: 8),
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 1,
                          ),
                          height: 2,
                        ),

                        // Hàm build Note Input.
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              final noteContent =
                                  await showCupertinoModalBottomSheet(
                                      isDismissible: true,
                                      backgroundColor: Style.boxBackgroundColor,
                                      context: context,
                                      builder: (context) => NoteScreen(
                                            content: note ?? '',
                                          ));

                              if (noteContent != null) {
                                setState(() {
                                  note = noteContent;
                                });
                              }
                            },
                            child: buildNoteInput(
                              display: this.note == '' ? null : this.note,
                            )),

                        // Divider ngăn cách giữa các input field.
                        Container(
                          margin: EdgeInsets.only(left: 70),
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 1,
                          ),
                          height: 2,
                        ),

                        // Hàm build Wallet Selection.
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var res = await showCupertinoModalBottomSheet(
                                isDismissible: true,
                                backgroundColor: Style.boxBackgroundColor,
                                context: context,
                                builder: (context) => SelectWalletAccountScreen(
                                    wallet: selectedWallet));
                            if (res != null)
                              setState(() {
                                selectedWallet = res;
                                currencySymbol = CurrencyService()
                                    .findByCode(selectedWallet.currencyID)
                                    .symbol;
                              });
                          },
                          child: buildWalletSelection(
                            display: this.selectedWallet == null
                                ? null
                                : this.selectedWallet.name,
                            iconPath: this.selectedWallet == null
                                ? null
                                : this.selectedWallet.iconID,
                          ),
                        ),
                      ])),
                  Container(
                      margin: EdgeInsets.only(top: 30.0),
                      decoration: BoxDecoration(
                          color: Style.boxBackgroundColor,
                          border: Border(
                              top: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ),
                              bottom: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.12),
                                width: 0.5,
                              ))),
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () async {
                            var res = await showCupertinoModalBottomSheet(
                                enableDrag: false,
                                isDismissible: false,
                                backgroundColor: Style.boxBackgroundColor,
                                context: context,
                                builder: (context) => RepeatOptionScreen(
                                      repeatOption: repeatOption,
                                    ));
                            if (res != null)
                              setState(() {
                                repeatOption = res;
                              });
                          },
                          child: buildRepeatOptions())),
                  Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Text(
                        repeatDescription ?? 'Select repeat option',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: Style.foregroundColor.withOpacity(0.60),
                        ),
                      ))
                ],
              ));
        });
  }

  // Hàm cập nhật mô tả thông tin tùy chọn lặp lại.
  String updateRepeatDescription() {
    String frequency = repeatOption.frequency == 'daily'
        ? 'day'
        : repeatOption.frequency
            .substring(0, repeatOption.frequency.indexOf('ly'));
    String beginDateTime =
        DateFormat('dd/MM/yyyy').format(repeatOption.beginDateTime);
    String extraFeq = repeatOption.rangeAmount.toString();
    String type = repeatOption.type;
    String extra = repeatOption.type == 'until'
        ? DateFormat('dd/MM/yyyy').format(repeatOption.extraTypeInfo)
        : '${repeatOption.extraTypeInfo} time(s)';

    if (type == 'forever') {
      return 'Repeat every $extraFeq $frequency from $beginDateTime forever';
    }
    return 'Repeat every $extraFeq $frequency from $beginDateTime $type $extra';
  }

  Widget buildAmountInput({double amount}) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(Icons.attach_money,
                      color: Style.foregroundColor.withOpacity(0.70),
                      size: 40.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.60),
                      )),
                  SizedBox(height: 5.0),
                  (amount == null)
                      ? Text('Enter amount',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Style.foregroundColor.withOpacity(0.24),
                          ))
                      : MoneySymbolFormatter(
                          text: amount,
                          currencyId: selectedWallet.currencyID,
                          textStyle: TextStyle(
                            color: Style.foregroundColor,
                            fontFamily: Style.fontFamily,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                ],
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Style.foregroundColor.withOpacity(0.54),
          ),
        ],
      ),
    );
  }

  Widget buildCategorySelection({String iconPath, String display}) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: SuperIcon(
                    iconPath: iconPath ?? "assets/icons/other.svg",
                    size: 34.0,
                  )),
              Text(display ?? 'Select category',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: display == null
                        ? Style.foregroundColor.withOpacity(0.24)
                        : Style.foregroundColor,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Style.foregroundColor.withOpacity(0.54),
          ),
        ],
      ),
    );
  }

  Widget buildNoteInput({String display}) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Icon(Icons.notes,
                      color: Style.foregroundColor.withOpacity(0.70),
                      size: 24.0)),
              Text(display ?? 'Note',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: display == null
                        ? Style.foregroundColor.withOpacity(0.24)
                        : Style.foregroundColor,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Style.foregroundColor.withOpacity(0.54),
          ),
        ],
      ),
    );
  }

  Widget buildWalletSelection({String iconPath, String display}) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: SuperIcon(
                    iconPath: iconPath ?? "assets/icons/wallet_2.svg",
                    size: 24.0,
                  )),
              Text(display ?? 'Select wallet',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: display == null
                        ? Style.foregroundColor.withOpacity(0.24)
                        : Style.foregroundColor,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Style.foregroundColor.withOpacity(0.54),
          ),
        ],
      ),
    );
  }

  Widget buildRepeatOptions() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Icon(Icons.calendar_today,
                      color: Style.foregroundColor.withOpacity(0.70),
                      size: 24.0)),
              Text('Repeat Options',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Style.foregroundColor.withOpacity(0.54),
          ),
        ],
      ),
    );
  }

  // Hàm khởi tạo ngày đáo hạn hóa đơn.
  List<DateTime> initDueDate() {
    // Danh sách lưu ngày đáo hạn.
    List<DateTime> dueDates = [];

    // Lấy thời gian hiện tại.
    var now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // Biến lưu tần số (Số ngày của một kỳ).
    int freq;

    // Lấy giá trị tần số dựa theo thông tin repeat option.
    switch (repeatOption.frequency) {
      case 'daily':
        freq = repeatOption.rangeAmount;
        break;
      case 'weekly':
        freq = 7 * repeatOption.rangeAmount;
        break;
      case 'monthly':
        int dayOfMonth = DateTime(now.year, now.month + 1, 0).day;
        freq = dayOfMonth * repeatOption.rangeAmount;
        break;
      case 'yearly':
        bool isLeap = DateTime(now.year, 3, 0).day == 29;
        int dayOfYear = isLeap ? 366 : 365;
        freq = dayOfYear * repeatOption.rangeAmount;
        break;
    }

    // Phần này để tính chu kỳ tiếp theo của ngày đáo hạn.
    var timeRange = now.difference(repeatOption.beginDateTime).inDays;
    if (repeatOption.beginDateTime.compareTo(now) >= 0) {
      if (!dueDates.contains(repeatOption.beginDateTime))
        dueDates.add(repeatOption.beginDateTime);
    } else {
      if (timeRange % freq == 0) {
        if (!dueDates.contains(now)) dueDates.add(now);
      } else {
        var realDue = now.add(Duration(days: freq - (timeRange % freq)));
        if (!dueDates.contains(realDue)) dueDates.add(realDue);
      }
    }

    // Trả về danh sách ngày đáo hạn.
    return dueDates;
  }

  // Hàm hiển thị thông báo.
  Future<void> showAlertDialog(String content) async {
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
