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
import 'package:money_man/ui/screens/transaction_screens/note_transaction_srcreen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:provider/provider.dart';


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
  Event event;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickDate = DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now()));
    selectedWallet = widget.currentWallet;
    currencySymbol =
        CurrencyService().findByCode(selectedWallet.currencyID).symbol;
    note = null;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    print('add build');
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        title: Text('Add Transaction',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15.0)),
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.transparent,
            )),
        actions: [
          TextButton(
              onPressed: () async {
                if (selectedWallet == null) {
                  _showAlertDialog('Please pick your wallet!');
                } else if (amount == null) {
                  _showAlertDialog('Please enter amount!');
                } else if (cate == null) {
                  _showAlertDialog('Please pick category');
                } else {
                  MyTransaction trans;
                  // if (pickDate == null) {
                  //   trans = MyTransaction(
                  //       id: 'id',
                  //       amount: amount,
                  //       note: note,
                  //       date: DateTime.parse(
                  //           DateFormat("yyyy-MM-dd").format(DateTime.now())),
                  //       currencyID: wallet.currencyID,
                  //       category: cate);
                  //   print(trans.date.toString() + "chua pick");
                  // } else {
                  trans = MyTransaction(
                      id: 'id',
                      amount: amount,
                      note: note,
                      date: pickDate,
                      currencyID: selectedWallet.currencyID,
                      category: cate,
                    eventID: (event != null) ? event.id : ""
                  );
                  // }
                  await _firestore.addTransaction(selectedWallet, trans);
                  if(event != null) {
                    event.transactionIdList.add(trans.id);
                    await _firestore.updateEventAmountAndTransList(
                        event, selectedWallet, trans);
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )),
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 35.0),
        decoration: BoxDecoration(
            color: Colors.grey[900],
            border: Border(
                top: BorderSide(
                  color: Colors.white12,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.white12,
                  width: 0.5,
                ))),
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              minVerticalPadding: 10.0,
              onTap: () async {
                final resultAmount = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                if (resultAmount != null)
                  setState(() {
                    print(resultAmount);
                    amount = double.parse(resultAmount);
                  });
              },
              leading: Icon(Icons.money, color: Colors.white54, size: 45.0),
              title: TextFormField(
                readOnly: true,
                onTap: () async {
                  final resultAmount = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                  if (resultAmount != null)
                    setState(() {
                      print(resultAmount);
                      amount = double.parse(resultAmount);
                    });
                },
                // onChanged: (value) => amount = double.tryParse(value),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: amount == null ? Colors.grey[600] : Colors.white,
                      fontSize: amount == null ? 22 : 30.0,
                      fontFamily: 'Montserrat',
                      fontWeight:
                          amount == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: amount == null
                        ? 'Enter amount'
                        : currencySymbol +
                            ' ' +
                            MoneyFormatter(amount: amount)
                                .output
                                .withoutFractionDigits),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Colors.white24,
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
                    builder: (context) => CategoriesTransactionScreen());
                if (selectCate != null) {
                  setState(() {
                    this.cate = selectCate;
                  });
                }
              },
              leading: cate == null
                  ? Icon(Icons.question_answer,
                      color: Colors.white54, size: 28.0)
                  : SuperIcon(
                      iconPath: cate.iconID,
                      size: 28.0,
                    ),
              title: TextField(
                autocorrect: false,
                onTap: () async {
                  final selectCate = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) => CategoriesTransactionScreen());
                  if (selectCate != null) {
                    setState(() {
                      this.cate = selectCate;
                    });
                  }
                },
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color:
                            this.cate == null ? Colors.grey[600] : Colors.white,
                        fontSize: 16.0,
                        fontFamily: 'Montserrat',
                        fontWeight: this.cate == null
                            ? FontWeight.w500
                            : FontWeight.w600),
                    hintText:
                        this.cate == null ? 'Select category' : this.cate.name),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.white54),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Colors.white24,
                height: 1,
                thickness: 0.2,
              ),
            ),
            ListTile(
              dense: true,
              leading:
                  Icon(Icons.calendar_today, color: Colors.white54, size: 28.0),
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
                        cancelStyle: TextStyle(color: Colors.white),
                        doneStyle: TextStyle(color: Colors.white),
                        itemStyle: TextStyle(color: Colors.white),
                        backgroundColor: Colors.grey[900],
                      ));
                },
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                      color: pickDate == null ? Colors.grey[600] : Colors.white,
                      fontFamily: 'Montserrat',
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
              trailing: Icon(Icons.chevron_right, color: Colors.white54),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Colors.white24,
                height: 1,
                thickness: 0.2,
              ),
            ),
            ListTile(
              dense: true,
              onTap: () async {
                var res = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) =>
                        SelectWalletAccountScreen(wallet: selectedWallet));
                if (res != null)
                  setState(() {
                    selectedWallet = res;
                    currencySymbol = CurrencyService()
                        .findByCode(selectedWallet.currencyID)
                        .symbol;
                  });
              },
              leading: selectedWallet == null
                  ? SuperIcon(iconPath: 'assets/icons/wallet_2.svg', size: 28.0)
                  : SuperIcon(iconPath: selectedWallet.iconID, size: 28.0),
              title: TextFormField(
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
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
                          ? Colors.grey[600]
                          : Colors.white,
                      fontFamily: 'Montserrat',
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
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) =>
                          SelectWalletAccountScreen(wallet: selectedWallet));
                  if (res != null)
                    setState(() {
                      selectedWallet = res;
                      currencySymbol = CurrencyService()
                          .findByCode(selectedWallet.currencyID)
                          .symbol;
                    });
                },
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.white54),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Colors.white24,
                height: 1,
                thickness: 0.2,
              ),
            ),
            ListTile(
              dense: true,
              leading: Icon(Icons.note, color: Colors.white54, size: 28.0),
              title: TextFormField(
                onTap: () async {
                  final noteContent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NoteTransactionScreen(
                                noteContent: note ?? '',
                              )));
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
                        color: Colors.grey[600],
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                    hintText: note == null ? 'Write note' : note),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.white54),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(
                color: Colors.white24,
                height: 1,
                thickness: 0.2,
              ),
            ),
            ListTile(
              dense: true,
              onTap: () async {
                var res = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) =>
                        SelectEventScreen(
                            wallet: selectedWallet)
                );
                if (res != null)
                  setState(() {
                    event = res;
                  });
              },
              leading: event == null
                  ? Icon(Icons.event , size:  28.0, color: Colors.white54,)
                  : SuperIcon(iconPath: event.iconPath, size: 28.0),
              title: TextFormField(
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
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
                          ? Colors.grey[600]
                          : Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: selectedWallet == null
                          ? FontWeight.w500
                          : FontWeight.w600,
                    ),
                    hintText: event == null
                        ? 'Select event'
                        : event.name),
                onTap: () async {
                  var res = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) =>
                          SelectEventScreen(
                              wallet: selectedWallet)
                  );
                  if (res != null)
                    setState(() {
                      event = res;
                    });
                },
              ),
              trailing: Icon(Icons.chevron_right, color: Colors.white54),
            ),
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
