import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/recurring_transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/recurring_transaction_screens/edit_recurring_transaction_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
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
  RecurringTransaction _recurringTransaction;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recurringTransaction = widget.recurringTransaction;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.grey[900].withOpacity(0.2),
          elevation: 0.0,
          leading: Hero(
            tag: 'billToDetail_backBtn',
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
          ),
          title: Hero(
            tag: 'billToDetail_title',
            child: Text('Recurring transaction',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )),
          ),
          centerTitle: true,
          flexibleSpace: ClipRect(
            child: AnimatedOpacity(
              opacity: 1,
              duration: Duration(milliseconds: 0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 500, sigmaY: 500, tileMode: TileMode.values[0]),
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 1),
                    //child: Container(
                    //color: Colors.transparent,
                    color: Colors.transparent
                    //),
                    ),
              ),
            ),
          ),
          actions: [
            Hero(
              tag: 'billToDetail_actionBtn',
              child: TextButton(
                onPressed: () async {
                  final updatedReTrans = await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return EditRecurringTransactionScreen(
                          recurringTransaction: _recurringTransaction,
                          wallet: widget.wallet,
                        );
                      });
                  if (updatedReTrans != null) {
                    setState(() {
                      _recurringTransaction = updatedReTrans;
                    });
                  }
                },
                child: Text('Edit',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
                    color: Color(0xFF1c1c1c),
                    border: Border(
                        top: BorderSide(
                          color: Colors.white12,
                          width: 0.5,
                        ),
                        bottom: BorderSide(
                          color: Colors.white12,
                          width: 0.5,
                        ))),
                child: Column(
                  children: [
                    buildInfoCategory(
                      iconPath: _recurringTransaction.category.iconID,
                      display: _recurringTransaction.category.name,
                    ),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Colors.white12,
                        thickness: 1,
                      ),
                    ),
                    buildInfoAmount(
                        display:
                            '\$ ' + _recurringTransaction.amount.toString()),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Colors.white12,
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
                        color: Colors.white12,
                        thickness: 1,
                      ),
                    ),
                    buildInfoRepeat(
                        nextDate: DateFormat('dd/MM/yyyy').format(
                            _recurringTransaction.repeatOption.beginDateTime),
                        type: _recurringTransaction.repeatOption.type ==
                                'forever'
                            ? 'Forever'
                            : _recurringTransaction.repeatOption.type == 'until'
                                ? _recurringTransaction.repeatOption.type +
                                    ' ' +
                                    DateFormat('dd/MM/yyyy').format(
                                        _recurringTransaction
                                            .repeatOption.extraTypeInfo)
                                : _recurringTransaction.repeatOption.type +
                                    ' ' +
                                    _recurringTransaction
                                        .repeatOption.extraTypeInfo
                                        .toString() +
                                    ' time'

                        //         '1' +
                        //         ' ' +
                        //         _recurringTransaction.repeatOption
                        //             .extraTypeInfo.runtimeType
                        //             .toString() ==
                        //     'DateTime'
                        // ? DateFormat('dd/MM/yyyy').format(
                        //     _recurringTransaction
                        //         .repeatOption.extraTypeInfo)
                        // : _recurringTransaction
                        //         .repeatOption.extraTypeInfo
                        //         .toString() +
                        //     ' time'),
                        ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  color: Color(0xFF1c1c1c),
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.white12,
                    width: 0.5,
                  ))),
              child: TextButton(
                onPressed: () async {
                  var result =
                      await _firestore.executeInstantRecurringTransaction(
                          widget.recurringTransaction, widget.wallet);
                  if (result > 0) {
                    await _showAlertDialog(
                        title: 'Congratulation!', content: 'Execute success!');
                  } else {
                    await _showAlertDialog(
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
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  color: Color(0xFF1c1c1c),
                  border: Border(
                      bottom: BorderSide(
                    color: Colors.white12,
                    width: 0.5,
                  ))),
              child: TextButton(
                onPressed: () async {
                  await _firestore.deleteRecurringTransaction(
                      _recurringTransaction, widget.wallet);
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
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
              ),
            )
          ],
        ));
  }

  Widget buildInfoAmount({String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child:
                  Icon(Icons.attach_money, color: Colors.white70, size: 40.0)),
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
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: display == null ? Colors.white24 : Colors.white,
              )),
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
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: display == null ? Colors.white24 : Colors.white,
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
                  color: Colors.white70, size: 24.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Next occurence: $nextDate',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
              Text(type,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showAlertDialog(
      {String title = 'Oops...', String content}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(
          content: content,
          title: title,
        );
      },
    );
  }
}
