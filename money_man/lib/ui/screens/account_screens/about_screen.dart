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
import 'package:url_launcher/url_launcher.dart';

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
                      vertical: 10.0, horizontal: 40.0),
                  child: Text(
                    'Made by a group of sophomores of\nUniversity of Information Technology\nVNU-HCM',
                    style: TextStyle(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0,),
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
                        quote: 'I did nothing',
                        fbURL: 'https://facebook.com/kiaconbuomvangaaa',
                        igURL: 'https://instagram.com/tkl.84',
                        email: 'lamtk.84@gmail.com',
                      ),
                      InfoCard(
                        name: 'Trần Lê Thanh Tùng',
                        iconPath: 'assets/images/avatars/avatar_6.svg',
                        avatarColor: Color(0xFFaef2fc),
                        quote: 'I did everything',
                        fbURL: 'https://facebook.com/profile.php?id=100008011025292',
                        igURL: 'https://instagram.com/tung8201/',
                        email: '19522496@gm.uit.edu.vn',
                      ),
                      InfoCard(
                        name: 'Dương Hiển Thế',
                        iconPath: 'assets/images/avatars/avatar_5.svg',
                        avatarColor: Color(0xFF6b6b6b),
                        quote: 'Eternal love is real',
                        fbURL: 'https://facebook.com/hienthe.duong.5',
                        igURL: 'https://instagram.com/hacthe_miz/',
                        email: '19522252@gm.uit.edu.vn',
                      ),
                      InfoCard(
                        name: 'Huỳnh Trọng Phục',
                        iconPath: 'assets/images/avatars/avatar_4.svg',
                        avatarColor: Color(0xFFf2e7c9),
                        quote: 'I can swim',
                        fbURL: 'https://facebook.com/huynhtrongphuc01',
                        igURL: 'https://instagram.com/tronqphuc.01/',
                        email: '19522030@gm.uit.edu.vn',
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        )
    );
  }
}

class InfoCard extends StatelessWidget {
  final String name;
  final String iconPath;
  final Color avatarColor;
  final String fbURL;
  final String igURL;
  final String email;
  final String quote;

  const InfoCard(
      {
        Key key,
        @required this.name,
        @required this.iconPath,
        @required this.avatarColor,
        @required this.fbURL,
        @required this.igURL,
        @required this.email,
        @required this.quote,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder:
                  (context) => InfoCardDetail(
                    name: name,
                    iconPath: iconPath,
                    avatarColor: avatarColor,
                    fbURL: fbURL,
                    igURL: igURL,
                    email: email,
                    quote: quote,
                  )
          )
        );
      },
      child: Hero(
        tag: iconPath,
        child: Container(
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
              SizedBox(height: 5.0,),
              Text(
                quote,
                style: TextStyle(
                  color: Colors.white54,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCardDetail extends StatelessWidget {
  final String name;
  final String iconPath;
  final Color avatarColor;
  final String fbURL;
  final String igURL;
  final String email;
  final String quote;

  const InfoCardDetail(
      {
        Key key,
        @required this.name,
        @required this.iconPath,
        @required this.avatarColor,
        @required this.fbURL,
        @required this.igURL,
        @required this.email,
        @required this.quote,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Hero(
        tag: iconPath,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
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
                  SizedBox(height: 5.0,),
                  Text(
                    quote,
                    style: TextStyle(
                      color: Colors.white54,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60.0),
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.white;
                            return Color(
                                0xFF2c84d4); // Use the component's default.
                          },
                        ),
                        foregroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Color(
                                  0xFF2c84d4);
                            return Colors.white; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        launchURL(fbURL);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SuperIcon(
                            iconPath: 'assets/images/facebook.svg',
                            size: 18,
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            "Facebook",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                wordSpacing: 2.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60.0),
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors
                                  .white;
                            return Color(
                                0xFFc65072); // Use the component's default.
                          },
                        ),
                        foregroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Color(
                                  0xFFc65072);
                            return Colors
                                .white; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        launchURL(igURL);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SuperIcon(
                            iconPath: 'assets/images/instagram.svg',
                            size: 18,
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            "Instagram",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                wordSpacing: 2.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 60.0),
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.black;
                            return Colors.white; // Use the component's default.
                          },
                        ),
                        foregroundColor:
                        MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Colors.white;
                            return Colors.black; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: email,
                            queryParameters: {
                              'subject': "[MoneyMan]"
                            }
                        );
                        launchURL(emailLaunchUri.toString());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SuperIcon(
                            iconPath: 'assets/images/email_2.svg',
                            size: 18,
                          ),
                          SizedBox(width: 10.0,),
                          Text(
                            "Send Email",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                wordSpacing: 2.0),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // CloseButton(
            //   color: Colors.white,
            // ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28.0,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
