import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final TextStyle style;

  const Indicator({
    Key key,
    @required this.color,
    @required this.text,
    @required this.isSquare,
    this.size = 14,
    this.style = const TextStyle(
      fontFamily: 'Montserrat',
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: Colors.white54,
    ),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: style,
          )
        ],
      ),
    );
  }
}