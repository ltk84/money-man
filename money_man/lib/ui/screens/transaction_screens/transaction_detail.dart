import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/edit_transaction_screen.dart';
import 'package:provider/provider.dart';
import '../../style.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
  MyTransaction transaction;
  Wallet wallet;

  TransactionDetail(
      {Key key, @required this.transaction, @required this.wallet})
      : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Transactions', style: tsAppBar),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                final updatedTrans = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => EditTransactionScreen(
                            transaction: widget.transaction,
                            wallet: widget.wallet)));

                setState(() {
                  widget.transaction = updatedTrans;
                });
              },
              child: const Text('Edit', style: tsAppBar),
              style: TextButton.styleFrom(
                primary: textColor,
                backgroundColor: Colors.transparent,
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.black,
              width: 1.0,
            ))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.local_pizza, size: 70),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.transaction.category.name,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  widget.transaction.note == ''
                                      ? 'Note'
                                      : widget.transaction.note,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5)),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    widget.transaction.amount.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5))),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                      color: Colors.black,
                      thickness: 0.5,
                      indent: 15.0,
                      endIndent: 15.0,
                      height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1, child: Icon(Icons.calendar_today_rounded)),
                      Expanded(
                          flex: 3,
                          child: Text(
                              DateFormat('EEEE, dd-MM-yyyy')
                                  .format(widget.transaction.date),
                              style: tsRegular)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(IconData(int.parse(widget.wallet.iconID),
                              fontFamily: 'MaterialIcons'))),
                      Expanded(
                          flex: 3,
                          child: Text(widget.wallet.name, style: tsRegular)),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budget",
                      style: tsMain,
                    ),
                    Text(
                      "Lorem ipsum",
                      style: tsChild,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1, child: Icon(Icons.local_pizza, size: 35)),
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.transaction.category.name,
                                          style: tsMainUnEdited,
                                        ),
                                        Text(
                                          widget.transaction.amount.toString(),
                                          style: tsChildUnEdited,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '(Total)',
                                            style: tsMain,
                                          ),
                                          Text(
                                            'Left (amount)',
                                            style: tsChild,
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              LinearProgressIndicator(
                                value: 0.5,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.greenAccent),
                                backgroundColor: Colors.black26,
                                minHeight: 4,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 33,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ))),
              child: TextButton(
                onPressed: () {},
                child: Text('Share', style: tsButton),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(highlight)),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 33,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ))),
              child: TextButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(
                            'Delete this transaction?',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No')),
                            FlatButton(
                                onPressed: () async {
                                  await _firestore.deleteTransaction(
                                      widget.transaction.id, widget.wallet.id);
                                  Navigator.pop(context);
                                  // chưa có animation để back ra transaction screen
                                  Navigator.pop(context);
                                },
                                child: Text('Yes'))
                          ],
                        );
                      });
                },
                child: Text('Delete transaction', style: tsButton),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(warning)),
              )),
        ],
      ),
    );
  }
}
