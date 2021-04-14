import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/authentication_screens/sign_in_screen.dart';
import 'package:money_man/ui/screens/authentication_screens/sign_up_screen.dart';

class AuthWidget extends StatefulWidget {
  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    bool showSignIn = true;
    void changeShow() {
      setState(() {
        showSignIn = !showSignIn;
      });
    }

    @override
    Widget build(BuildContext context) {
      if (showSignIn)
        return SignInScreen(
          changeShow: changeShow,
        );
      else
        return SignUpScreen(
          changeShow: changeShow,
        );
    }
  }
}
