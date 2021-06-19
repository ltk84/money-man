import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_man/ui/style.dart';

class CustomAlert extends StatefulWidget {
  final iconPath;
  final title;
  final content;
  const CustomAlert(
      {
        Key key,
        this.iconPath = 'assets/images/alert.svg',
        this.title = 'Oops...',
        this.content = "Something was wrong!",
      }) : super(key: key);

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
        backgroundColor: Style.boxBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20.0),
            height: 190,
            width: 315,
            decoration: BoxDecoration(
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        widget.iconPath,
                        height: 50.0,
                        width: 50.0,
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: 15.0),
                      Text(widget.title,
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5.0),
                      Text(widget.content,
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Style.foregroundColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  //SizedBox(height: 10.0),
                  Container(
                    //height: 150.0,
                    margin: EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                              width: 1,
                              color: Style.foregroundColor.withOpacity(0.12),
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
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor,
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