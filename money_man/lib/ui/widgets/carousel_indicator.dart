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

  Future _initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths =
    manifestMap.keys
        .where((String key) => key.contains('images/carousel/'))
        .where((String key) => key.contains('.svg'))
        .toList();
    imgList = imagePaths;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(imgList.toString());
            return CarouselSlider(
              items: imgList.map<Widget>((element) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        color: Colors.transparent,
                        child: SuperIcon(
                          iconPath: element,
                          size: 100.0,
                        )
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                scrollPhysics: BouncingScrollPhysics(),
                autoPlay: false,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            );
          }
          else {
            return Center(
              child: Text('Loading'),
            );
          }
        }
    );
  }
}