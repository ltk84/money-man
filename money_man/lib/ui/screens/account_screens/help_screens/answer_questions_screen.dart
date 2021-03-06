import 'package:flutter/material.dart';
import 'package:money_man/core/models/basic_questions.dart';
import 'package:money_man/ui/style.dart';

class AnswerTheQuestions extends StatelessWidget {
  const AnswerTheQuestions({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    //Khởi tạo đối tượng lưu trữ câu hỏi và câu trả lời
    BasicQuestions mQuestion = new BasicQuestions();
    return Scaffold(
      backgroundColor: Style.appBarColor,
      appBar: AppBar(
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        centerTitle: true,
        title: Text(
          'Our Answer',
          style: TextStyle(
            color: Style.foregroundColor,
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor2,
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: ListView(
          children: [
            SizedBox(
              height: 15,
            ),
            //Câu hỏi được in đậm, xuất hiện ở trên
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '${mQuestion.questions[index]}',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
            ),
            //Câu trả lời được đặt ở dưới, chữ bình thường
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${mQuestion.answers[index]}',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
