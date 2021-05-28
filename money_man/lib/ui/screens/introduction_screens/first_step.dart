import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:money_man/core/models/walletModel.dart';
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
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
            stops: [0.15, 0.05, 0.05, 0.25],
            colors: [
              Color(0xFF2FB49C),
              Color(0xff2fb49a),
              Colors.grey[200],
              Colors.grey[200]
            ],
          )),
          alignment: Alignment.bottomCenter,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Container(
                    child: Text(
                      'Create your \nfirst wallet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.07,
                      ),
                    ),
                  )),
                  Container(
                    child: Text(
                      'This app can help you to save your money \nas much as possible!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontSize: size.height * 0.022,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: SuperIcon(
                      iconPath: wallet.iconID,
                      size: size.height * 0.18,
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
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Container(
                    padding: EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Wallet's name:",
                        style: TextStyle(
                            color: black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
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
                        decoration:
                        InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                style: BorderStyle.none
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        style: TextStyle(color: black)
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Wallet's amount:",
                        style: TextStyle(
                            color: black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.none
                                ),
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
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                                    color: Colors.black
                                ),
                                //backgroundColor: Colors.grey[900],
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
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                            width: 50,
                            //height: size.height * 0.033,
                            alignment: Alignment.center,
                            child: Text(
                              currencyName,
                              style: TextStyle(
                                  color: white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
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
                  SizedBox(
                    height: 50,
                  ),

                  // Currency(),
                  /* ListTile(
                    onTap: () {
                      showCurrencyPicker(
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
                        size: 30.0, color: Colors.white60),
                    title: Text(currencyName,
                        style: TextStyle(color: Colors.black, fontSize: 15.0)),
                    trailing: Icon(Icons.chevron_right,
                        size: 20.0, color: Colors.white24),
                  ),*/

                  Column(
                    children: [
                      ButtonTheme(
                        minWidth: 250.0,
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate())
                              Navigator.of(context).push(_createRoute());
                          },
                          color: Color(0xff2FB49C),
                          elevation: 0.0,
                          child: Text(
                            'Continue',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2),
                                shape: BoxShape.circle,
                                color: Colors.black),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2),
                                shape: BoxShape.circle,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ],
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

// class Currency extends StatefulWidget {
//   @override
//   _CurrencyState createState() => _CurrencyState();
// }

// class _CurrencyState extends State<Currency> {
//   String dropdownValue = 'VND';
//   List listItem = ['VND', 'USD', 'WON', 'BITCOIN'];
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black54),
//         borderRadius: BorderRadius.all(Radius.circular(4)),
//       ),
//       width: 250.0,
//       height: size.height * 0.05,
//       child: Row(
//         children: [
//           //SizedBox(width: 20.0),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//             child: Container(
//               child: Icon(
//                 Icons.check,
//                 size: size.height * 0.04,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           VerticalDivider(
//             thickness: 2.0,
//             color: Colors.black54,
//           ),
//           SizedBox(width: 40.0),
//           Container(
//             width: 120.0,
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton(
//                 hint: Text(
//                   'Currency',
//                   style: TextStyle(
//                     fontFamily: 'NarumGothic',
//                   ),
//                 ),
//                 value: dropdownValue,
//                 onChanged: (newValue) {
//                   setState(() {
//                     dropdownValue = newValue;
//                   });
//                 },
//                 items: listItem.map((dropdownValue) {
//                   return DropdownMenuItem(
//                     value: dropdownValue,
//                     child: Text(
//                       dropdownValue,
//                       style: TextStyle(
//                         fontFamily: 'NarumGothic',
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
