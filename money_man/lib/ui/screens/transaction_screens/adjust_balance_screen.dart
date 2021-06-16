import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/style.dart';
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
  bool invalid = false;
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    var iconData = widget.wallet.iconID;
    // iconData = Wallet.getIconDataByIconID(widget.wallet.iconID);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: white),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Color(0xff444444),
        centerTitle: true,
        title: Text(
          'Adjust Balance',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                if (adjustAmount != null)
                  await _firestore.adjustBalance(widget.wallet, adjustAmount);
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        color: Color(0xff111111),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0xff333333),
                      borderRadius: BorderRadius.circular(17)),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Wallet name:',
                          style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ListTile(
                        leading: SuperIcon(
                          iconPath: iconData,
                          size: 40.0,
                        ),
                        title: Theme(
                          data: Theme.of(context).copyWith(
                            primaryColor: Colors.white,
                          ),
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(
                                color: white,
                                fontSize: 20,
                                fontFamily: 'Montserrat'),
                            autocorrect: false,
                            decoration: InputDecoration(
                                hintText: widget.wallet.name,
                                hintStyle: TextStyle(
                                    color: white,
                                    fontSize: 20,
                                    fontFamily: 'Montserrat'),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 25)),
                          ),
                        ),
                      ),
                      /*Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'This field can not empty',
                                style: TextStyle(color: Colors.red),
                              ))*/
                    ],
                  ),
                ),
                /*ListTile(
                      onTap: () {},
                      leading: Icon(Icons.wallet_giftcard),
                      title: Text(
                        widget.wallet.name,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),*/
                Divider(
                  color: Colors.black,
                ),
                ListTile(
                  title: Text(
                    'Enter current balance of this wallet',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: Color(0xff268b79),
                      borderRadius: BorderRadius.circular(17)),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Balance:',
                          style: TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => EnterAmountScreen()))
                              .then((value) {
                            if (value != null)
                              setState(() {
                                adjustAmount = double.parse(value);
                              });
                          });
                        },
                        leading: Icon(
                          Icons.keyboard_rounded,
                          color: white,
                          size: 30,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        title: Container(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                              MoneyFormatter(
                                      amount:
                                          adjustAmount ?? widget.wallet.amount)
                                  .output
                                  .withoutFractionDigits,
                              style: TextStyle(color: Colors.white)),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: white,
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          child: !invalid
                              ? Container()
                              : Text(
                                  'This field can not empty',
                                  style: TextStyle(color: Colors.red),
                                ))
                    ],
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
