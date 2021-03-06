import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/recurring_transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/recurring_transaction_screens/edit_recurring_transaction_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RecurringTransactionDetailScreen extends StatefulWidget {
  final RecurringTransaction recurringTransaction;
  final Wallet wallet;
  RecurringTransactionDetailScreen({
    Key key,
    @required this.recurringTransaction,
    @required this.wallet,
  }) : super(key: key);

  @override
  _RecurringTransactionDetailScreenState createState() =>
      _RecurringTransactionDetailScreenState();
}

class _RecurringTransactionDetailScreenState
    extends State<RecurringTransactionDetailScreen> {
  // Biến để lấy thông tin hóa đơn.
  RecurringTransaction recurringTransaction;
  @override
  void initState() {
    super.initState();
    // Gán giá trị cho biến lưu giao dịch lặp lại.
    recurringTransaction = widget.recurringTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Style.boxBackgroundColor.withOpacity(0.2),
          elevation: 0.0,
          leading: Hero(
            tag: 'billToDetail_backBtn',
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Style.foregroundColor,
                )),
          ),
          title: Hero(
            tag: 'billToDetail_title',
            child: Material(
              color: Colors.transparent,
              child: Text('Recurring transaction',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                  )),
            ),
          ),
          centerTitle: true,
          actions: [
            Hero(
              tag: 'billToDetail_actionBtn',
              child: TextButton(
                onPressed: () async {
                  final updatedReTrans = await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return EditRecurringTransactionScreen(
                          recurringTransaction: recurringTransaction,
                          wallet: widget.wallet,
                        );
                      });
                  if (updatedReTrans != null) {
                    setState(() {
                      recurringTransaction = updatedReTrans;
                    });
                  }
                },
                child: Text('Edit',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
                    )),
              ),
            ),
          ],
        ),
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                    color: Style.boxBackgroundColor2,
                    border: Border(
                        top: BorderSide(
                          color: Style.foregroundColor.withOpacity(0.12),
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: Style.foregroundColor.withOpacity(0.12),
                          width: 0.5,
                        ))),
                child: Column(
                  children: [
                    buildInfoCategory(
                      iconPath: recurringTransaction.category.iconID,
                      display: recurringTransaction.category.name,
                    ),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildInfoAmount(amount: recurringTransaction.amount),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildNote(display: recurringTransaction.note),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildInfoWallet(
                      iconPath: widget.wallet.iconID,
                      display: widget.wallet.name,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildInfoRepeat(
                        nextDate: DateFormat('dd/MM/yyyy').format(
                            recurringTransaction.repeatOption.beginDateTime),
                        type: recurringTransaction.repeatOption.type ==
                                'forever'
                            ? 'Forever'
                            : recurringTransaction.repeatOption.type == 'until'
                                ? recurringTransaction.repeatOption.type +
                                    ' ' +
                                    DateFormat('dd/MM/yyyy').format(
                                        recurringTransaction
                                            .repeatOption.extraTypeInfo)
                                : recurringTransaction.repeatOption.type +
                                    ' ' +
                                    recurringTransaction
                                        .repeatOption.extraTypeInfo
                                        .toString() +
                                    ' time'),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor2,
                  border: Border(
                      bottom: BorderSide(
                    color: Style.foregroundColor.withOpacity(0.12),
                    width: 0.5,
                  ))),
              child: TextButton(
                onPressed: () async {
                  var result =
                      await firestore.executeInstantRecurringTransaction(
                          recurringTransaction, widget.wallet);
                  if (result > 0) {
                    await showAlertDialog(
                        title: 'Congratulation!',
                        content: 'Execute success!',
                        iconPath: 'assets/images/success.svg');
                  } else {
                    await showAlertDialog(
                        content: 'Recurring transaction expired!');
                  }
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.green.withOpacity(0.4);
                      else
                        return Colors.green; // Use the component's default.
                    },
                  ),
                ),
                child: Text("Execute transaction",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor2,
                  border: Border(
                      bottom: BorderSide(
                    color: Style.foregroundColor.withOpacity(0.12),
                    width: 0.5,
                  ))),
              child: TextButton(
                onPressed: () async {
                  await firestore.deleteRecurringTransaction(
                      recurringTransaction, widget.wallet);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.redAccent.withOpacity(0.4);
                      else
                        return Colors.redAccent; // Use the component's default.
                    },
                  ),
                ),
                child: Text("Delete",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
              ),
            )
          ],
        ));
  }

  Widget buildInfoAmount({double amount}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
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
              MoneySymbolFormatter(
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
    );
  }

  Widget buildInfoCategory({String iconPath, String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
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
    );
  }

  Widget buildNote({String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: Icon(Icons.notes,
                  color: Style.foregroundColor.withOpacity(0.7), size: 24.0)),
          Flexible(
            child: Text(display == null || display == '' ? 'Note' : display,
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: display == null || display == ''
                      ? Style.foregroundColor.withOpacity(0.24)
                      : Style.foregroundColor,
                )),
          ),
        ],
      ),
    );
  }

  Widget buildInfoWallet({String iconPath, String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
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
    );
  }

  Widget buildInfoRepeat({String nextDate, String type}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: Icon(Icons.calendar_today,
                  color: Style.foregroundColor.withOpacity(0.7), size: 24.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Next occurrence: ',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )),
                TextSpan(
                    text: nextDate,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Style.primaryColor,
                    )),
              ])),
              Text(type,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Style.foregroundColor.withOpacity(0.7),
                  )),
            ],
          )
        ],
      ),
    );
  }

  // Hàm hiển thị thông báo.
  Future<void> showAlertDialog(
      {String title = 'Oops...',
      String content,
      String iconPath = 'assets/images/alert.svg'}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(
          iconPath: iconPath,
          content: content,
          title: title,
        );
      },
    );
  }
}
