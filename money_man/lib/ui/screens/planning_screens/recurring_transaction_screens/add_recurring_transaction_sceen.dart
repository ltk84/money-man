import 'dart:ui';

import 'package:date_util/date_util.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:provider/provider.dart';

class AddRecurringTransactionScreen extends StatefulWidget {
  final Wallet wallet;
  AddRecurringTransactionScreen({
    Key key,
    @required this.wallet,
  }) : super(key: key);

  @override
  _AddRecurringTransactionScreenState createState() =>
      _AddRecurringTransactionScreenState();
}

class _AddRecurringTransactionScreenState
    extends State<AddRecurringTransactionScreen> {
  double amount;
  MyCategory category;
  String note;
  Wallet _wallet;
  RepeatOption repeatOption;

  var dateUtility;
  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _wallet = widget.wallet;
    repeatOption = RepeatOption(
        frequency: 'daily',
        rangeAmount: 1,
        extraAmountInfo: null,
        beginDateTime: now,
        type: 'forever',
        extraTypeInfo: null);
    dateUtility = new DateUtil();
    note = '';
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
          title: Text('Add recuring transaction',
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
                // chưa pick amount
                if (amount == null) {
                  _showAlertDialog('Please enter amount!');
                }
                // chưa pick category
                else if (category == null) {
                  _showAlertDialog('Please pick category!');
                } else {
                  var reTrans = RecurringTransaction(
                    id: 'id',
                    category: category,
                    amount: amount,
                    walletId: _wallet.id,
                    note: note,
                    transactionIdList: [],
                    repeatOption: repeatOption,
                    isFinished: false,
                  );
                  await _firestore.addRecurringTransaction(reTrans, _wallet);
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
                      final resultAmount = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EnterAmountScreen()));
                      if (resultAmount != null)
                        setState(() {
                          print(resultAmount);
                          this.amount = double.parse(resultAmount);
                        });
                    },
                    child: buildAmountInput(
                        display: this.amount == null
                            ? null
                            : this.amount.toString()),
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
                            // isDismissible: true,
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) =>
                                CategoriesRecurringTransactionScreen(
                                  walletId: widget.wallet.id,
                                ));
                        if (selectCate != null) {
                          setState(() {
                            this.category = selectCate;
                          });
                        }
                      },
                      child: buildCategorySelection(
                        display:
                            this.category == null ? null : this.category.name,
                        iconPath:
                            this.category == null ? null : this.category.iconID,
                      )),

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
                                builder: (_) => NoteScreen(
                                      content: note ?? '',
                                    )));

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
                            builder: (context) =>
                                SelectWalletAccountScreen(wallet: _wallet));
                        if (res != null)
                          setState(() {
                            _wallet = res;
                          });
                      },
                      child: buildWalletSelection(
                        display:
                            this._wallet == null ? null : this._wallet.name,
                        iconPath:
                            this._wallet == null ? null : this._wallet.iconID,
                      )),
                ])),

            // build repeat option
            GestureDetector(
              onTap: () async {
                var res = await showCupertinoModalBottomSheet(
                    enableDrag: false,
                    isDismissible: false,
                    backgroundColor: Colors.grey[900],
                    context: context,
                    builder: (context) => RepeatOptionScreen(
                          repeatOption: repeatOption,
                        ));
                if (res != null)
                  setState(() {
                    repeatOption = res;
                  });
              },
              child: Container(
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
                  child: buildRepeatOptions()),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text(
                  'Repeat ${repeatOption.frequency} from ${repeatOption.beginDateTime}',
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
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
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

  Widget buildRepeatOptionInput({String display}) {
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
                  child: Icon(Icons.calendar_today_outlined,
                      color: Colors.white70, size: 24.0)),
              Text(display ?? 'No repeat',
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

  // hiện thông báo
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
