import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/transaction_detail.dart';
import 'package:money_man/ui/screens/wallet_selection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Transaction_Detail(),
    );
  }
}