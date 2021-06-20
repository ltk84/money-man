import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'package:provider/provider.dart';

class AddWalletScreen extends StatefulWidget {
  @override
  _AddWalletScreenState createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  static var _formKey = GlobalKey<FormState>();
  String currencyName = 'Viet Nam Dong';
  FocusNode focusNode = new FocusNode();

  Wallet wallet = Wallet(
      id: '0',
      name: 'newWallet',
      amount: 0,
      currencyID: 'VND',
      iconID: 'assets/icons/wallet_2.svg');

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Style.boxBackgroundColor,
        appBar: AppBar(
          leadingWidth: 70.0,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.boxBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Add Wallet',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,)),
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var res = await _firestore.addWallet(this.wallet);
                    await _firestore.updateSelectedWallet(res);
                    Navigator.of(context).pop(res);
                  }
                },
                child: Text('Done',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: (wallet.name == '' || wallet.name == null) ? Style.foregroundColor.withOpacity(0.24) : Style.foregroundColor,
                    )
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.transparent,
                )),
          ],
        ),
        body: Container(
            color: Style.backgroundColor1,
            child: Form(
              key: _formKey,
              child: buildInput(),
            )));
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

  String convertMoneyType(double k) {
    String result = k.toString();
    var ff = result.split('.');
    String temp1 = ff[0];
    String temp2 = temp1.split('').reversed.join();
    result = '';
    int i = 0;
    for (int j = 0; j < temp2.length; j++) {
      result += temp2[j];
      i++;
      if (i % 3 == 0 && j + 1 != temp2.length) result += ',';
    }
    result = ff.length == 1
        ? result.split('').reversed.join()
        : result.split('').reversed.join() + '.';
    for (i = 1; i < ff.length; i++) result += ff[i];
    print(result);
    return result;
  }

  Widget buildInput() {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Style.boxBackgroundColor,
              margin: EdgeInsets.symmetric(vertical: 35.0, horizontal: 0.0),
              child: Column(
                children: [
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.transparent, // Không thừa đâu, như vậy mới ấn vùng ngoài được.
                        padding: EdgeInsets.fromLTRB(24, 20, 10, 0),
                        child: GestureDetector(
                          onTap: () async {
                            // TODO: Chọn icon cho ví
                            var data = await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => IconPicker(),
                            );
                            if (data != null) {
                              setState(() {
                                wallet.iconID = data;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SuperIcon(
                                iconPath: wallet.iconID,
                                size: 45.0,
                              ),
                              Icon(Icons.arrow_drop_down, color: Style.foregroundColor.withOpacity(0.54)),
                            ],
                          ),
                        ),
                        onPressed: () async {
                          // TODO: Chọn icon cho ví
                          var data = await showCupertinoModalBottomSheet(
                            context: context,
                            builder: (context) => IconPicker(),
                          );
                          if (data != null) {
                            setState(() {
                              wallet.iconID = data;
                            });
                          }
                        },
                        iconSize: 70,
                        color: Color(0xff8f8f8f),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 50),
                          width: 250,
                          child: TextFormField(
                            focusNode: focusNode,
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              fontSize: 20,
                              color: Style.foregroundColor,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.errorColor, width: 1),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.foregroundColor.withOpacity(0.6), width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Style.foregroundColor.withOpacity(0.6), width: 3),
                              ),
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                  color: Style.foregroundColor.withOpacity(0.6), fontSize: 15),
                            ),
                            onChanged: (value) => wallet.name = value,
                            validator: (value) {
                              if (value == null || value.length == 0)
                                return 'Name is empty';
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Style.foregroundColor,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    onTap: () {
                      showCurrencyPicker(
                        theme: CurrencyPickerThemeData(
                          backgroundColor: Style.boxBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          flagSize: 26,
                          titleTextStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 17,
                              color: Style.foregroundColor,
                              fontWeight: FontWeight.w700),
                          subtitleTextStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 15,
                              color: Style.foregroundColor),
                          //backgroundColor: Style.boxBackgroundColor,
                        ),
                        onSelect: (value) {
                          wallet.currencyID = value.code;
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
                        size: 30.0, color: Style.foregroundColor.withOpacity(0.24)),
                    title: Text(currencyName,
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0)),
                    trailing: Icon(Icons.chevron_right,
                        size: 20.0, color: Style.foregroundColor),
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Style.foregroundColor,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 0, 20, 10),
                    onTap: () async {
                      focusNode.unfocus();
                      final resultAmount = await showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => EnterAmountScreen());
                      if (resultAmount != null)
                        setState(() {
                          print(resultAmount);
                          wallet.amount = double.parse(resultAmount);
                        });
                    },
                    dense: true,
                    leading: Icon(Icons.account_balance,
                        size: 30.0, color: Style.foregroundColor.withOpacity(0.24)),
                    title: wallet.amount == null
                        ? Text('Enter wallet amount')
                        : MoneySymbolFormatter(
                            text: wallet.amount,
                            currencyId: wallet.currencyID,
                            textStyle: TextStyle(
                                color: Style.foregroundColor,
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                          ),
                    trailing: Icon(Icons.chevron_right,
                        size: 20.0, color: Style.foregroundColor),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
