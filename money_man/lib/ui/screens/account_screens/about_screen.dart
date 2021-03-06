import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../style.dart';

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
              child: Material(
                color: Colors.transparent,
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
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          controller: _controller,
          children: [
            // Column lưu trữ thông tin sơ bộ về ứng dụng :v
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
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w900,
                    fontSize: 24.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
                  child: Text(
                    'Made by a group of sophomores of\nUniversity of Information Technology\nVNU-HCM',
                    style: TextStyle(
                      color: Style.foregroundColor.withOpacity(0.7),
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
                  child: Text(
                    'TEAM MEMBERS',
                    style: TextStyle(
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 26.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  // Slider mô tả thông tin các thành viên
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
                        fbURL:
                            'https://facebook.com/profile.php?id=100008011025292',
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
        ));
  }
}

// Card về thông tin của thành viên, avt, tên và description
class InfoCard extends StatelessWidget {
  final String name; // Tên thành viên
  final String iconPath; // path đến icon chỉ định của thành viên
  final Color avatarColor; // màu chủ đạo của thành viên
  final String fbURL; // link đến fb cá nhân
  final String igURL; // link đến insta cá nhân
  final String email; // mail của thành viên
  final String quote; // trích dẫn mô tả thành viên

  const InfoCard({
    Key key,
    @required this.name,
    @required this.iconPath,
    @required this.avatarColor,
    @required this.fbURL,
    @required this.igURL,
    @required this.email,
    @required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển đến trang thông tin chi tiết
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InfoCardDetail(
                  name: name,
                  iconPath: iconPath,
                  avatarColor: avatarColor,
                  fbURL: fbURL,
                  igURL: igURL,
                  email: email,
                  quote: quote,
                )));
      },
      child: Hero(
        tag: iconPath,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Style.boxBackgroundColor,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Style.boxBackgroundColor,
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
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 22.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  quote,
                  style: TextStyle(
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Thông tin chi tiết của thành viên
class InfoCardDetail extends StatelessWidget {
  final String name;
  final String iconPath; // icon được chỉ định của thành viên
  final Color avatarColor;
  final String fbURL;
  final String igURL;
  final String email;
  final String quote;

  const InfoCardDetail({
    Key key,
    @required this.name,
    @required this.iconPath,
    @required this.avatarColor,
    @required this.fbURL,
    @required this.igURL,
    @required this.email,
    @required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: iconPath,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Style.boxBackgroundColor,
                //borderRadius: BorderRadius.circular(15.0),
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w700,
                      fontSize: 22.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    quote,
                    style: TextStyle(
                      color: Style.foregroundColor.withOpacity(0.54),
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
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
                              return Colors.white;
                            return Style
                                .fbButtonColor; // Use the component's default.
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Style.fbButtonColor;
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
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Facebook",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Style.fontFamily,
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
                              return Colors.white;
                            return Style
                                .igButtonColor; // Use the component's default.
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Style.igButtonColor;
                            return Colors.white; // Use the component's default.
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
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Instagram",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Style.fontFamily,
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
                              return Style.backgroundColor;
                            return Style
                                .foregroundColor; // Use the component's default.
                          },
                        ),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return Style.foregroundColor;
                            return Style
                                .backgroundColor; // Use the component's default.
                          },
                        ),
                      ),
                      onPressed: () {
                        Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: email,
                            queryParameters: {'subject': "[MoneyMan]"});
                        launchURL(emailLaunchUri.toString());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.email_rounded,
                            size: 18,
                            color: Style.backgroundColor,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            "Send Email",
                            style: TextStyle(
                                fontSize: 13,
                                fontFamily: Style.fontFamily,
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
                    color: Style.foregroundColor,
                    size: 28.0,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}
