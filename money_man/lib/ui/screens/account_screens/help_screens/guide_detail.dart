import 'package:flutter/material.dart';
import 'package:money_man/core/models/user_guide.dart';
import 'package:money_man/ui/style.dart';

class GuideDetailScreen extends StatelessWidget {
  const GuideDetailScreen({Key key, this.index}) : super(key: key);
  // Biến lưu trữ vị trí của câu hỏi hiện tại trong danh sách
  final int index;

  @override
  Widget build(BuildContext context) {
    //Biến lưu trữ danh sách các câu hỏi
    UserGuides mQuestion = new UserGuides();
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        title: Text(
          'Our Answer',
          style: TextStyle(
            color: Style.foregroundColor,
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
            // Câu hỏi được viết in đậm và đặt ở trên
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
            // Câu trả lời được đặt ở dưới
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
