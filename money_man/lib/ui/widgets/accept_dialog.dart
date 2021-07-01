import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';

class CustomAcceptAlert extends StatefulWidget {
  final content;
  const CustomAcceptAlert({Key key, this.content = "Something was wrong!"})
      : super(key: key);

  @override
  _CustomAcceptAlertState createState() => _CustomAcceptAlertState();
}

class _CustomAcceptAlertState extends State<CustomAcceptAlert>
    with SingleTickerProviderStateMixin {
  AnimationController controller; //
  Animation<double> scaleAnimation; //

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
            margin: EdgeInsets.only(top: 20, left: 20, right: 20.0),
            height: 70,
            width: 315,
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Container(
                  child: Text(
                    '${widget.content}',
                    style: TextStyle(color: white, fontFamily: 'Montserrat'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          String result = 'no';
                          Navigator.pop(context, result);
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                              color: white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          //do something
                          String result = 'yes';
                          Navigator.pop(context, result);
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                              color: white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
