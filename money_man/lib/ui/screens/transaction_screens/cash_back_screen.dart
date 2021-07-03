import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/shared_screens/note_srcreen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class CashBackScreen extends StatefulWidget {
  final MyTransaction transaction;
  final Wallet wallet;
  const CashBackScreen({
    Key key,
    @required this.transaction,
    @required this.wallet,
  }) : super(key: key);

  @override
  _CashBackScreenState createState() => _CashBackScreenState();
}

class _CashBackScreenState extends State<CashBackScreen> {
  // biến transaction repayment/debt collection
  MyTransaction extraTransaction;
  // biến thời gian của transaction
  DateTime pickDate;
  // biến số tiền của transaction
  double amount;
  // biến thể loại của transaction
  MyCategory cate;
  // biến wallet mà transaction sẽ được add vào
  Wallet selectedWallet;
  // biến ghi chú của transaction
  String note;
  // biến ký hiệu đơn vi tiền tệ của transaction
  String currencySymbol;
  // biến contact của transaction
  String contact;
  // biến hint text khi user chưa pick contact
  String hintTextConact;
  // biến xác định extraTransaction là debt hay loan
  bool isDebt;

  @override
  void initState() {
    super.initState();
    extraTransaction = widget.transaction;
    amount = extraTransaction.extraAmountInfo;
    contact = extraTransaction.contact;
    isDebt = extraTransaction.category.name == 'Debt';
    note = isDebt ? 'Debt paid to ' : 'Payment received from ';
    contact == null ? note += 'someone' : note += contact;
    pickDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    selectedWallet = widget.wallet;
    currencySymbol =
        CurrencyService().findByCode(selectedWallet.currencyID).symbol;
    hintTextConact = 'With';
  }

  @override
  Widget build(BuildContext context) {
    // biến thao tác với cơ sở dữ liệu
    final firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);

    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor,
        title: Text('Cash back',
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
              onPressed: () async {
                // trường hợp các thông tin cần thiết của transaction chưa được pick
                if (selectedWallet == null) {
                  showAlertDialog('Please pick your wallet!');
                } else if (amount == null) {
                  showAlertDialog('Please enter amount!');
                } else {
                  // trường hợp extraTransaction là debt
                  if (isDebt) {
                    // pick category là Repayment
                    cate =
                        await firestore.getCategoryByID('gi4CfNNlUoPSQlluCvS1');
                  }
                  // trường hợp extraTransaction là loan
                  else {
                    // pick category là Debt collection
                    cate =
                        await firestore.getCategoryByID('ZPltfjSWha3HvmIX5fgr');
                  }

                  MyTransaction trans = MyTransaction(
                    id: 'id',
                    amount: amount,
                    note: note,
                    date: pickDate,
                    currencyID: selectedWallet.currencyID,
                    category: cate,
                    contact: contact,
                  );

                  if (extraTransaction != null) {
                    // trường hợp số tiền của transaction sắp add lớn hơn extraTransaction
                    if (trans.amount > extraTransaction.extraAmountInfo) {
                      await showAlertDialog(
                          'Inputted amount must be <= unpaid amount. Unpaid amount is ${extraTransaction.extraAmountInfo}');
                      return;
                    }

                    MyTransaction newTrans =
                        await firestore.addTransaction(selectedWallet, trans);

                    // update các thông tin cần thiết của extraTransaction sau khi add transactoion
                    await firestore.updateDebtLoanTransationAfterAdd(
                        extraTransaction, newTrans, selectedWallet);
                  }

                  Navigator.pop(context);
                }
              },
              child: Text('Done',
                  style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  )))
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
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
        child: ListView(shrinkWrap: true, children: [
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(10, 0, 20, 0),
            minVerticalPadding: 10.0,
            onTap: () async {
              final resultAmount = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => EnterAmountScreen()));
              if (resultAmount != null)
                setState(() {
                  amount = double.parse(resultAmount);
                });
            },
            leading: Container(
              padding: EdgeInsets.only(top: 8, left: 4),
              child: SuperIcon(
                iconPath: 'assets/images/coin.svg',
                size: 32,
              ),
            ),
            title: TextFormField(
              readOnly: true,
              onTap: () async {
                final resultAmount = await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => EnterAmountScreen());
                if (resultAmount != null)
                  setState(() {
                    amount = double.parse(resultAmount);
                  });
              },
              // onChanged: (value) => amount = double.tryParse(value),
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontSize: 30.0,
                  fontFamily: Style.fontFamily,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintStyle: TextStyle(
                  color: amount == null
                      ? Style.foregroundColor.withOpacity(0.24)
                      : Style.foregroundColor,
                  fontSize: amount == null ? 22 : 30.0,
                  fontFamily: Style.fontFamily,
                  fontWeight:
                      amount == null ? FontWeight.w500 : FontWeight.w600,
                ),
                hintText: amount == null
                    ? 'Enter amount'
                    : MoneySymbolFormatter(
                            text: amount, currencyId: selectedWallet.currencyID)
                        .formatText,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
            child: Divider(
              color: Style.foregroundColor.withOpacity(0.24),
              height: 1,
              thickness: 0.2,
            ),
          ),
          ListTile(
            dense: true,
            leading: selectedWallet == null
                ? SuperIcon(iconPath: 'assets/icons/wallet_2.svg', size: 28.0)
                : SuperIcon(iconPath: selectedWallet.iconID, size: 28.0),
            title: TextFormField(
              readOnly: true,
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                    color: selectedWallet == null
                        ? Style.foregroundColor.withOpacity(0.24)
                        : Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: selectedWallet == null
                        ? FontWeight.w500
                        : FontWeight.w600,
                  ),
                  hintText: selectedWallet == null
                      ? 'Select wallet'
                      : selectedWallet.name),
            ),
            trailing: Icon(Icons.lock,
                color: Style.foregroundColor.withOpacity(0.54)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
            child: Divider(
              color: Style.foregroundColor.withOpacity(0.24),
              height: 1,
              thickness: 0.2,
            ),
          ),
          ListTile(
            dense: true,
            leading: SuperIcon(iconPath: 'assets/images/time.svg', size: 28),
            title: TextFormField(
              onTap: () async {
                DatePicker.showDatePicker(context,
                    currentTime: pickDate == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : pickDate,
                    showTitleActions: true, onConfirm: (date) {
                  if (date != null) {
                    setState(() {
                      pickDate = date;
                    });
                  }
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
              readOnly: true,
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                    color: pickDate == null
                        ? Style.foregroundColor.withOpacity(0.24)
                        : Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight:
                        pickDate == null ? FontWeight.w500 : FontWeight.w600,
                  ),
                  // xử lý hint text
                  // nếu thời gian được chọn là hôm nay thì hiện today
                  // ngày mai là tomorrow
                  // ngày hôm qua là yesterday
                  // còn các ngày khác thì theo form (thứ, ngày/tháng/năm)
                  hintText: pickDate ==
                          DateTime.parse(
                              DateFormat("yyyy-MM-dd").format(DateTime.now()))
                      ? 'Today'
                      : pickDate ==
                              DateTime.parse(DateFormat("yyyy-MM-dd").format(
                                  DateTime.now().add(Duration(days: 1))))
                          ? 'Tomorrow'
                          : pickDate ==
                                  DateTime.parse(DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now()
                                          .subtract(Duration(days: 1))))
                              ? 'Yesterday'
                              : DateFormat('EEEE, dd-MM-yyyy')
                                  .format(pickDate)),
            ),
            trailing: Icon(Icons.chevron_right,
                color: Style.foregroundColor.withOpacity(0.54)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
            child: Divider(
              color: Style.foregroundColor.withOpacity(0.24),
              height: 1,
              thickness: 0.2,
            ),
          ),
          ListTile(
            dense: true,
            leading: Container(
                padding: EdgeInsets.only(left: 4),
                child: SuperIcon(iconPath: 'assets/images/note.svg', size: 21)),
            title: TextFormField(
              onTap: () async {
                final noteContent = await showCupertinoModalBottomSheet(
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
              readOnly: true,
              autocorrect: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                      color: note == '' || note == null
                          ? Style.foregroundColor.withOpacity(0.24)
                          : Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: note == '' || note == null
                          ? FontWeight.w500
                          : FontWeight.w600),
                  hintText: note == '' || note == null ? 'Write note' : note),
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right,
                color: Style.foregroundColor.withOpacity(0.54)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
            child: Divider(
              color: Style.foregroundColor.withOpacity(0.24),
              height: 1,
              thickness: 0.2,
            ),
          ),
          ListTile(
            onTap: () async {
              try {
                final PhoneContact phoneContact =
                    await FlutterContactPicker.pickPhoneContact();
                if (phoneContact != null) {
                  setState(() {
                    contact = phoneContact.fullName;
                    // xử lý note khi pick contact
                    if (cate != null && note != null) {
                      if (cate.name == 'Debt Collection') {
                        note = note.replaceRange(
                            note.indexOf('from'), note.length, 'from $contact');
                      } else if (cate.name == 'Repayment') {
                        note = note.replaceRange(
                            note.indexOf('to'), note.length, 'to $contact');
                      }
                    }
                  });
                }
              } on UserCancelledPickingException catch (_) {
                print('cancel');
              }
            },
            dense: true,
            leading: Container(
              padding: EdgeInsets.only(left: 2),
              child: SuperIcon(
                iconPath: 'assets/images/account_screen/user2.svg',
                size: 25,
              ),
            ),
            title: TextFormField(
              onTap: () async {
                try {
                  final PhoneContact phoneContact =
                      await FlutterContactPicker.pickPhoneContact();
                  if (phoneContact != null) {
                    setState(() {
                      contact = phoneContact.fullName;
                      // xử lý note khi pick contact
                      if (note != null) {
                        if (isDebt == false) {
                          note = note.replaceRange(note.indexOf('from'),
                              note.length, 'from $contact');
                        } else {
                          note = note.replaceRange(
                              note.indexOf('to'), note.length, 'to $contact');
                        }
                      }
                    });
                  }
                } on UserCancelledPickingException catch (_) {
                  print('cancel');
                }
              },
              readOnly: true,
              autocorrect: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintStyle: TextStyle(
                      color: Style.foregroundColor.withOpacity(0.24),
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight:
                          contact == null ? FontWeight.w500 : FontWeight.w600),
                  hintText: contact ?? hintTextConact),
              style: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600),
            ),
            trailing: Icon(Icons.chevron_right,
                color: Style.foregroundColor.withOpacity(0.54)),
          ),
        ]),
      ),
    );
  }

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
