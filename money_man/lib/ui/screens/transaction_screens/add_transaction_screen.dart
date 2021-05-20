import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/edit_transaction_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:provider/provider.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  DateTime pickDate;
  double amount;
  MyCategory cate;
  Wallet wallet;
  String note;

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
                fontSize: 15.0)
        ),
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
            )
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (wallet != null && cate != null && amount != null) {
                  MyTransaction trans;
                  if (pickDate == null) {
                    trans = MyTransaction(
                        id: 'id',
                        amount: amount,
                        note: note,
                        date: DateTime.parse(
                            DateFormat("yyyy-MM-dd").format(DateTime.now())),
                        currencyID: wallet.currencyID,
                        category: cate);
                    print(trans.date.toString() + "chua pick");
                  } else {
                    trans = MyTransaction(
                        id: 'id',
                        amount: amount,
                        note: note,
                        date: pickDate,
                        currencyID: wallet.currencyID,
                        category: cate);
                    print(trans.date.toString() + 'da pick');
                  }
                  await _firestore.addTransaction(wallet, trans);
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
              )
          ),
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
            )
          )
        ),
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
                    fontWeight: FontWeight.w600
                ),
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
                        fontWeight: amount == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: amount == null
                        ? 'Enter amount'
                        : MoneyFormatter(amount: amount)
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
                      builder: (context) => CategoriesTransactionScreen()
                  );
                  if (selectCate != null) {
                    setState(() {
                      this.cate = selectCate;
                    });
                  }
                },
                leading: cate == null
                    ? Icon(Icons.question_answer, color: Colors.white54, size: 28.0)
                    : Icon(Icons.ac_unit, color: Colors.white54, size: 28.0),
                title: TextField(
                  onTap: () async {
                    final selectCate = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.grey[900],
                        context: context,
                        builder: (context) => CategoriesTransactionScreen()
                    );
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
                      fontWeight: FontWeight.w600
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: this.cate == null ? Colors.grey[600] : Colors.white,
                          fontSize: 16.0,
                          fontFamily: 'Montserrat',
                          fontWeight: this.cate == null ? FontWeight.w500 : FontWeight.w600
                      ),
                      hintText:
                          this.cate == null ? 'Select category' : this.cate.name
                  ),
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
              leading: Icon(Icons.calendar_today, color: Colors.white54, size: 28.0),
              title: TextFormField(
                onTap: () async {
                  DatePicker.showDatePicker(context,
                      currentTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                      showTitleActions: true,
                      onConfirm: (date) {
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
                      )
                  );
                  // DateTime now = DateTime.now();
                  // pickDate = await showDatePicker(
                  //     context: context,
                  //     initialDate: now,
                  //     firstDate: DateTime(2000),
                  //     lastDate: DateTime(2030));

                  // if (pickDate != null) {
                  //   if (pickDate.day != now.day ||
                  //       pickDate.month != now.month ||
                  //       pickDate.year != now.year) {
                  //     setState(() {
                  //       pickDate = DateTime.tryParse(
                  //           DateFormat('yyyy-MM-dd').format(pickDate));
                  //     });
                  //   }
                  // }
                },
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600
                ),
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
                        fontWeight: pickDate == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: pickDate == null
                        ? 'Select date'
                        : DateFormat('EEEE, dd-MM-yyyy').format(pickDate)),
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
                // wallet = await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => SelectWalletAccountScreen(wallet: wallet)));
                wallet = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) => SelectWalletAccountScreen(wallet: wallet));
              },
              leading: Icon(wallet == null
                  ? Icons.account_balance_wallet_rounded
                  : IconData(int.tryParse(wallet.iconID),
                      fontFamily: 'MaterialIcons'),
              color: Colors.white54, size: 28.0),
              title: TextFormField(
                readOnly: true,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: TextStyle(
                        color: wallet == null ? Colors.grey[600] : Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        fontWeight: wallet == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: wallet == null ? 'Select wallet' : wallet.name),
                onTap: () async {
                  wallet = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) => SelectWalletAccountScreen(wallet: wallet));
                  setState(() {});
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
                        fontWeight: FontWeight.w500
                    ),
                    hintText: 'Write note'
                ),
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600
                ),
                onChanged: (value) => note = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
