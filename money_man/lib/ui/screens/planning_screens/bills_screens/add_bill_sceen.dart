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
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/repeat_option_screen.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/note_transaction_srcreen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddBillScreen extends StatefulWidget {
  Wallet currentWallet;

  AddBillScreen({Key key, @required this.currentWallet}) : super(key: key);

  @override
  _AddBillScreenState createState() => _AddBillScreenState();
}

class _AddBillScreenState extends State<AddBillScreen> {
  Wallet selectedWallet;

  String currencySymbol;
  double amount;
  MyCategory category;
  String note;
  RepeatOption repeatOption;
  List<DateTime> dueDates;

  DateTime now =
  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedWallet = widget.currentWallet;
    currencySymbol = CurrencyService().findByCode(selectedWallet.currencyID).symbol;
    repeatOption = RepeatOption(
        frequency: 'daily',
        rangeAmount: 1,
        extraAmountInfo: 'day',
        beginDateTime: now,
        type: 'forever',
        extraTypeInfo: null);
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Color(0xFF111111),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Color(0xFF1c1c1c),
          elevation: 0.0,
          leading: CloseButton(),
          title: Text('Add Bill',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () async {
                if (amount == null) {
                  _showAlertDialog('Please enter amount!');
                } else if (category == null) {
                  _showAlertDialog('Please pick category!');
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

                  await _firestore.addBill(bill, selectedWallet);
                  Navigator.pop(context);
                }
              },
              child: Text('Save',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4FCC5C),
                  )),
            ),
          ],
        ),
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
                margin: EdgeInsets.only(top: 30.0),
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
                child: Column(children: [
                  // Hàm build Amount Input.
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        final resultAmount = await Navigator.push(context,
                            MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                        if (resultAmount != null)
                          setState(() {
                            print(resultAmount);
                            this.amount = double.parse(resultAmount);
                          });
                      },
                      child: buildAmountInput(
                          display: this.amount == null ? null : (currencySymbol + ' ' + this.amount.toString())
                      )
                  ),

                  // Divider ngăn cách giữa các input field.
                  Container(
                    margin: EdgeInsets.only(left: 70),
                    child: Divider(
                      color: Colors.white12,
                      thickness: 1,
                    ),
                  ),

                  // Hàm build Category Selection.
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        final selectCate = await showCupertinoModalBottomSheet(
                            isDismissible: true,
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) => CategoriesTransactionScreen());
                        if (selectCate != null) {
                          setState(() {
                            this.category = selectCate;
                          });
                        }
                      },
                      child: buildCategorySelection(
                          display: this.category == null ? null : this.category.name,
                          iconPath: this.category == null ? null : this.category.iconID,
                      )
                  ),

                  // Divider ngăn cách giữa các input field.
                  Container(
                    margin: EdgeInsets.only(left: 70, top: 8),
                    child: Divider(
                      color: Colors.white12,
                      thickness: 1,
                    ),
                    height: 2,
                  ),

                  // Hàm build Note Input.
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        final noteContent = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => NoteTransactionScreen(
                                  content: note ?? '',
                                )));
                        print(noteContent);
                        if (noteContent != null) {
                          setState(() {
                            note = noteContent;
                          });
                        }
                      },
                      child: buildNoteInput(
                        display: this.note == null ? null : this.note,
                      )
                  ),

                  // Divider ngăn cách giữa các input field.
                  Container(
                    margin: EdgeInsets.only(left: 70),
                    child: Divider(
                      color: Colors.white12,
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
                          backgroundColor: Colors.grey[900],
                          context: context,
                          builder: (context) => SelectWalletAccountScreen(wallet: selectedWallet));
                      if (res != null)
                        setState(() {
                          selectedWallet = res;
                          currencySymbol = CurrencyService()
                              .findByCode(selectedWallet.currencyID)
                              .symbol;
                        });
                    },
                    child: buildWalletSelection(
                      display: this.selectedWallet == null ? null : this.selectedWallet.name,
                      iconPath: this.selectedWallet == null ? null : this.selectedWallet.iconID,
                    ),
                  ),
                ])),
            Container(
                margin: EdgeInsets.only(top: 30.0),
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
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      var res = await showCupertinoModalBottomSheet(
                          enableDrag: false,
                          isDismissible: false,
                          backgroundColor: Colors.grey[900],
                          context: context,
                          builder: (context) => RepeatOptionScreen(
                            repeatOption: repeatOption,
                          )
                      );
                      if (res != null)
                        setState(() {
                          repeatOption = res;
                        });
                    },
                    child: buildRepeatOptions()
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  'Repeat every ${repeatOption.rangeAmount} ${repeatOption.extraAmountInfo}'
                      '${repeatOption.rangeAmount == 1 ? '' : 's'} '
                      'from ${DateFormat('dd/MM/yyyy').format(repeatOption.beginDateTime)}',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white60,
                  ),
                ))
          ],
        ));
  }

  Widget buildAmountInput({String display}) {
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
                      color: Colors.white70, size: 40.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white60,
                      )),
                  SizedBox(height: 5.0),
                  Text(display ?? 'Enter amount',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: display == null ? Colors.white24 : Colors.white,
                      )),
                ],
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white54,
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
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                    color: display == null ? Colors.white24 : Colors.white,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white54,
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
                  child: Icon(Icons.notes, color: Colors.white70, size: 24.0)),
              Text(display ?? 'Note',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: display == null ? Colors.white24 : Colors.white,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white54,
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
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: display == null ? Colors.white24 : Colors.white,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white54,
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
                      color: Colors.white70, size: 24.0)),
              Text('Repeat Options',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ],
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  List<DateTime> initDueDate () {
    List<DateTime> dueDates = [];
    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    int freq;
    switch (repeatOption.frequency)
    {
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
        freq = dayOfYear  * repeatOption.rangeAmount;
        break;
    }

    var timeRange = now.difference(repeatOption.beginDateTime).inDays;
    if (repeatOption.beginDateTime.compareTo(now) >= 0) {
      if (!dueDates.contains(repeatOption.beginDateTime))
        dueDates.add(repeatOption.beginDateTime);
    } else {
      if (timeRange % freq == 0) {
        if (!dueDates.contains(now))
          dueDates.add(now);
      } else {
        var realDue = now.add(Duration(days: freq - (timeRange % freq)));
        if (!dueDates.contains(realDue))
          dueDates.add(realDue);
      }
    }
    return dueDates;
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
