import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/basic_questions.dart';
import 'package:money_man/core/models/user_guide.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/answer_questions_screen.dart';
import 'package:money_man/ui/screens/account_screens/help_screens/guide_detail.dart';
import 'package:money_man/ui/style.dart';

class UserGuideScreen extends StatelessWidget {
  const UserGuideScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserGuides mQuestion = new UserGuides();
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
          tag: 'titleGuide',
          child: Material(
            color: Colors.transparent,
            child: Text(
              'User guide',
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
    UserGuides mQuestion = new UserGuides();
    return GestureDetector(
      onTap: () {
        print("tappsdfgnpp");
        showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => GuideDetailScreen(
                  index: index,
                ));
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
