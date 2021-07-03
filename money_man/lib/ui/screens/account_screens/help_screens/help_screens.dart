import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/basic_questions_screen.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/send_question_screen.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/user_guide_screens.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';

class HelpScreens extends StatelessWidget {
  const HelpScreens({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      floatingActionButton: FloatingActionButton(
        // Chuyển hướng đến trang gửi tin nhắn góp ý đến nhà sản xuất :v
        onPressed: () {
          showCupertinoModalBottomSheet(
            isDismissible: false,
            enableDrag: false,
            context: context,
            builder: (context) => SendQuestionScreen(),
          );
        },
        child: Icon(Icons.message),
        elevation: 0,
        backgroundColor: Style.primaryColor,
      ),
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
                Text('More',
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 17.0))
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Help",
          style: TextStyle(
            color: Style.foregroundColor,
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            GestureDetector(
              //Chuyển hướng đến màn hình xem danh sách các câu hỏi
              onTap: () {
                print("tapppp");
                Navigator.push(
                    context,
                    PageTransition(
                        child: BasicQuestionsScreens(),
                        type: PageTransitionType.rightToLeft));
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(children: [
                  Hero(
                    tag: 'titleQuestion',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Basic Questions',
                        style: TextStyle(
                            fontFamily: Style.fontFamily,
                            color: Style.foregroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.24),
                thickness: 0.5,
              ),
            ),
            GestureDetector(
              // Chuyển hướng đến màn hình hướng dẫn cơ bản
              onTap: () {
                print("tapppp");
                Navigator.push(
                    context,
                    PageTransition(
                        child: UserGuideScreen(),
                        type: PageTransitionType.rightToLeft));
              },
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(children: [
                  Hero(
                    tag: 'titleGuide',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'User guide',
                        style: TextStyle(
                            fontFamily: Style.fontFamily,
                            color: Style.foregroundColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
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
