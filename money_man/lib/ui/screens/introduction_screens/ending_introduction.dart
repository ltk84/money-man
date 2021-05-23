import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreenTwo extends StatelessWidget {
  final Wallet wallet;

  const OnboardingScreenTwo({Key key, this.wallet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: [0.6, 0.1],
          colors: [Colors.orange, Colors.white],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'PURCHASE',
                textAlign: TextAlign.start,
                style: TextStyle(
                  letterSpacing: 5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: size.height * 0.05 * 4 / 3,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Lorem Ipsum is simply dummy \ntext of the printing and typesetting industry.',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: size.height * 0.028,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: size.height * 0.09),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.money_outlined,
                  size: size.height * 0.334,
                  color: Colors.yellow,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.1085,
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: ButtonTheme(
                    minWidth: 250.0,
                    child: RaisedButton(
                      onPressed: () async {
                        final _firestore =
                            Provider.of<FirebaseFireStoreService>(context,
                                listen: false);
                        await _firestore.addFirstWallet(wallet);

                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => HomeScreen()));
                      },
                      color: Color(0xff007b10),
                      elevation: 0.0,
                      child: Text(
                        'Add first transaction',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
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
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                          color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          shape: BoxShape.circle,
                          color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
