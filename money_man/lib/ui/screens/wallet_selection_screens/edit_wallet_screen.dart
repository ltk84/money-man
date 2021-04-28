import 'dart:convert';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/currency_selection_screen/currency_selection.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class EditWalletScreen extends StatefulWidget {
  final Wallet wallet;

  const EditWalletScreen({
    Key key,
    @required this.wallet,
  }) : super(key: key);

  @override
  _EditWalletScreenState createState() => _EditWalletScreenState();
}

class _EditWalletScreenState extends State<EditWalletScreen> {
  static final _formKey = GlobalKey<FormState>();
  String currencyName = 'Currency';

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    currencyName = CurrencyService().findByCode(widget.wallet.currencyID).name;

    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          leadingWidth: 70.0,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Edit Wallet',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0)),
          leading: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
              )),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    print('before set' + widget.wallet.id);
                    await _firestore.updateWallet(widget.wallet);
                    await _firestore.updateSelectedWallet(widget.wallet.id);
                    print('after set' + widget.wallet.id);

                    Navigator.pop(context, widget.wallet.id);
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
                )),
          ],
        ),
        body: Container(
            color: Colors.black26,
            child: Form(
              key: _formKey,
              child: buildInput(),
            )));
  }

  Widget buildInput() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey[900],
              margin: EdgeInsets.symmetric(vertical: 35.0, horizontal: 0.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.account_balance_wallet,
                          size: 35.0,
                        ),
                        onPressed: () {
                          // TODO: Chọn icon cho ví
                        },
                        iconSize: 70,
                        color: Color(0xff8f8f8f),
                      ),
                      Container(
                        width: 250,
                        child: TextFormField(
                          initialValue: widget.wallet.name,
                          keyboardType: TextInputType.name,
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                          decoration: InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 1),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white60, width: 3),
                              ),
                              // border: UnderlineInputBorder(
                              //   borderSide:
                              //       BorderSide(color: Colors.white60, width: 3),
                              // ),
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white60)),
                          onChanged: (value) => widget.wallet.name = value,
                          validator: (value) {
                            if (value == null || value.length == 0)
                              return 'Name is empty';
                            return (value != null && value.contains('@'))
                                ? 'Do not use the @ char.'
                                : null;
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Colors.white,
                  ),
                  ListTile(
                    onTap: () {
                      showCurrencyPicker(
                        onSelect: (value) {
                          widget.wallet.currencyID = value.code;
                          setState(() {
                            currencyName = value.name;
                          });
                        },
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                      );
                    },
                    dense: true,
                    leading: Icon(Icons.monetization_on,
                        size: 30.0, color: Colors.white60),
                    title: Text(currencyName,
                        style:
                            TextStyle(color: Colors.white24, fontSize: 15.0)),
                    trailing: Icon(Icons.chevron_right,
                        size: 20.0, color: Colors.white24),
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Colors.white,
                  ),
                  ListTile(
                    onTap: () {},
                    dense: true,
                    leading: Icon(Icons.account_balance,
                        size: 30.0, color: Colors.white60),
                    title: Text('Initial Balance',
                        style:
                            TextStyle(color: Colors.white60, fontSize: 12.0)),
                    subtitle: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 12.0),
                      padding: EdgeInsets.fromLTRB(0, 0, 30.0, 0.0),
                      height: 30,
                      child: TextFormField(
                        initialValue: widget.wallet.amount.toString(),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                        decoration: InputDecoration(
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white60, width: 1),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white60, width: 3),
                          ),
                          // border: UnderlineInputBorder(
                          //   borderSide:
                          //       BorderSide(color: Colors.white60, width: 3),
                          // ),
                        ),
                        onChanged: (value) {
                          var val = int.tryParse(value);
                          if (val == null) widget.wallet.amount = 0;
                          widget.wallet.amount = val;
                        },
                        validator: (value) {
                          return (value == null || int.tryParse(value) == null)
                              ? 'Do not use the @ char.'
                              : null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Xử lý sự kiện click ở đây.
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.grey[900],
                child: Text(
                  'Link to service',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
