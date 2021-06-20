import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/screens/account_screens/change_password_screen.dart';

import '../../style.dart';

class AccountDetail extends StatefulWidget {
  User user;
  AccountDetail({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  _AccountDetailState createState() => _AccountDetailState();
}

class _AccountDetailState extends State<AccountDetail> {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  //
  // Text title = Text('My Account', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));
  // Text emptyTitle = Text('', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    } else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >= fontSizeText - 5) {
      setState(() {
        reachTop = 1;
      });
    } else {
      setState(() {
        reachTop = 0;
      });
    }
  }

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User _user = widget.user;
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leadingWidth: 250.0,
            leading: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Hero(
                tag: 'alo',
                child: Row(
                  children: [
                    Icon(Icons.arrow_back_ios, color: Style.foregroundColor),
                    Text('More', style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 17.0
                    )
                    )
                  ],
                ),
              ),
            ),
            //),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRect(
              child: AnimatedOpacity(
                opacity: reachAppBar == 1 ? 1 : 0,
                duration: Duration(milliseconds: 0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: reachTop == 1 ? 25 : 500,
                      sigmaY: 25,
                      tileMode: TileMode.values[0]),
                  child: AnimatedContainer(
                    duration: Duration(
                        milliseconds:
                            reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                    //child: Container(
                    //color: Colors.transparent,
                    color: Colors.grey[reachAppBar == 1
                            ? (reachTop == 1 ? 800 : 850)
                            : 900]
                        .withOpacity(0.2),
                    //),
                  ),
                ),
              ),
            ),
            title: AnimatedOpacity(
                opacity: reachTop == 1 ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Text('My Account',
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                    ))
            )
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 8.0),
              child: reachTop == 0
                  ? Text('My Account',
                      style: TextStyle(
                          fontSize: 30,
                          color: Style.foregroundColor,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.bold
                      ))
                  : Text('', style: TextStyle(
                  fontSize: 30,
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontWeight: FontWeight.bold
              )),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
                  border: Border(
                      top: BorderSide(
                        width: 0.1,
                        color: Style.foregroundColor.withOpacity(0.12),
                      ),
                      bottom: BorderSide(
                        width: 0.1,
                        color: Style.foregroundColor.withOpacity(0.12),
                      ))),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Style.foregroundColor,
                    radius: 30.0,
                    child: Text(
                        (_user == null)
                            ? ''
                            : (_user.displayName != '' &&
                                    _user.displayName != null)
                                ? _user.displayName.substring(0, 1)
                                : 'Y',
                      style: TextStyle(
                          color: Style.primaryColor,
                          fontSize: 30.0,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                        (_user.displayName != '' && _user.displayName != null)
                            ? _user.displayName
                            : (_user.phoneNumber != null
                                ? _user.phoneNumber
                                : 'Your name'),
                        style: TextStyle(
                            color: Style.foregroundColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: Style.fontFamily,
                            fontSize: 15.0
                        )),
                  ),
                  Text(
                      _user.email == null
                          ? 'Your email'
                          : (_user.email != '' ? _user.email : 'Your email'),
                      style: TextStyle(
                          color: Style.foregroundColor.withOpacity(0.54),
                          fontWeight: FontWeight.w400,
                          fontFamily: Style.fontFamily,
                          fontSize: 13.0
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 5,
                    thickness: 0.1,
                    color: Style.foregroundColor,
                  ),
                  ListTile(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (BuildContext context) =>
                      //             ChangePasswordScreen()));
                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => ChangePasswordScreen()
                      );
                    },
                    dense: true,
                    title: Text(
                      'Change password',
                      style: TextStyle(
                          color: Style.foregroundColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: Style.fontFamily,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
                  border: Border(
                      top: BorderSide(
                        width: 0.1,
                        color: Style.foregroundColor.withOpacity(0.12),
                      ),
                      bottom: BorderSide(
                        width: 0.1,
                        color: Style.foregroundColor.withOpacity(0.12),
                      ))),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      final _auth = FirebaseAuthService();
                      _auth.signOut();
                    },
                    dense: true,
                    title: Text(
                      'Sign out',
                      style: TextStyle(
                          color: Style.foregroundColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: Style.fontFamily,
                          fontSize: 15.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            )
          ],
        ));
  }
}

// class Test extends StatelessWidget {
//   Text title = Text('More', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Hero(tag: 'alo', child: title),
//       )
//     );
//   }
// }
