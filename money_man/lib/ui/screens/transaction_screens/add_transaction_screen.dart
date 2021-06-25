import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/selection_event.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/shared_screens/note_srcreen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class AddTransactionScreen extends StatefulWidget {
  Wallet currentWallet;
  AddTransactionScreen({
    Key key,
    @required this.currentWallet,
  }) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime pickDate;
  double amount;
  MyCategory cate;
  Wallet selectedWallet;
  String note;
  String currencySymbol;
  String contact;
  String hintTextConact;
  MyTransaction extraTransaction;
  bool pickEvent = false;
  Event event;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    selectedWallet = widget.currentWallet;
    currencySymbol =
        CurrencyService().findByCode(selectedWallet.currencyID).symbol;
    hintTextConact = 'With';
  }

  @override
  Widget build(BuildContext context) {
    print('add build');
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.appBarColor,
          title: Text('Add Transaction',
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
                if (selectedWallet == null) {
                  return;
                  //_showAlertDialog('Please pick your wallet!');
                } else if (amount == null) {
                  return;
                  //_showAlertDialog('Please enter amount!');
                } else if (cate == null) {
                  return;
                  //_showAlertDialog('Please pick category');
                } else {
                  MyTransaction trans = MyTransaction(
                      id: 'id',
                      amount: amount,
                      note: note,
                      date: pickDate,
                      currencyID: selectedWallet.currencyID,
                      category: cate,
                      contact: contact,
                      eventID: event == null ? '' : event.id);

                  if (extraTransaction != null) {
                    if (trans.amount > extraTransaction.extraAmountInfo) {
                      await _showAlertDialog(
                          'The amount must be less than or equal to unpaid amount.\nUnpaid amount is ' +
                              getMoneyFormat(extraTransaction.extraAmountInfo,
                                  selectedWallet.currencyID));
                      return;
                    }
                    MyTransaction newTransaction =
                        await _firestore.addTransaction(selectedWallet, trans);

                    _firestore.updateDebtLoanTransationAfterAdd(
                        extraTransaction, newTransaction, selectedWallet);
                  } else {
                    MyTransaction newTransaction =
                        await _firestore.addTransaction(selectedWallet, trans);
                  }

                  if (event != null) {
                    await _firestore.updateEventAmountAndTransList(
                        event, selectedWallet, trans);
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color:
                      (selectedWallet == null || amount == null || cate == null)
                          ? Style.foregroundColor.withOpacity(0.24)
                          : Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
                final resultAmount = await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => EnterAmountScreen());
                if (resultAmount != null)
                  setState(() {
                    print(resultAmount);
                    amount = double.parse(resultAmount);
                  });
              },
              leading: Container(
                padding: EdgeInsets.only(top: 5),
                child: SuperIcon(
                  iconPath: 'assets/images/coin.svg',
                  size: 40,
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
                      print(resultAmount);
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
                              text: amount,
                              currencyId: selectedWallet.currencyID)
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
              //minVerticalPadding: 8,
              onTap: () async {
                final selectCate = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) => CategoriesTransactionScreen(
                          wallet: selectedWallet,
                        ));
                if (selectCate != null) {
                  if (selectCate is List && selectCate.length == 2) {
                    MyCategory category = selectCate[0];
                    extraTransaction = selectCate[1];
                    bool isDebt = extraTransaction.category.name == 'Debt';

                    setState(() {
                      this.cate = category;
                      if (cate.type == 'debt & loan') {
                        if (cate.name == 'Debt') {
                          hintTextConact = 'Lender';
                        } else if (cate.name == 'Loan') {
                          hintTextConact = 'Borrower';
                        }
                      }
                      this.contact = extraTransaction.contact;

                      note =
                          isDebt ? 'Debt paid to ' : 'Payment received from ';

                      contact == null ? note += 'someone' : note += contact;
                    });
                  } else {
                    if (cate != null && selectCate.id == cate.id) return;
                    setState(() {
                      if (cate != null && cate.id != selectCate.id) {
                        note = null;
                        contact = null;
                      }
                      extraTransaction = null;
                      this.cate = selectCate;
                      if (cate.type == 'debt & loan') {
                        if (cate.name == 'Debt') {
                          hintTextConact = 'Lender';
                        } else if (cate.name == 'Loan') {
                          hintTextConact = 'Borrower';
                        }
                      }
                    });
                  }
                }
              },
              leading: cate == null
                  ? SuperIcon(
                      iconPath: 'assets/images/account_screen/category.svg',
                      size: 28)
                  : SuperIcon(
                      iconPath: cate.iconID,
                      size: 28.0,
                    ),
              title: TextField(
                autocorrect: false,
                onTap: () async {
                  final selectCate = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.boxBackgroundColor,
                      context: context,
                      builder: (context) => CategoriesTransactionScreen(
                            wallet: selectedWallet,
                          ));
                  if (selectCate != null) {
                    if (selectCate is List && selectCate.length == 2) {
                      MyCategory category = selectCate[0];
                      extraTransaction = selectCate[1];
                      bool isDebt = extraTransaction.category.name == 'Debt';

                      setState(() {
                        this.cate = category;
                        if (cate.type == 'debt & loan') {
                          if (cate.name == 'Debt') {
                            hintTextConact = 'Lender';
                          } else if (cate.name == 'Loan') {
                            hintTextConact = 'Borrower';
                          }
                        }
                        this.contact = extraTransaction.contact;

                        note =
                            isDebt ? 'Debt paid to ' : 'Payment received from ';
                        contact == null ? note += 'someone' : note += contact;
                      });
                    } else {
                      if (cate != null && selectCate.id == cate.id) return;
                      setState(() {
                        if (cate != null && cate.id != selectCate.id) {
                          note = null;
                          contact = null;
                        }
                        extraTransaction = null;
                        this.cate = selectCate;
                        if (cate.type == 'debt & loan') {
                          if (cate.name == 'Debt') {
                            hintTextConact = 'Lender';
                          } else if (cate.name == 'Loan') {
                            hintTextConact = 'Borrower';
                          }
                        }
                      });
                    }
                  }
                },
                readOnly: true,
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontSize: 16.0,
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: this.cate == null
                            ? Style.foregroundColor.withOpacity(0.24)
                            : Style.foregroundColor,
                        fontSize: 16.0,
                        fontFamily: Style.fontFamily,
                        fontWeight: this.cate == null
                            ? FontWeight.w500
                            : FontWeight.w600),
                    hintText:
                        this.cate == null ? 'Select category' : this.cate.name),
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
              onTap: () async {
                var res = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Style.boxBackgroundColor,
                    context: context,
                    builder: (context) =>
                        SelectWalletAccountScreen(wallet: selectedWallet));
                if (res != null && res.id != selectedWallet.id)
                  setState(() {
                    selectedWallet = res;
                    currencySymbol = CurrencyService()
                        .findByCode(selectedWallet.currencyID)
                        .symbol;
                    cate = null;
                    contact = null;
                    event = null;
                    note = null;
                  });
              },
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
                onTap: () async {
                  var res = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.boxBackgroundColor,
                      context: context,
                      builder: (context) =>
                          SelectWalletAccountScreen(wallet: selectedWallet));
                  if (res != null && res.id != selectedWallet.id)
                    setState(() {
                      selectedWallet = res;
                      currencySymbol = CurrencyService()
                          .findByCode(selectedWallet.currencyID)
                          .symbol;
                      cate = null;
                      contact = null;
                      event = null;
                      note = null;
                    });
                },
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
                        if (event != null) {
                          if (pickDate.year > event.endDate.year ||
                              (pickDate.year == event.endDate.year &&
                                  pickDate.month > event.endDate.month) ||
                              (pickDate.year == event.endDate.year &&
                                  pickDate.month == event.endDate.month &&
                                  pickDate.day > event.endDate.day))
                            event = null;
                        }
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
              leading: Icon(Icons.note, color: Colors.orange, size: 28.0),
              title: TextFormField(
                onTap: () async {
                  final noteContent = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.boxBackgroundColor,
                      context: context,
                      builder: (context) => NoteScreen(
                            content: note ?? '',
                          ));
                  print(noteContent);
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
            Visibility(
              visible: !pickEvent,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    pickEvent = true;
                  });
                },
                child: Text(
                  'More',
                  style: TextStyle(
                    color: Style.primaryColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: pickEvent,
              child: ListTile(
                onTap: () async {
                  try {
                    final PhoneContact phoneContact =
                        await FlutterContactPicker.pickPhoneContact();
                    if (phoneContact != null) {
                      print(phoneContact.fullName);
                      setState(() {
                        contact = phoneContact.fullName;
                        if (cate != null && note != null) {
                          if (cate.name == 'Debt Collection') {
                            note = note.replaceRange(note.indexOf('from'),
                                note.length, 'from $contact');
                          } else if (cate.name == 'Repayment') {
                            note = note.replaceRange(
                                note.indexOf('to'), note.length, 'to $contact');
                          }
                        }
                      });
                    }
                  } on UserCancelledPickingException catch (e) {
                    // TODO
                    print('cancel');
                  }
                },
                dense: true,
                leading: SuperIcon(
                  iconPath: 'assets/images/account_screen/user2.svg',
                  size: 28,
                ),
                title: TextFormField(
                  onTap: () async {
                    try {
                      final PhoneContact phoneContact =
                          await FlutterContactPicker.pickPhoneContact();
                      if (phoneContact != null) {
                        print(phoneContact.fullName);
                        setState(() {
                          contact = phoneContact.fullName;
                          if (cate != null && note != null) {
                            if (cate.name == 'Debt Collection') {
                              note = note.replaceRange(note.indexOf('from'),
                                  note.length, 'from $contact');
                            } else if (cate.name == 'Repayment') {
                              note = note.replaceRange(note.indexOf('to'),
                                  note.length, 'to $contact');
                            }
                          }
                        });
                      }
                    } on UserCancelledPickingException catch (e) {
                      // TODO
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
                          fontWeight: contact == null
                              ? FontWeight.w500
                              : FontWeight.w600),
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
            ),
            Visibility(
              visible: pickEvent,
              child: Container(
                margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                child: Divider(
                  color: Style.foregroundColor.withOpacity(0.24),
                  height: 1,
                  thickness: 0.2,
                ),
              ),
            ),
            Visibility(
                visible: pickEvent,
                child: ListTile(
                  dense: true,
                  onTap: () async {
                    var res = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.boxBackgroundColor,
                        context: context,
                        builder: (context) => SelectEventScreen(
                              wallet: selectedWallet,
                              timeTransaction: pickDate,
                            ));
                    if (res != null)
                      setState(() {
                        event = res;
                      });
                  },
                  leading: event == null
                      ? SuperIcon(iconPath: 'assets/images/event.svg', size: 28)
                      : SuperIcon(iconPath: event.iconPath, size: 28.0),
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
                          color: event == null
                              ? Style.foregroundColor.withOpacity(0.24)
                              : Style.foregroundColor,
                          fontFamily: Style.fontFamily,
                          fontSize: 16.0,
                          fontWeight:
                              event == null ? FontWeight.w500 : FontWeight.w600,
                        ),
                        hintText: event == null ? 'Select event' : event.name),
                    onTap: () async {
                      var res = await showCupertinoModalBottomSheet(
                          isDismissible: true,
                          backgroundColor: Style.boxBackgroundColor,
                          context: context,
                          builder: (context) => SelectEventScreen(
                                wallet: selectedWallet,
                                timeTransaction: pickDate,
                              ));
                      if (res != null)
                        setState(() {
                          event = res;
                        });
                    },
                  ),
                  trailing: Icon(Icons.chevron_right,
                      color: Style.foregroundColor.withOpacity(0.54)),
                ))
          ]),
        ));
  }

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

  String getMoneyFormat(double amount, String currencyId, {String digit = ''}) {
    Currency currency = CurrencyService().findByCode(currencyId);
    String symbol = currency.symbol;
    bool onLeft = currency.symbolOnLeft;
    String _digit = digit;
    double _text = amount;
    if (digit == '' && amount < 0) {
      _digit = amount.toString().substring(0, 1);
      _text = double.parse(amount.toString().substring(1));
    }
    String finalText = onLeft
        ? '$_digit$symbol ' +
            MoneyFormatter(amount: _text).output.withoutFractionDigits
        : _digit +
            MoneyFormatter(amount: _text).output.withoutFractionDigits +
            ' $symbol';
    return finalText;
  }
}
