import 'package:flutter/material.dart';
import 'package:money_man/ui/widgets/screens/login_screen.dart';

void main() {
  runApp(MoneyManApp());
}

class MoneyManApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}
