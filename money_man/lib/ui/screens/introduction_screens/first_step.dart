import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/slanding_clipper.dart';
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
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image(
                  //   width: size.width,
                  //   height: size.height * 0.6,
                  //   fit: BoxFit.cover,
                  //   image: AssetImage('assets/images/apple.jpg'),
                  // ),
                  ClipPath(
                    clipper: SlandingClipper(),
                    child: Container(
                      height: size.height * 0.4,
                      color: yellow,
                    ),
                  )
                ],
              ),
              Positioned(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.15,
                      ),
                      Container(
                          child: Container(
                        child: Text(
                          'Create your \nfirst wallet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            //fontFamily: 'Anton',
                            fontWeight: FontWeight.bold,
                            fontSize: size.height * 0.07,
                            letterSpacing: 3.0,
                          ),
                        ),
                      )),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.15,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              'This app can help you to save your money \nas much as possible!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontFamily: 'NarumGothic',
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      Container(
                        child: SuperIcon(
                          iconPath: wallet.iconID,
                          size: size.height * 0.18,
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            // var data = await FlutterIconPicker.showIconPicker(
                            //   context,
                            //   iconPickerShape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(20)),
                            //   iconPackMode: IconPack.cupertino,
                            // );
                            // if (data != null) {
                            //   wallet.iconID = data.codePoint.toString();
                            //   setState(() {
                            //     iconData = data;
                            //   });
                            // }
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
                              fontFamily: 'NarumGothic',
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Wallet name:',
                            style: TextStyle(
                              fontFamily: 'NarumGothic',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: size.height * 0.05,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.length == 0)
                                return 'Wallet name is empty';
                              return null;
                            },
                            onChanged: (value) => wallet.name = value,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Container(
                        padding:
                            EdgeInsets.fromLTRB(size.width * 0.15, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Currency: ',
                            style: TextStyle(
                              fontFamily: 'NarumGothic',
                            ),
                          ),
                        ),
                      ),
                      // Currency(),
                      ListTile(
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
                            style:
                                TextStyle(color: Colors.black, fontSize: 15.0)),
                        trailing: Icon(Icons.chevron_right,
                            size: 20.0, color: Colors.white24),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Column(
                        children: [
                          ButtonTheme(
                            minWidth: 250.0,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.of(context).push(_createRoute());
                              },
                              color: Colors.black54,
                              elevation: 0.0,
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontFamily: 'NarumGothic',
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.05 / 1.5,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: appPadding / 4),
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    border: Border.all(color: black, width: 2),
                                    shape: BoxShape.circle,
                                    color: white),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: appPadding / 4),
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    border: Border.all(color: black, width: 2),
                                    shape: BoxShape.circle,
                                    color: yellow),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
