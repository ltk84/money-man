import 'dart:ui';
import 'package:flutter/material.dart';

class CurrencySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Test();
  }
}

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;

  //
  // Text title = Text('More', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));
  // Text emptyTitle = Text('', style: TextStyle(fontSize: 30, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold));

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController _controller = ScrollController();
  _scrollListener() {
    if (_controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    } else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (_controller.offset >= fontSizeText - 5) {
      setState(() {
        reachTop = 1;
      });
    } else {
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
          leadingWidth: double.infinity,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
                //Text('Add Wallet', style: Theme.of(context).textTheme.headline6),
                Text('Add Wallet',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: ClipRect(
            child: AnimatedOpacity(
              opacity: reachAppBar == 1 ? 1 : 0,
              duration: Duration(milliseconds: 0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: reachTop == 1 ? 25 : 500,
                    sigmaY: 25,
                    tileMode: TileMode.values[0]),
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds:
                          reachAppBar == 1 ? (reachTop == 1 ? 100 : 0) : 0),
                  //child: Container(
                  //color: Colors.transparent,
                  color: Colors.grey[
                          reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900]
                      .withOpacity(0.2),
                  //),
                ),
              ),
            ),
          ),
          title: AnimatedOpacity(
              opacity: reachTop == 1 ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Text('Currency',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 17.0))),
        ),
        body: ListView(
          physics: BouncingScrollPhysics(),
          controller: _controller,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 0, 8.0),
              child: reachTop == 0
                  ? Text('Currency',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold))
                  : Text('',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
            ),
          ],
        ));
  }
}
