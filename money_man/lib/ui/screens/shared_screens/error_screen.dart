import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Style.backgroundColor,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                color: Style.foregroundColor.withOpacity(0.24),
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Error',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Style.foregroundColor,
                ),
              ),
              Text(
                'Something was wrong!',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Style.foregroundColor.withOpacity(0.54),
                ),
              ),
              Text(
                'Check your Internet connection.',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w400,
                  color: Style.foregroundColor.withOpacity(0.54),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          )),
    );
  }
}
