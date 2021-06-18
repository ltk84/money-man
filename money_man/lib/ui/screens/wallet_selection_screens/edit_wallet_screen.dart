import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
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
  static var _formKey = GlobalKey<FormState>();
  String currencyName = 'Currency';
  String iconData = 'assets/icons/wallet_2.svg';
  double adjustAmount;
  FocusNode focusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    currencyName = CurrencyService().findByCode(widget.wallet.currencyID).name;
    iconData = widget.wallet.iconID;
    // iconData = Wallet.getIconDataByIconID(widget.wallet.iconID);

    return Scaffold(
        backgroundColor: Style.boxBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.boxBackgroundColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Edit Wallet',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,)),
          leading: CloseButton(),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (adjustAmount == null) {
                      await _firestore.updateWallet(widget.wallet);
                      await _firestore.updateSelectedWallet(widget.wallet.id);
                    } else
                      await _firestore.adjustBalance(
                          widget.wallet, adjustAmount);
                    Navigator.pop(context, widget.wallet.id);
                  }
                },
                child: Text('Save',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )
                ),
            ),
          ],
        ),
        body: Container(
            color: Style.backgroundColor1,
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
              color: Style.boxBackgroundColor,
              margin: EdgeInsets.symmetric(vertical: 35.0, horizontal: 0.0),
              child: Column(
                children: [
                  Row(
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
                              widget.wallet.iconID = data;
                              setState(() {
                                iconData = data;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SuperIcon(
                                iconPath: iconData,
                                size: 45.0,
                              ),
                              Icon(Icons.arrow_drop_down, color: Style.foregroundColor.withOpacity(0.54)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 50),
                          width: 250,
                          child: TextFormField(
                            focusNode: focusNode,
                            autocorrect: false,
                            initialValue: widget.wallet.name,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                                errorBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Style.errorColor, width: 1),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Style.foregroundColor.withOpacity(0.6), width: 1),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Style.foregroundColor.withOpacity(0.6), width: 3),
                                ),
                                // border: UnderlineInputBorder(
                                //   borderSide:
                                //       BorderSide(color: Style.foregroundColor.withOpacity(0.6), width: 3),
                                // ),
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                    color: Style.foregroundColor.withOpacity(0.6), fontSize: 15)),
                            onChanged: (value) => widget.wallet.name = value,
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
                  SizedBox(height: 20,),
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
                          adjustAmount = double.parse(resultAmount);
                          // widget.wallet.amount = double.parse(resultAmount);
                        });
                    },
                    dense: true,
                    leading: Icon(Icons.account_balance,
                        size: 30.0, color: Style.foregroundColor.withOpacity(0.24)),
                    title: adjustAmount != null
                        ? MoneySymbolFormatter(
                            text: adjustAmount,
                            currencyId: widget.wallet.currencyID,
                            textStyle: TextStyle(
                                color: Style.foregroundColor,
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                          )
                        : MoneySymbolFormatter(
                            text: widget.wallet.amount,
                            currencyId: widget.wallet.currencyID,
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
            Container(
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 40,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    // Xử lý sự kiện click ở đây.
                    final _firestore = Provider.of<FirebaseFireStoreService>(
                        context,
                        listen: false);
                    final res = await _firestore.deleteWallet(widget.wallet.id);
                    if (res is String && res == 'only 1 wallet') {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(res.toString())));
                      return;
                    }
                    Navigator.pop(context, res);
                  },
                  child: Text("DELETE THIS WALLET",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          wordSpacing: 2.0),
                      textAlign: TextAlign.center),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Colors.red[700]; // Use the component's default.
                      },
                    ),
                    foregroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.red[700];
                        return Colors
                            .white; // Use the component's default.
                      },
                    ),
                  ),
                )),
          ],
        ),
      ],
    );
  }

  String convertMoneyType(amount) {
    String result = amount.toString();
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
}
