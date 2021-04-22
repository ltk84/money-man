import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';


class AccountDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Test();
  }
}

// class Test extends StatelessWidget {
//   Text title = Text('More', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Hero(tag: 'alo', child: title),
//       )
//     );
//   }
// }


class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  //
  Text title = Text('My Account', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));
  Text emptyTitle = Text('', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    }
    else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >= title.style.fontSize) {
      setState(() {
        reachTop = 1;
      });
    }
    else {
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
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leadingWidth: 250.0,
            leading: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back_ios, color: Colors.white),
                  Hero(
                    tag: 'alo',
                    child: Text('More', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontSize: 16.0, fontWeight: FontWeight.w500)
                    )
                  ),
                ],
              ),
            ),
            //),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: ClipRect(
              child: AnimatedOpacity(
                opacity: reachAppBar == 1 ? 1 : 0,
                duration: Duration(milliseconds: 0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: reachTop == 1 ? 25 : 500, sigmaY: 25, tileMode: TileMode.values[0]),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                    //child: Container(
                    //color: Colors.transparent,
                    color: Colors.grey[reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900].withOpacity(0.2),
                    //),
                  ),
                ),
              ),
            ),
            title: AnimatedOpacity(
                opacity: reachTop == 1 ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Text('My Account', style: TextStyle(color: Colors.white, fontFamily: 'Montseratt', fontSize: 17.0))
            )
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 8.0),
              child: reachTop == 0 ? title : emptyTitle,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border(
                      top: BorderSide(
                        width: 0.1,
                        color: Colors.white,
                      ),
                      bottom: BorderSide(
                        width: 0.1,
                        color: Colors.white,
                      )
                  )
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    child: Text('L', style: TextStyle(fontSize: 25.0)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('lamtruoq', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Montserrat', fontSize: 15.0)),
                  ),
                  Text('lamtruoq@gmail.com', style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w400, fontFamily: 'Montserrat', fontSize: 13.0)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(
                    height: 5,
                    thickness: 0.1,
                    color: Colors.white,
                  ),
                  ListTile(
                    onTap: () {
                    },
                    dense: true,
                    title: Text('Change password', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontFamily: 'Montserrat'), textAlign: TextAlign.center,),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
              decoration: BoxDecoration(
                  color: Colors.grey[900],
                  border: Border(
                      top: BorderSide(
                        width: 0.1,
                        color: Colors.white,
                      ),
                      bottom: BorderSide(
                        width: 0.1,
                        color: Colors.white,
                      )
                  )
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      final _auth = FirebaseAuthService();
                      _auth.signOut();
                    },
                    dense: true,
                    title: Text('Sign out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontFamily: 'Montserrat', fontSize: 14.0), textAlign: TextAlign.center,),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            )
          ],
        )
    );
  }
}