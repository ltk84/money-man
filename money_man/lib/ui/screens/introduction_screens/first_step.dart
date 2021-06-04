import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/widgets/icon_picker.dart';
import 'ending_introduction.dart';

class FirstStep extends StatefulWidget {
  @override
  _FirstStepState createState() => _FirstStepState();
}

class _FirstStepState extends State<FirstStep> {
  Wallet wallet = Wallet(
      id: 'id',
      name: 'newWallet',
      amount: 0,
      currencyID: 'USD',
      iconID: 'assets/icons/wallet_2.svg');
  String currencyName = 'USD';
  //IconData iconData = Icons.account_balance_wallet;

  static final _formKey = GlobalKey<FormState>();

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          OnboardingScreenTwo(
        wallet: this.wallet,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            stops: [0.15, 0.05, 0.05, 0.25],
            colors: [
              Color(0xff2FB49C),
              Color(0xff2FB49C),
              Color(0xFF111111),
              Color(0xFF111111)
            ],
          )),
          //alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create your',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400,
                                fontSize: 40,
                              ),
                            ),
                            Text(
                              'FIRST\nWALLET',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                fontSize: 40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   padding: EdgeInsets.only(right: 8.0, top: 20.0),
                      //   child: IconButton(
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //     icon: Icon(
                      //       Icons.exit_to_app,
                      //       color: Colors.white24,
                      //       size: 30.0,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 60.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
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
                          child: Container(
                            child: SuperIcon(
                              iconPath: wallet.iconID,
                              size: size.height * 0.13,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () async {
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
                            child: Text(
                              'CHANGE ICON',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w800,
                              ),
                            )),
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Wallet's name:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: 250.0,
                          child: TextFormField(
                              validator: (value) {
                                if (value == null || value.length == 0)
                                  return 'Wallet name is empty';
                                return null;
                              },
                              onChanged: (value) => wallet.name = value,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 10.0),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(style: BorderStyle.none),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              style: TextStyle(color: black)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Wallet's amount:",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                width: 200.0,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    print(value);
                                    if (value == null || value.length == 0)
                                      return 'Wallet amount is empty';
                                    return null;
                                  },
                                  onChanged: (value) =>
                                      wallet.amount = double.tryParse(value),
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10.0),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(style: BorderStyle.none),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  style: TextStyle(color: black),
                                ),
                                // decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius: BorderRadius.circular(5)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showCurrencyPicker(
                                    theme: CurrencyPickerThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                      ),
                                      flagSize: 26,
                                      titleTextStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                      subtitleTextStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        color: Colors.grey[900],
                                      ),
                                      backgroundColor: Color(0xFF2FB49C),
                                    ),
                                    onSelect: (value) {
                                      wallet.currencyID = value.code;
                                      setState(() {
                                        currencyName = value.code;
                                      });
                                    },
                                    context: context,
                                    showFlag: true,
                                    showCurrencyName: true,
                                    showCurrencyCode: true,
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8.0),
                                  width: 50,
                                  //height: size.height * 0.033,
                                  alignment: Alignment.center,
                                  child: Text(
                                    currencyName,
                                    style: TextStyle(
                                        color: white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5),
                                    //border: Border.all(color: Colors.grey)
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Column(
                            children: [
                              ButtonTheme(
                                //height: 40.0,
                                minWidth: 230.0,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (_formKey.currentState.validate())
                                      Navigator.of(context)
                                          .push(_createRoute());
                                  },
                                  color: Color(0xff2FB49C),
                                  elevation: 0.0,
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.9)),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 2.0),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.4)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
