import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:provider/provider.dart';

class EditTransactionScreen extends StatefulWidget {
  MyTransaction transaction;
  Wallet wallet;
  EditTransactionScreen({
    Key key,
    @required this.wallet,
    @required this.transaction,
  }) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  DateTime pickDate;
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

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
                topRight: Radius.circular(20.0)
            )
        ),
        title: Text('Edit Transaction',
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
                FocusScope.of(context).requestFocus(FocusNode());
                await _firestore.updateTransaction(
                    widget.transaction, widget.wallet);
                Navigator.pop(context, widget.transaction);
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
          )
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
                    widget.transaction.amount = double.parse(resultAmount);
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
                      widget.transaction.amount = double.parse(resultAmount);
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
                      color: widget.transaction.amount == null ? Colors.grey[600] : Colors.white,
                      fontSize: widget.transaction.amount == null ? 22 : 30.0,
                      fontFamily: 'Montserrat',
                      fontWeight: widget.transaction.amount == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: widget.transaction.amount == null
                        ? 'Enter amount'
                        : MoneyFormatter(amount: widget.transaction.amount)
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
                onTap: () {},
                leading: Icon(Icons.ac_unit, color: Colors.white54, size: 28.0),
                title: TextField(
                  onTap: () {},
                  readOnly: true,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600
                  ),
                  decoration:
                      InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintStyle: TextStyle(
                              color: widget.transaction.category.name == null ? Colors.grey[600] : Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'Montserrat',
                              fontWeight: widget.transaction.category.name == null ? FontWeight.w500 : FontWeight.w600
                          ),
                          hintText: widget.transaction.category.name == null ? 'Select category' : widget.transaction.category.name
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
                            widget.transaction.date = pickDate;
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
                      color: widget.transaction.date == null ? Colors.grey[600] : Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: widget.transaction.date == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: widget.transaction.date == null
                        ? 'Select date'
                        : DateFormat('EEEE, dd-MM-yyyy').format(widget.transaction.date)),
                // onTap: () async {
                //   pickDate = await showDatePicker(
                //       context: context,
                //       initialDate: widget.transaction.date,
                //       firstDate: DateTime(2000),
                //       lastDate: DateTime(2030));
                //
                //   setState(() {
                //     widget.transaction.date = DateTime.tryParse(
                //         DateFormat('yyyy-MM-dd').format(pickDate));
                //   });
                // },
                // readOnly: true,
                // style: TextStyle(color: Colors.black),
                // decoration: InputDecoration(
                //     hintText: DateFormat('EEEE, dd-MM-yyyy')
                //         .format(widget.transaction.date)),
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
              onTap: () {},
              leading: Icon(IconData(int.tryParse(widget.wallet.iconID),
                  fontFamily: 'MaterialIcons'),
                  color: Colors.white54, size: 28.0),
              // leading: Icon(Icons.wallet_giftcard),
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
                      color: widget.wallet == null ? Colors.grey[600] : Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: widget.wallet == null ? FontWeight.w500 : FontWeight.w600,
                    ),
                    hintText: widget.wallet == null
                        ? 'Select wallet'
                        : widget.wallet.name),
                onTap: () {},
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
                onChanged: (value) => widget.transaction.note = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}