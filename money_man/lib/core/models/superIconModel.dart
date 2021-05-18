import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class _Badge extends StatelessWidget {
  final String svgAsset;
  final double size;

  const _Badge(
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
        child: SvgPicture.asset(
          svgAsset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}