import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class AdjustBalanceScreen extends StatefulWidget {
  Wallet wallet;
  AdjustBalanceScreen({
    Key key,
    @required this.wallet,
  }) : super(key: key);

  @override
  _AdjustBalanceScreenState createState() => _AdjustBalanceScreenState();
}

class _AdjustBalanceScreenState extends State<AdjustBalanceScreen> {
  double adjustAmount;

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    var iconData = widget.wallet.iconID;

    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 70,
        leading: CloseButton(),
        backgroundColor: Style.backgroundColor1,
        actions: [
          TextButton(
            onPressed: () async {
              if (adjustAmount != null)
                await _firestore.adjustBalance(widget.wallet, adjustAmount);
              Navigator.pop(context);
            },
            child: Text('Save',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Style.successColor,
                )),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
        color: Style.backgroundColor1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              'ADJUST BALANCE',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 20.0,
                color: Style.foregroundColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: ListTile(
                leading: SuperIcon(
                  iconPath: iconData,
                  size: 30.0,
                ),
                title: Text(
                  widget.wallet.name,
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Style.foregroundColor,
                  ),
                ),
                trailing: Tooltip(
                  showDuration: Duration(milliseconds: 500),
                  margin: EdgeInsets.fromLTRB(70, 0, 77, 0),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  verticalOffset: -72,
                  //preferBelow: false,
                  message: 'Please change your wallet outside to adjust another wallet balance.',
                  decoration: BoxDecoration(
                    color: Style.foregroundColor.withOpacity(0.92),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                  ),
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w500,
                    color: Style.backgroundColor1.withOpacity(0.87),
                    fontSize: 14.0,
                  ),
                  child: Icon(
                    Icons.lock,
                    color: Style.foregroundColor.withOpacity(0.54),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                //color: Color(0xff268b79),
                  color: Style.primaryColor.withOpacity(0.87),
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: ListTile(
                onTap: () async {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => EnterAmountScreen()))
                  //     .then((value) {
                  //   if (value != null)
                  //     setState(() {
                  //       adjustAmount = double.parse(value);
                  //     });
                  // });
                  final resultAmount = await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => EnterAmountScreen());
                  if (resultAmount != null)
                    setState(() {
                      adjustAmount = double.parse(resultAmount);
                    });
                },
                leading: Icon(
                  Icons.keyboard_rounded,
                  color: Style.foregroundColor,
                  size: 30,
                ),
                title: MoneySymbolFormatter(
                  text: adjustAmount ?? widget.wallet.amount,
                  currencyId: widget.wallet.currencyID,
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Style.foregroundColor,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Style.foregroundColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
