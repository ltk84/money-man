import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';

class AddBudget extends StatefulWidget {
  @override
  _AddBudgetState createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  DateTime pickDate;

  double amount;

  MyCategory cate;

  Wallet selectedWallet;

  String note;

  String currencySymbol;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff111111),
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xff333333),
                borderRadius: BorderRadius.circular(17)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListTile(
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white70,
              ),
              dense: true,
              leading: SuperIcon(
                iconPath: 'assets/icons/box.svg',
                size: 35,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.white,
                ),
                child: TextFormField(
                  readOnly: true,
                  initialValue: 'Choose group',
                  obscureText: false,
                  cursorColor: Colors.white60,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Montserrat'),
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xff333333),
                borderRadius: BorderRadius.circular(17)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListTile(
              onTap: () async {
                final resultAmount = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                if (resultAmount != null)
                  setState(() {
                    print(resultAmount);
                    amount = double.parse(resultAmount);
                  });
              },
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white70,
              ),
              dense: true,
              leading: SuperIcon(
                iconPath: 'assets/images/coin.svg',
                size: 30,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Target:',
                        style:
                            TextStyle(color: white, fontFamily: 'Montserrat'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      onTap: () async {
                        final resultAmount = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EnterAmountScreen()));
                        if (resultAmount != null)
                          setState(() {
                            print(resultAmount);
                            amount = double.parse(resultAmount);
                          });
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                          hintText: amount == null
                              ? 'Enter amount' //: currencySymbol +
                              : MoneyFormatter(amount: amount)
                                  .output
                                  .withoutFractionDigits,
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xff333333),
                borderRadius: BorderRadius.circular(17)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListTile(
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white70,
              ),
              dense: true,
              leading: SuperIcon(
                iconPath: 'assets/images/time.svg',
                size: 30,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.white,
                ),
                child: TextFormField(
                  readOnly: true,
                  initialValue: 'Time range:',
                  obscureText: false,
                  cursorColor: Colors.white60,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Montserrat'),
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Color(0xff333333),
                borderRadius: BorderRadius.circular(17)),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListTile(
              trailing: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white70,
              ),
              dense: true,
              leading: SuperIcon(
                iconPath: 'assets/icons/wallet_2.svg',
                size: 30,
              ),
              title: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.white,
                ),
                child: TextFormField(
                  readOnly: true,
                  initialValue: 'Select wallet',
                  obscureText: false,
                  cursorColor: Colors.white60,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Montserrat'),
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10)),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              //TODO: Add new budget
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xFF2FB49C),
              ),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Text(
                'Add budget',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
