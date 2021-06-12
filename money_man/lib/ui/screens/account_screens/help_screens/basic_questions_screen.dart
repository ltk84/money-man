import 'package:flutter/material.dart';
import 'package:money_man/core/models/basic%20questions.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/answer_questions_screen.dart';

class BasicQuestionsScreens extends StatelessWidget {
  const BasicQuestionsScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BasicQuestions mQuestion = new BasicQuestions();
    int num = mQuestion.answers.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff333333),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: Color(0xff1a1a1a),
        child: ListView.builder(
          itemCount: num,
          itemBuilder: (context, i) {
            return mQandA(
              index: i,
            );
          },
        ),
      ),
    );
  }
}

class mQandA extends StatelessWidget {
  const mQandA({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    BasicQuestions mQuestion = new BasicQuestions();
    return GestureDetector(
      onTap: () {
        print("tappsdfgnpp");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnswerTheQuestions(
                      index: index,
                    )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Text(
              '${mQuestion.questions[index]}',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
