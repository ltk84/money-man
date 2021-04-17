// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:money_man/ui/screens/authentication_screens/authentication.dart';

// class AccessScreen extends StatefulWidget {
//   @override
//   _AccessScreenState createState() => _AccessScreenState();
// }

// class _AccessScreenState extends State<AccessScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               // backgroundImage: AssetImage('assets/1.jpg'),
//               radius: 100,
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 padding: EdgeInsets.symmetric(horizontal: 50),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => Authentication(
//                               showSignIn: true,
//                             )));
//               },
//               child: Text('LOGIN'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 padding: EdgeInsets.symmetric(horizontal: 43),
//               ),
//               onPressed: () {
//                 Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (_) => Authentication(
//                               showSignIn: false,
//                             )));
//               },
//               child: Text('SIGN UP'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 padding: EdgeInsets.symmetric(horizontal: 17),
//               ),
//               onPressed: () {},
//               child: Text('LOGIN AS GUEST'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
