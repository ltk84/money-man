import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/authentication_screens/sign_in_screen.dart';
import 'package:money_man/ui/screens/authentication_screens/sign_up_screen.dart';

class Authentication extends StatefulWidget {
  bool showSignIn;
  Authentication({
    Key key,
    @required this.showSignIn,
  }) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  void changeShow() {
    setState(() {
      widget.showSignIn = !widget.showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showSignIn)
      return SignInScreen(
        changeShow: changeShow,
      );
    else
      return SignUpScreen(
        changeShow: changeShow,
      );
  }
}
