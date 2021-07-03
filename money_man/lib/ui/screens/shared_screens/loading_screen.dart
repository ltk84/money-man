import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/spinkit.dart';
// 
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Style.backgroundColor,
        child: Center(child: spinkit)
    );
  }
}
