import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/edit_bill_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/screens/account_screens/change_password_screen.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen({
    Key key,
  }) : super(key: key);
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
    return Scaffold(
        backgroundColor: Colors.black,
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
                    Icon(Icons.arrow_back_ios, color: Colors.white),
                    Text('More', style: Theme.of(context).textTheme.headline6)
                    // Hero(
                    //     tag: 'alo',
                    //     child: Text('More', style: Theme.of(context).textTheme.headline6)
                    // ),
                  ],
                ),
              ),
            ),
            //),
            //centerTitle: true,
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
            // title: AnimatedOpacity(
            //     opacity: reachTop == 1 ? 1 : 0,
            //     duration: Duration(milliseconds: 100),
            //     child: Text('About Us',
            //         style: Theme.of(context).textTheme.headline6)
            // )
        ),
        body: ListView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: _controller,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SuperIcon(
                  iconPath: 'assets/images/money_man.svg',
                  size: 150.0,
                ),
                Text(
                  'MONEY MAN',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w900,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 60.0),
                  child: Text(
                    'A great assistant in helping you manage your expenses in daily life',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 60.0),
                  child: Text(
                    'TEAM MEMBERS',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      scrollPhysics: BouncingScrollPhysics(),
                      autoPlay: false,
                      aspectRatio: 1.8,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                    ),
                    items: [
                      InfoCard(
                        name: 'Trương Kim Lâm',
                        iconPath: 'assets/images/avatars/avatar_7.svg',
                        avatarColor: Color(0xFFb5ffee),
                      ),
                      InfoCard(
                        name: 'Trần Lê Thanh Tùng',
                        iconPath: 'assets/images/avatars/avatar_6.svg',
                        avatarColor: Color(0xFFaef2fc),
                      ),
                      InfoCard(
                        name: 'Dương Hiển Thế',
                        iconPath: 'assets/images/avatars/avatar_5.svg',
                        avatarColor: Color(0xFF6b6b6b),
                      ),
                      InfoCard(
                        name: 'Huỳnh Trọng Phục',
                        iconPath: 'assets/images/avatars/avatar_4.svg',
                        avatarColor: Color(0xFFf2e7c9),
                      ),
                    ],
                  ),
                ),
              ],
            )
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 8.0),
            //   child: reachTop == 0
            //       ? Text('About',
            //       style: Theme.of(context).textTheme.headline4)
            //       : Text('', style: Theme.of(context).textTheme.headline4),
            // ),
            // Padding(
            //     padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 8.0),
            //     child: RichText(
            //       text: TextSpan(
            //         children: [
            //           TextSpan(
            //               text: 'Money Man ',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontFamily: 'Montserrat',
            //                 fontWeight: FontWeight.w600,
            //                 fontSize: 20.0,
            //               )
            //           ),
            //           TextSpan(
            //               text: 'is a great assistant in helping you manage, control and plan your expenses in daily life.',
            //               style: TextStyle(
            //                 color: Colors.white,
            //                 fontFamily: 'Montserrat',
            //                 fontWeight: FontWeight.w400,
            //                 fontSize: 16.0,
            //               )
            //           ),
            //         ]
            //       )
            //     )
            // ),
            // Padding(
            //     padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 8.0),
            //     child: Text('The application was developed by a group of sophomore from University of Information Technology, Vietnam National University HCMC (UIT), including:',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontFamily: 'Montserrat',
            //           fontWeight: FontWeight.w400,
            //           fontSize: 16.0,
            //         ))
            // ),
          ],
        )
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String iconPath;
  final Color avatarColor;
  const InfoCard({Key key, @required this.name, @required this.iconPath, @required this.avatarColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 45.0,
            child: SuperIcon(
              iconPath: iconPath,
              size: 60.0,
            ),
          ),
          SizedBox(height: 20.0,),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              fontSize: 22.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

