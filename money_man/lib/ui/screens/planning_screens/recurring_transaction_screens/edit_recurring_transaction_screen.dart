import 'dart:ui';

import 'package:date_util/date_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/recurring_transaction_model.dart';
import 'package:money_man/core/models/repeat_option_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_recurring_transaction_screen.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/planning_screens/recurring_transaction_screens/repeat_option_screen.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/shared_screens/note_srcreen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class EditRecurringTransactionScreen extends StatefulWidget {
  final RecurringTransaction recurringTransaction;
  final Wallet wallet;

  const EditRecurringTransactionScreen({
    Key key,
    @required this.recurringTransaction,
    @required this.wallet,
  }) : super(key: key);

  @override
  _EditRecurringTransactionScreenState createState() =>
      _EditRecurringTransactionScreenState();
}

class _EditRecurringTransactionScreenState
    extends State<EditRecurringTransactionScreen> {
  double amount;
  MyCategory category;
  String note;
  RepeatOption repeatOption;
  DateTime nextDate;
  String repeatDescription;

  var dateUtility = DateUtil();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount = widget.recurringTransaction.amount;
    category = widget.recurringTransaction.category;
    note = widget.recurringTransaction.note;
    repeatOption = widget.recurringTransaction.repeatOption;
    repeatDescription = updateRepeatDescription();
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    repeatDescription = updateRepeatDescription();

    return Scaffold(
        backgroundColor: Style.backgroundColor1,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Style.appBarColor,
          elevation: 0.0,
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
          title: Text('Edit Recurring transaction',
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
                RecurringTransaction _recurringTransaction =
                    RecurringTransaction(
                  id: widget.recurringTransaction.id,
                  category: category,
                  amount: amount,
                  walletId: widget.wallet.id,
                  note: note,
                  transactionIdList:
                      widget.recurringTransaction.transactionIdList,
                  repeatOption: repeatOption,
                  isFinished: false,
                );

                await _firestore.updateRecurringTransaction(
                    _recurringTransaction, widget.wallet);
                Navigator.pop(context, _recurringTransaction);
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
                      final resultAmount = await showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => EnterAmountScreen());
                      if (resultAmount != null)
                        setState(() {
                          print(resultAmount);
                          amount = double.parse(resultAmount);
                        });
                    },
                    child: buildAmountInput(amount: amount),
                  ),

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
                      final selectCate = await showCupertinoModalBottomSheet(
                          isDismissible: true,
                          backgroundColor: Style.boxBackgroundColor,
                          context: context,
                          builder: (context) =>
                              CategoriesRecurringTransactionScreen(
                                walletId: widget.wallet.id,
                              ));
                      if (selectCate != null) {
                        setState(() {
                          category = selectCate;
                        });
                        print('inside' + category.name);
                        print('outside' +
                            widget.recurringTransaction.category.name);
                      }
                    },
                    child: buildCategorySelection(
                      iconPath: category.iconID,
                      display: category.name,
                    ),
                  ),

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
                      child: buildNoteInput(display: note)),

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
                  buildWalletSelection(
                      iconPath: widget.wallet.iconID,
                      display: widget.wallet.name),
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
                          if (repeatOption.frequency == 'daily') {
                            nextDate = repeatOption.beginDateTime
                                .add(Duration(days: repeatOption.rangeAmount));
                          } else if (repeatOption.frequency == 'weekly') {
                            nextDate = repeatOption.beginDateTime.add(
                                Duration(days: 7 * repeatOption.rangeAmount));
                          } else if (repeatOption.frequency == 'monthly') {
                            DateTime beginDate = repeatOption.beginDateTime;
                            int days = dateUtility.daysInMonth(
                                    beginDate.month, beginDate.year) *
                                repeatOption.rangeAmount;
                            nextDate = beginDate.add(Duration(days: days));
                          } else {
                            DateTime beginDate = repeatOption.beginDateTime;
                            int days =
                                (dateUtility.leapYear(beginDate.year) == true
                                        ? 365
                                        : 366) *
                                    repeatOption.rangeAmount;
                            print(days);
                            nextDate = beginDate.add(Duration(days: days));
                          }
                          print(nextDate);
                        });
                    },
                    child: buildRepeatOptions())),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  repeatDescription,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor.withOpacity(0.6),
                  ),
                ))
          ],
        ));
  }

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
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(Icons.attach_money,
                      color: Style.foregroundColor.withOpacity(0.7),
                      size: 40.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Amount',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.6),
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
                          currencyId: widget.wallet.currencyID,
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
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
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
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Icon(Icons.notes,
                      color: Style.foregroundColor.withOpacity(0.7),
                      size: 24.0)),
              Text(display == null || display == '' ? 'Note' : display,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: display == null || display == ''
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
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
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
            Icons.lock,
            size: 20,
            color: Style.foregroundColor.withOpacity(0.54),
          ),
        ],
      ),
    );
  }

  Widget buildRepeatOptions() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Icon(Icons.calendar_today,
                      color: Style.foregroundColor.withOpacity(0.7),
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
}
