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

class EditBillScreen extends StatefulWidget {
  final Bill bill;
  final Wallet wallet;

  const EditBillScreen({
    Key key,
    @required this.bill,
    @required this.wallet,
  }) : super(key: key);

  @override
  _EditBillScreenState createState() => _EditBillScreenState();
}

class _EditBillScreenState extends State<EditBillScreen> {
  String currencySymbol;
  double amount;
  MyCategory category;
  String note;
  RepeatOption repeatOption;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount = widget.bill.amount;
    category = widget.bill.category;
    note = widget.bill.note;
    repeatOption = widget.bill.repeatOption;
    currencySymbol = CurrencyService().findByCode(widget.wallet.currencyID).symbol;
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
          title: Text('Edit Bill',
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
                Bill _bill =
                Bill(
                    id: widget.bill.id,
                    category: category,
                    amount: amount,
                    walletId: widget.wallet.id,
                    note: note,
                    transactionIdList: widget.bill.transactionIdList,
                    repeatOption: repeatOption,
                    isFinished: widget.bill.isFinished,
                    dueDates: widget.bill.dueDates);

                await _firestore.updateBill(
                    _bill, widget.wallet);
                Navigator.pop(context, _bill);
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
                            amount =
                                double.parse(resultAmount);
                          });
                      },
                      child: buildAmountInput(
                          display: amount == null ? null : (currencySymbol + ' ' + amount.toString())
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
                            category = selectCate;
                          });
                        }
                      },
                      child: buildCategorySelection(
                        display: category == null ? null : category.name,
                        iconPath: category == null ? null : category.iconID,
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
                        display: note == null ? null : note,
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

                  // Không cho phép sửa Wallet khi edit bill.
                  // Hàm build Wallet Selection.
                  buildWalletSelection(
                    display: widget.wallet == null ? null : widget.wallet.name,
                    iconPath: widget.wallet == null ? null : widget.wallet.iconID,
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
