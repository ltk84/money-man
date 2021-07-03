import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/basic_questions.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/answer_questions_screen.dart';
import 'package:money_man/ui/style.dart';

class BasicQuestionsScreens extends StatelessWidget {
  const BasicQuestionsScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Khởi tạo biến lưu trữ danh sách các câu hỏi và câu trả lời
    BasicQuestions mQuestion = new BasicQuestions();
    // Biến num lưu trữ số lượng các câu hỏi
    int num = mQuestion.answers.length;
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        leadingWidth: 250.0,
        leading: Hero(
          tag: 'alo',
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Style.backIcon, color: Style.foregroundColor),
                SizedBox(
                  width: 5,
                ),
                Text('Help',
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 17.0))
              ],
            ),
          ),
        ),
        title: Hero(
          tag: 'titleQuestion',
          child: Material(
            color: Colors.transparent,
            child: Text(
              'Basic Questions',
              style: TextStyle(
                color: Style.foregroundColor,
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: ClipRect(
          child: AnimatedOpacity(
            opacity: 1,
            duration: Duration(milliseconds: 0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 25, sigmaY: 25, tileMode: TileMode.values[0]),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                color: Colors.grey[800].withOpacity(0.2),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: Style.backgroundColor,
        child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: num,
          itemBuilder: (context, i) {
            return MyQuestion(
              index: i,
            );
          },
        ),
      ),
    );
  }
}

// Đối tượng hiển thị các câu hỏi
class MyQuestion extends StatelessWidget {
  const MyQuestion({Key key, this.index}) : super(key: key);
  // index là biến đặc trưng cho vị trí của câu hỏi hiện tại trong danh sách
  final int index;

  @override
  Widget build(BuildContext context) {
    BasicQuestions mQuestion = new BasicQuestions();
    return GestureDetector(
      // Ấn vào chuyển hướng đến màn hình trả lời câu hỏi
      onTap: () {
        print("tappsdfgnpp");
        showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => AnswerTheQuestions(
                  index: index,
                ));
      },
      child: Container(
        color: Colors
            .transparent, // để vậy mới không bị tình trạng padding ấn không được.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị câu hỏi
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '${mQuestion.questions[index]}',
                style: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17),
              ),
            ),
            // dòng phân cách giữa các câu
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
                thickness: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
