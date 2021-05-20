import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuperIcon extends StatelessWidget {
  final String svgAsset;
  final double size;

  const SuperIcon(
      this.svgAsset, {
        Key key,
        @required this.size,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Center(
        child: SvgPicture.network(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}