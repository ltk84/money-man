import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';

class IntroductionSlide extends StatefulWidget {
  const IntroductionSlide({Key key}) : super(key: key);

  @override
  _IntroductionSlideState createState() => _IntroductionSlideState();
}

class _IntroductionSlideState extends State<IntroductionSlide> {
  dynamic imgList; // danh sách path các ảnh của phần giới thiệu
  List<String> description = [
    "I'm a man who will help you to mange your money.",
    "Track your spending/income.",
    "Achieve your financial goals."
  ]; //danh sách các câu mô tả ứng với mỗi hình ảnh

  int _currentIndex = 0; // index trang hiện tại của slide giới thiệu

  // Hàm lấy danh sách các hình ảnh giới thiệu
  Future _initImages() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/carousel/'))
        .where((String key) => key.contains('.svg'))
        .toList();
    setState(() {
      imgList = imagePaths;
    });
  }

  @override
  void initState() {
    if (imgList == null) _initImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return imgList != null
        //Hiển thị các slide giới thiệu khi imgList khác null
        ? Column(
            children: [
              CarouselSlider(
                items: imgList.map<Widget>((element) {
                  var index = imgList.indexOf(element);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SuperIcon(
                        iconPath: element,
                        size: 200.0,
                      ),
                      index == 0
                          ? Text(
                              'MONEY MAN',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w900,
                                fontSize: 24.0,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : SizedBox(
                              height: 30.0,
                            ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 40.0),
                        child: Text(
                          description[index],
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }).toList(),
                options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(),
                    autoPlay: false,
                    aspectRatio: 0.8,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.map<Widget>((element) {
                  int index = imgList.indexOf(element);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Color.fromRGBO(255, 255, 255, 0.9)
                          : Color.fromRGBO(255, 255, 255, 0.4),
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        // Trả về màn hình loading khi imgList null
        : Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  color: Colors.white.withOpacity(0.12),
                  size: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Loading',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.24),
                  ),
                ),
              ],
            ));
  }
}
