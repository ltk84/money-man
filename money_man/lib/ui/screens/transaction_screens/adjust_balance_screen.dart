import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/walletModel.dart';
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

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            child: Column(children: [
              ListTile(
                onTap: () {},
                leading: Icon(Icons.wallet_giftcard),
                title: Text(
                  widget.wallet.name,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Divider(
                color: Colors.black,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EnterAmountScreen())).then((value) {
                    if (value != null)
                      setState(() {
                        adjustAmount = double.parse(value);
                      });
                  });
                },
                title: Text(
                  'Enter current balance of this wallet',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: Text(
                    MoneyFormatter(amount: adjustAmount ?? widget.wallet.amount)
                        .output
                        .withoutFractionDigits,
                    style: TextStyle(color: Colors.black)),
              )
            ]),
          )
        ],
      ),
    );
  }
}
