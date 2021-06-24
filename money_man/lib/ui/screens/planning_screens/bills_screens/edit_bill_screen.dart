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
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
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
  String repeatDescription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    amount = widget.bill.amount;
    category = widget.bill.category;
    note = widget.bill.note;
    repeatOption = widget.bill.repeatOption;
    currencySymbol = CurrencyService().findByCode(widget.wallet.currencyID).symbol;
    repeatDescription = updateRepeatDescription();
  }

  @override
  Widget build(BuildContext context) {
    repeatDescription = updateRepeatDescription();
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<Object>(
      stream: _firestore.billStream(widget.wallet.id),
      builder: (context, snapshot) {
        List<Bill> listBills = snapshot.data ?? [];
        return Scaffold(
            backgroundColor: Style.backgroundColor1,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Style.boxBackgroundColor2,
              elevation: 0.0,
              leading: CloseButton(
                color: Style.foregroundColor,
              ),
              title: Text('Edit Bill',
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
                    if (listBills.any((element) => element.category.name == category.name) && category.name != widget.bill.category.name) {
                      _showAlertDialog('This category has already been used,\nplease pick again!');
                    } else {
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
                        dueDates: widget.bill.dueDates,
                        paidDueDates: widget.bill.paidDueDates,
                      );

                      await _firestore.updateBill(
                          _bill, widget.wallet);
                      Navigator.pop(context, _bill);
                    }
                  },
                  child: Text('Save',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Style.successColor,
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
                                amount =
                                    double.parse(resultAmount);
                              });
                          },
                          child: buildAmountInput(amount: amount)
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
                                builder: (context) => CategoriesBillScreen());
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
                      // 'Repeat every ${repeatOption.rangeAmount} ${repeatOption.extraAmountInfo}'
                      //     '${repeatOption.rangeAmount == 1 ? '' : 's'} '
                      //     'from ${DateFormat('dd/MM/yyyy').format(repeatOption.beginDateTime)}',
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
    );
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
                      color: Style.foregroundColor.withOpacity(0.7), size: 40.0)),
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
                    color: display == null ? Style.foregroundColor.withOpacity(0.24) : Style.foregroundColor,
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
                  child: Icon(Icons.notes, color: Style.foregroundColor.withOpacity(0.7), size: 24.0)),
              Text(display == null || display == '' ? 'Note' : display,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: display == null || display == '' ? Style.foregroundColor.withOpacity(0.24) : Style.foregroundColor,
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
                    color: display == null ? Style.foregroundColor.withOpacity(0.24) : Style.foregroundColor,
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
                      color: Style.foregroundColor.withOpacity(0.7), size: 24.0)),
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
}
