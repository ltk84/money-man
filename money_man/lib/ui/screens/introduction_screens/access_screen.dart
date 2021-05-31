import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/ui/screens/authentication_screens/authentication.dart';
import 'package:page_transition/page_transition.dart';

class AccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        leading: CloseButton(),
      ),
      body: Container(
        color: Colors.grey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SuperIcon(
                iconPath: 'assets/images/money_man.svg',
                size: 200.0,
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xFF2FB49C);
                        return Colors.white; // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Color(
                            0xFF2FB49C); // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: Authentication(showSignIn: false),
                          childCurrent: context.widget,
                          alignment: Alignment(0, 0.5),
                          type: PageTransitionType.scale,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                        ));
                    // showCupertinoModalBottomSheet(
                    //     context: context,
                    //     builder: (context) => Authentication(showSignIn: false)
                    //);
                  },
                  child: Text("NEW TO MONEY MAN",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          wordSpacing: 2.0),
                      textAlign: TextAlign.center),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                width: double.infinity,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Color(
                            0xFF2FB49C); // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xFF2FB49C);
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          child: Authentication(showSignIn: true),
                          childCurrent: context.widget,
                          alignment: Alignment(0, 0.5),
                          type: PageTransitionType.scale,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                        ));
                    // showCupertinoModalBottomSheet(
                    //     context: context,
                    //     builder: (context) => Authentication(showSignIn: true)
                    // );
                  },
                  child: Text("ALREADY USING MONEY MAN",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          wordSpacing: 2.0),
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
