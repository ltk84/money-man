import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

_initImages() async {
  // >> To get paths you need these 2 lines
  final manifestContent = await rootBundle.loadString('AssetManifest.json');

  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  // >> To get paths you need these 2 lines

  final imagePaths =
      manifestMap.keys.where((String key) => key.contains('.jpg')).toList();

  return imagePaths;
}

final imgList = _initImages();

Widget carouselWithIndicator = new Swiper(
  // hardcode tạm thời
  itemBuilder: (BuildContext context, int index) {
    return index < 5 && index >= 1
        ? Image(
            image: AssetImage('assets/$index.jpg'),
            fit: BoxFit.fill,
          )
        : null;
  },
  loop: false,
  layout: SwiperLayout.TINDER,
  itemWidth: 500.0,
  itemHeight: 500.0,
  itemCount: 4,
  viewportFraction: 0.5,
  scale: 0.5,
  pagination: SwiperPagination(alignment: Alignment.bottomCenter),
);
