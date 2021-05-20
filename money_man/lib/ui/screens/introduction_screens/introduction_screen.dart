import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/introduction_screens/access_screen.dart';
import '../../widgets/carousel_indicator.dart';

class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.white,
                  child: IntroductionSlide(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => AccessScreen()));
                      },
                      child: Text('GET STARTED'),
                      style: TextButton.styleFrom(backgroundColor: Colors.black),
                    ),
                ),
              )
            ],
          ),
        )
    );
  }
}
