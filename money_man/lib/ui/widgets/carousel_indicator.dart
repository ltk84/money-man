import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:money_man/core/models/superIconModel.dart';

class IntroductionSlide extends StatefulWidget {
  const IntroductionSlide({Key key}) : super(key: key);

  @override
  _IntroductionSlideState createState() => _IntroductionSlideState();
}

class _IntroductionSlideState extends State<IntroductionSlide> {
  dynamic imgList;
  int _currentIndex = 0;

  Future _initImages() async {
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths =
    manifestMap.keys
        .where((String key) => key.contains('images/carousel/'))
        .where((String key) => key.contains('.svg'))
        .toList();
    setState(() {
      imgList = imagePaths;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (imgList == null)
      _initImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return imgList != null ? Column(
      children: [
        CarouselSlider(
          items: imgList.map<Widget>((element) {
            return Container(
                color: Colors.yellow,
                child: SuperIcon(
                  iconPath: element,
                  size: 200.0,
                )
            );
          }).toList(),
          options: CarouselOptions(
              scrollPhysics: BouncingScrollPhysics(),
              autoPlay: false,
              aspectRatio: 1.0,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              }
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map<Widget>((element) {
            int index = imgList.indexOf(element);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color.fromRGBO(0, 0, 0, 0.9)
                    : Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    ) : Center(child: Text('Error'));
  }
}