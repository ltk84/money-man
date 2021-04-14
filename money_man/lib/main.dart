import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/authentication_screen/sign_in_screen.dart';

void main() {
  runApp(MoneyManApp());
}

class MoneyManApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInScreen(),
    );
  }
}
