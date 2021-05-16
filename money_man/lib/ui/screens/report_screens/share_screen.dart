import 'dart:io';
import 'dart:typed_data';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import 'custom_time_range.dart';

class ShareScreen extends StatefulWidget{
  Uint8List bytes1;
  Uint8List bytes2;
  Uint8List bytes3;

  ShareScreen({Key key, @required this.bytes1, @required this.bytes2, @required this.bytes3}) : super(key: key);
  @override
  ShareScreenState createState() =>  ShareScreenState();
}
class ShareScreenState extends State<ShareScreen>{
  Uint8List reportData1;
  Uint8List reportData2;
  Uint8List reportData3;

  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportData1 = widget.bytes1;
    reportData2 = widget.bytes2;
    reportData3 = widget.bytes3;
  }

  @override
  void didUpdateWidget(covariant ShareScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    reportData1 = widget.bytes1;
    reportData2 = widget.bytes2;
    reportData3 = widget.bytes3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black45,
        appBar: AppBar(
          leadingWidth: 70.0,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0))),
          title: Text('Share',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0)),
          leading: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )
          ),
        ),
      // body: ListView(
      //   scrollDirection: Axis.horizontal,
      //   children: [
      //     buildImage(reportData1),
      //     buildImage(reportData2),
      //     buildImage(reportData3),
      //   ],
      // )
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            Container(
              child: CarouselSlider(
                options: CarouselOptions(
                  scrollPhysics: BouncingScrollPhysics(),
                  autoPlay: false,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: [
                  ImageFromUnit8List(reportData1),
                  ImageFromUnit8List(reportData2),
                  ImageFromUnit8List(reportData3),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0),
              padding: EdgeInsets.symmetric(horizontal: 100.0),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.white;
                      return Colors.blueAccent; // Use the component's default.
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) return Colors.blueAccent;
                      return Colors.white; // Use the component's default.
                    },
                  ),
                ),
                  onPressed: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file = await new File('${tempDir.path}/image.jpg').create();
                    var data = (_currentIndex == 0) ? reportData1 : ((_currentIndex == 1) ? reportData2 : reportData3);
                    file.writeAsBytesSync(data);
                    Share.shareFiles([file.path]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text('SHARE', style: TextStyle(fontSize: 15), textAlign: TextAlign.center),
                        flex: 3,
                      ),
                      Expanded(
                        child: Icon(Icons.share),
                        flex: 1,
                      ),
                    ],
                  ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget ImageFromUnit8List(Uint8List bytes) =>
      bytes != null ? Image.memory(bytes) : Container();
}