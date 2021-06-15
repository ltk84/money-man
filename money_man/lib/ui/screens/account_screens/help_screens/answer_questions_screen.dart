import 'package:flutter/material.dart';
import 'package:money_man/core/models/basic_questions.dart';

class AnswerTheQuestions extends StatelessWidget {
  const AnswerTheQuestions({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    BasicQuestions mQuestion = new BasicQuestions();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Our answer',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
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
