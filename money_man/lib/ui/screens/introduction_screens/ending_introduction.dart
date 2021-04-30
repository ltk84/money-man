import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/core/services/slanding_clipper.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreenTwo extends StatelessWidget {
  final Wallet wallet;

  const OnboardingScreenTwo({Key key, @required this.wallet}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //it will helps to return the size of the screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        child: Container(
          color: yellow,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: SlandingClipper(),
                      child: Container(
                        height: size.height * 0.4,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    color: yellow,
                  )
                ],
              ),
              Positioned(
                top: size.height * 0.12,
                child: Container(
                  width: size.width,
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PURCHASE',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          letterSpacing: 5,
                          fontWeight: FontWeight.bold,
                          color: black,
                          fontSize: size.height * 0.05 * 4 / 3,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      Text(
                        'Lorem Ipsum is simply dummy \ntext of the printing and typesetting industry.',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: size.height * 0.028,
                          fontFamily: 'NarumGothic',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: size.height * 0.09),
                        child: Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.monetization_on_outlined,
                            size: size.height * 0.334,
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
                              minWidth: 300.0,
                              child: RaisedButton(
                                onPressed: () async {
                                  final _firestore =
                                      Provider.of<FirebaseFireStoreService>(
                                          context,
                                          listen: false);
                                  await _firestore.addFirstWallet(wallet);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()));
                                },
                                color: Colors.black54,
                                elevation: 0.0,
                                child: Text(
                                  'Add first transaction',
                                  style: TextStyle(
                                    fontFamily: 'NarumGothic',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
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
                                    color: yellow),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: appPadding / 4),
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    border: Border.all(color: black, width: 2),
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
/*           Positioned(
              bottom: 15,
              left: 0,
              right: 0,

            ),*/
            ],
          ),
        ),
      ),
    );
  }
}
