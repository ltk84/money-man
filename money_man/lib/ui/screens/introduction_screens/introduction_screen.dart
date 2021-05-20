import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/introduction_screens/access_screen.dart';
import '../../widgets/carousel_indicator.dart';
class IntroductionScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Introduction();
  }
}
class Introduction extends StatefulWidget{
  @override
  _Introduction createState() => _Introduction();
}
class _Introduction extends State<Introduction> {
  final double fontSizeText = 30;
  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;
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
    if (_controller.offset >=  fontSizeText  - 5) {
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
        body: Center(
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Lorem ipsum'),
          Container(
            child: carouselWithIndicator,
            height: 350,
            width: 300,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
            child: Text(
                'Lorem Ipsum is s hdard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop .'),
          ),
          Container(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => AccessScreen()));
                },
                child: Text('GET STARTED'),
                style: TextButton.styleFrom(backgroundColor: Colors.black),
              ),
              alignment: Alignment.bottomCenter)
        ],
      ),
    ));
  }
}
