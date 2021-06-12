import 'package:flutter/material.dart';
import 'package:money_man/core/models/user_guide.dart';

class GuideDetailScreen extends StatelessWidget {
  const GuideDetailScreen({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    UserGuides mQuestion = new UserGuides();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Our guide',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff333333),
      ),
      body: Container(
        color: Color(0xff1a1a1a),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: Text(
                '${mQuestion.questions[index]}',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${mQuestion.answers[index]}',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
