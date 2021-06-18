// import 'package:flutter/material.dart';
// import 'package:money_man/ui/style.dart';
//
// class Indicator extends StatelessWidget {
//   final Color color;
//   final String text;
//   final String value;
//   final bool isSquare;
//   final bool isShowPercent;
//   final double size;
//   final TextStyle style;
//
//   const Indicator({
//     Key key,
//     @required this.color,
//     @required this.text,
//     this.value = '',
//     @required this.isSquare,
//     this.isShowPercent = false,
//     this.size = 14,
//     this.style = const TextStyle(
//       fontFamily: Style.fontFamily,
//       fontWeight: FontWeight.w500,
//       fontSize: 14.0,
//       color: Style.foregroundColor.withOpacity(0.54),
//     ),
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 2, horizontal: isShowPercent ? 60 : 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Row(
//             children: [
//               Container(
//                 width: size,
//                 height: size,
//                 decoration: BoxDecoration(
//                   shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(
//                 width: 5,
//               ),
//               Text(
//                 text,
//                 style: style,
//               )
//             ],
//           ),
//           if(isShowPercent)
//             Text(
//               value,
//               style: style,
//             )
//         ],
//       ),
//     );
//   }
// }