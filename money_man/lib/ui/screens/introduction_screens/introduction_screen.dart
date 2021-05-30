import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
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
      resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: IntroductionSlide(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                  width: double.infinity,
                    // child: TextButton(
                    //   onPressed: () {
                    //     Navigator.pushReplacement(context,
                    //         MaterialPageRoute(builder: (_) => AccessScreen()));
                    //   },
                    //   child: Text('GET STARTED'),
                    //   style: TextButton.styleFrom(backgroundColor: Colors.black),
                    // ),
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) return Colors.white;
                          return Color(0xFF2FB49C); // Use the component's default.
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) return Color(0xFF2FB49C);
                          return Colors.white; // Use the component's default.
                        },
                      ),
                    ),
                    onPressed: () async {
                      // Navigator.pushReplacement(context,
                      //     MaterialPageRoute(builder: (_) => AccessScreen()));
                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => AccessScreen()
                      );
                    },
                    child: Text('GET STARTED',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                            wordSpacing: 2.0
                        ),
                        textAlign: TextAlign.center
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}
