import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/account_screens/about_screen.dart';
import 'package:money_man/ui/screens/account_screens/my_wallets_screen.dart';
import 'package:money_man/ui/screens/categories_screens/categories_account_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'account_detail_screen.dart';
import 'help_screens/help_screens.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AcountScreenWidget();
  }
}

class AcountScreenWidget extends StatefulWidget {
  @override
  _AcountScreenWidgetState createState() => _AcountScreenWidgetState();
}

class _AcountScreenWidgetState extends State<AcountScreenWidget> {
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  //
  Text title = Text('More',
      style: TextStyle(
          fontSize: 30,
          color: Style.foregroundColor,
          fontFamily: Style.fontFamily,
          fontWeight: FontWeight.bold));
  Text emptyTitle = Text('',
      style: TextStyle(
          fontSize: 30,
          color: Style.foregroundColor,
          fontFamily: Style.fontFamily,
          fontWeight: FontWeight.bold));

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
    if (_controller.offset >= title.style.fontSize - 5) {
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
    final _auth = Provider.of<FirebaseAuthService>(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
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
                  color: Colors.grey[
                  reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900]
                      .withOpacity(0.2),
                  //),
                ),
              ),
            ),
          ),
          title: AnimatedOpacity(
              opacity: reachTop == 1 ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Text('More',
                  style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ))),
        ),
        body: StreamBuilder<User>(
            stream: _auth.userStream,
            builder: (context, snapshot) {
              User _user = snapshot.data;
              return ListView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _controller,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 8.0),
                    child: reachTop == 0
                        ? Hero(tag: 'alo', child: title)
                        : emptyTitle,
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
                                (_user == null)
                                    ? ''
                                    : (_user.displayName != '' &&
                                    _user.displayName != null)
                                    ? _user.displayName
                                    : (_user.phoneNumber != null
                                    ? _user.phoneNumber
                                    : 'Your name'),
                                style: TextStyle(
                                    color: Style.foregroundColor,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: Style.fontFamily,
                                    fontSize: 15.0)),
                          ),
                          Text(
                              (_user == null)
                                  ? ''
                                  : _user.email == null
                                  ? 'Your email'
                                  : (_user.email != ''
                                  ? _user.email
                                  : 'Your email'),
                              style: TextStyle(
                                  color: Style.foregroundColor.withOpacity(0.54),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 13.0)),
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
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: AccountDetail(
                                        user: _user,
                                      ),
                                      type: PageTransitionType.rightToLeft));
                            },
                            dense: true,
                            leading: Icon(Icons.person,
                                color: Style.foregroundColor.withOpacity(0.54), size: 38.0),
                            title: Text('My Account',
                                style: TextStyle(
                                    color: Style.foregroundColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: Style.fontFamily)),
                            subtitle: Text('Your infomation',
                                style: TextStyle(
                                    color: Style.foregroundColor.withOpacity(0.54),
                                    fontWeight: FontWeight.w400,
                                    fontFamily: Style.fontFamily,
                                    fontSize: 13.0)),
                            trailing: Icon(Icons.chevron_right,
                                color: Style.foregroundColor.withOpacity(0.54)),
                          )
                        ],
                      )),
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
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: MyWalletScreen(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          dense: true,
                          leading: Icon(Icons.account_balance_wallet_rounded,
                              color: Style.foregroundColor.withOpacity(0.54),
                              size: 25.0),
                          title: Text('My Wallets',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0)),
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: Divider(
                            height: 0,
                            thickness: 0.1,
                            color: Style.foregroundColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: CategoriesScreen(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          dense: true,
                          leading: Icon(Icons.category,
                              color: Style.foregroundColor.withOpacity(0.54),
                              size: 25.0),
                          title: Text('Categories',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0)),
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
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
                          onTap: () {},
                          dense: true,
                          leading: Icon(Icons.explore,
                              color: Style.foregroundColor.withOpacity(0.54),
                              size: 25.0),
                          title: Text('Explore',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0)),
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: Divider(
                            height: 0,
                            thickness: 0.1,
                            color: Style.foregroundColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HelpScreens()));
                          },
                          dense: true,
                          leading: Icon(Icons.help_outline,
                              color: Style.foregroundColor.withOpacity(0.54),
                              size: 25.0),
                          title: Text('Help & Support',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0)),
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: Divider(
                            height: 0,
                            thickness: 0.1,
                            color: Style.foregroundColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          dense: true,
                          leading: Icon(Icons.settings,
                              color: Style.foregroundColor.withOpacity(0.54),
                              size: 25.0),
                          title: Text('Settings',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0)),
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(70, 0, 0, 0),
                          child: Divider(
                            height: 0,
                            thickness: 0.1,
                            color: Style.foregroundColor,
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AboutScreen(),
                                    type: PageTransitionType.rightToLeft));
                          },
                          dense: true,
                          leading: Icon(Icons.info,
                              color: Style.foregroundColor.withOpacity(0.54),
                              size: 25.0),
                          title: Text('About',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0)),
                          trailing: Icon(Icons.chevron_right,
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  )
                ],
              );
            }));
  }
}
