import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Constraints/SlandingClipper.dart';
import 'Constraints/constaints.dart';

class OnboardingScreenTwo extends StatelessWidget {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PURCHASE',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                        color: black,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Text(
                      'Lorem Ipsum is simply dummy \ntext of the printing and typesetting industry.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'NarumGothic',

                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: size.height*0.09),
                      child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                                Icons.monetization_on_outlined,
                              size: 200,
                            ),
                        ),
                    ),
                    SizedBox(
                      height: size.height*0.120,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: 300.0,
                        child: RaisedButton(
                          onPressed: () {

                          },
                          color: Colors.black54,
                          elevation: 0.0,
                          child: Text('Add first transaction',
                            style: TextStyle(
                              fontFamily: 'NarumGothic',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),

                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: appPadding / 4),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        border: Border.all(color: black, width: 2),
                        shape: BoxShape.circle,
                        color: yellow),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: appPadding / 4),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        border: Border.all(color: black, width: 2),
                        shape: BoxShape.circle,
                        color: Colors.white),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}