import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class AddWalletScreen extends StatefulWidget {
  @override
  _AddWalletScreenState createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  // biến key cho việc validate khi nhập name cho wallet
  static var formKey = GlobalKey<FormState>();
  // biến mặc định cho currency của wallet
  String currencyName = 'Viet Nam Dong';
  // biến để low down bàn phím
  FocusNode focusNode = new FocusNode();
  // biến wallet với các giá trị mặc định
  Wallet wallet = Wallet(
      id: '0',
      name: '',
      amount: 0,
      currencyID: 'VND',
      iconID: 'assets/icons/wallet_2.svg');

  @override
  Widget build(BuildContext context) {
    // biến firestore để thao tác với database
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Scaffold(
        backgroundColor: Style.boxBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Style.appBarColor,
          title: Text('Add Wallet',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,
              )),
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // trường hợp wallet không có name
                if (wallet.name == '' || wallet.name == null) return;

                // trường hợp các trường đều validate
                if (formKey.currentState.validate()) {
                  // làm low down bàn phím
                  FocusScope.of(context).requestFocus(FocusNode());
                  // add wallet và trả về thông tin wallet mới
                  var res = await _firestore.addWallet(this.wallet);
                  // lấy thông tin wallet mới update lên database
                  await _firestore.updateSelectedWallet(res);
                  // back về screen trước
                  Navigator.of(context).pop(res);
                }
              },
              child: Text('Done',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: (wallet.name == '' || wallet.name == null)
                        ? Style.foregroundColor.withOpacity(0.24)
                        : Style.foregroundColor,
                  )),
            ),
          ],
        ),
        body: Container(
            color: Style.backgroundColor1,
            child: Form(
              key: formKey,
              child: buildInput(),
            )));
  }

  // build phần nhập các thông tin cho wallet
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        color: Colors
                            .transparent, // Không thừa đâu, như vậy mới ấn vùng ngoài được.
                        padding: EdgeInsets.fromLTRB(24, 10, 10, 0),
                        child: GestureDetector(
                          onTap: () async {
                            // chọn icon cho wallet
                            var data = await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => IconPicker(),
                            );
                            // nếu user có chọn icon thì setState cho giá trị iconID của wallet
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
                              Icon(Icons.arrow_drop_down,
                                  color:
                                      Style.foregroundColor.withOpacity(0.54)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(right: 50),
                          width: 250,
                          child: TextFormField(
                            maxLength: 20,
                            focusNode: focusNode,
                            autocorrect: false,
                            keyboardType: TextInputType.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              fontFamily: Style.fontFamily,
                              color: Style.foregroundColor,
                              decoration: TextDecoration.none,
                            ),
                            decoration: InputDecoration(
                              errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Style.errorColor, width: 1),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Style.foregroundColor.withOpacity(0.6),
                                    width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Style.foregroundColor.withOpacity(0.6),
                                    width: 3),
                              ),
                              counterStyle: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  color: Style.foregroundColor.withOpacity(0.54),
                                  fontSize: 12),
                              labelText: 'Name',
                              labelStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                  color: Style.foregroundColor.withOpacity(0.6),
                                  fontSize: 15),
                            ),
                            onChanged: (value) => wallet.name = value,
                            validator: (value) {
                              // nếu giá trị nhập vào trường name rỗng
                              if (value == null || value.length == 0)
                                return 'Name is empty';
                              // nếu giá trị có ký hiệu không hợp lệ
                              return (value != null && value.contains('@'))
                                  ? 'Do not use the @ char.'
                                  : null;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 0.05,
                    color: Style.foregroundColor,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.fromLTRB(30, 0, 20, 0),
                    onTap: () {
                      // chọn currency cho wallet
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
                        size: 30.0,
                        color: Style.foregroundColor.withOpacity(0.24)),
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
                      // low down bàn phím trong trường hợp bàn phím được mở
                      focusNode.unfocus();
                      // dẫn vào screen nhập số tiền
                      final resultAmount = await showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => EnterAmountScreen());
                      if (resultAmount != null)
                        setState(() {
                          wallet.amount = double.parse(resultAmount);
                        });
                    },
                    dense: true,
                    leading: Icon(Icons.account_balance,
                        size: 30.0,
                        color: Style.foregroundColor.withOpacity(0.24)),
                    title: wallet.amount == null
                        ? Text('Enter wallet amount')
                        : MoneySymbolFormatter(
                            checkOverflow: false,
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
