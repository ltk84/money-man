import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Constraints/constaints.dart';
import 'EndingIntroduction.dart';
import 'Constraints/SlandingClipper.dart';


class FirstStep extends StatefulWidget {
  @override
  _FirstStepState createState() => _FirstStepState();
}

class _FirstStepState extends State<FirstStep> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  width: size.width,
                  height: size.height * 0.6,
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/onboard1.png'),
                ),
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
                    Container(
                        child: Container(
                          child: Text(
                            'Create your \nfirst wallet',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              //fontFamily: 'Anton',
                              fontWeight: FontWeight.bold,
                              fontSize: 49.0,
                              letterSpacing: 3.0,
                            ),
                          ),
                        )
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: size.width*0.15,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            'This app can help you to save your money \nas much as possible!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.blueGrey[700],
                              fontFamily: 'NarumGothic',
                              fontSize: 15.0,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height*0.05,
                    ),
                    Container(
                      child: Icon(Icons.dashboard_sharp,
                        size: size.height*0.18,
                        color: Colors.black54,

                      ),
                    ),
                    TextButton(onPressed: () {},
                        child: Text(
                          'CHANGE ICON',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NarumGothic',
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.fromLTRB(size.width*0.15, 0, 0, 0),
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
                      width: 230.0,
                      height: 30.0,
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height*0.02,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(size.width*0.15, 0, 0, 0),
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
                    Currency(),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    ButtonTheme(
                      minWidth: 250.0,
                      child: RaisedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OnboardingScreenTwo(),
                            ),
                          );
                        },
                        color: Colors.black54,
                        elevation: 0.0,
                        child: Text('Continue',
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
                        color: white),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: appPadding / 4),
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        border: Border.all(color: black, width: 2),
                        shape: BoxShape.circle,
                        color: yellow),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Currency extends StatefulWidget {

  @override
  _CurrencyState createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  String dropdownValue = 'VND';
  List ListItem = ['VND', 'USD', 'WON', 'BITCOIN'];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      width: 230.0,
      height: 35.0,
      child: Row(
        children: [
          //SizedBox(width: 20.0),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
            child: Container(

              child: Icon(Icons.check,
                size: 30.0,
                color: Colors.black87,
              ),
            ),
          ),
          VerticalDivider(
            thickness: 2.0,
            color: Colors.black54,
          ),
          SizedBox(width: 40.0),
          Container(
            width: 120.0,
            child: DropdownButtonHideUnderline(
              child: DropdownButton(

                hint: Text('Currency',
                  style: TextStyle(
                    fontFamily: 'NarumGothic',
                  ),
                ),
                value: dropdownValue,
                onChanged: (newValue)
                {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: ListItem.map((dropdownValue) {
                  return DropdownMenuItem(
                    value: dropdownValue,
                    child: Text(
                      dropdownValue,
                      style: TextStyle(
                        fontFamily: 'NarumGothic',
                      ),
                    ),
                  );

                }).toList(),
              ),
            ),
          )
        ],
      ),


    );
  }
}
