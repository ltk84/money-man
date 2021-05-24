import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAlert extends StatefulWidget {
  const CustomAlert({Key key}) : super(key: key);

  @override
  _CustomAlertState createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
            margin: EdgeInsets.only(top: 20),
            height: 180,
            width: 315,
            decoration: BoxDecoration(
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/alert.svg',
                        height: 50.0,
                        width: 50.0,
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 15.0),
                      Text('Oops...',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5.0),
                      Text("End date can't be before begin date.",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  //SizedBox(height: 10.0),
                  Container(
                    //height: 150.0,
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Colors.white12,
                            )
                        )
                    ),
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                    ),
                  )
                ]
            )
        ),
      ),
    );
  }
}