import 'package:flutter/material.dart';
import 'package:money_man/core/models/basic%20questions.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/basic_questions_screen.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/user_guide_screens.dart';

class HelpScreens extends StatelessWidget {
  const HelpScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Helps",
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        backgroundColor: Color(0xff333333),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: Color(0xff1a1a1a),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                print("tapppp");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BasicQuestionsScreens()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Row(children: [
                  Text(
                    'Basic questions',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: white,
                        fontWeight: FontWeight.w300,
                        fontSize: 17),
                  ),
                ]),
              ),
            ),
            GestureDetector(
              onTap: () {
                print("tapppp");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserGuideScreen()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Row(children: [
                  Text(
                    'User guide',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: white,
                        fontWeight: FontWeight.w300,
                        fontSize: 17),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
