import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/authentication_screens/sign_in_screen.dart';
import 'package:money_man/ui/screens/authentication_screens/sign_up_screen.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
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
