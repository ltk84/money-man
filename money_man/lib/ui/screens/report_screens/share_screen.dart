import 'dart:io';
import 'dart:typed_data';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'custom_time_range.dart';

class ShareScreen extends StatefulWidget {
  Uint8List bytes1;
  Uint8List bytes2;
  Uint8List bytes3;

  ShareScreen(
      {Key key,
      @required this.bytes1,
      @required this.bytes2,
      @required this.bytes3})
      : super(key: key);
  @override
  ShareScreenState createState() => ShareScreenState();
}

class ShareScreenState extends State<ShareScreen> {
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
      backgroundColor: boxBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: boxBackgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        title: Text('Share',
            style: TextStyle(
                color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 17.0,
              fontWeight: FontWeight.w600,)),
        leading: CloseButton(),
      ),
      body: Container(
          color: backgroundColor1,
          padding: EdgeInsets.symmetric(vertical: 20.0),
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
                    reportData1 != null ? ImageFromUnit8List(reportData1) : null,
                    reportData2 != null ? ImageFromUnit8List(reportData2) : null,
                    reportData3 != null ? ImageFromUnit8List(reportData3) : null,
                  ],
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 50, 40, 10),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Colors
                            .blueAccent; // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.blueAccent;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    final tempDir = await getTemporaryDirectory();
                    final file =
                        await new File('${tempDir.path}/image.jpg').create();
                    var data = (_currentIndex == 0)
                        ? reportData1
                        : ((_currentIndex == 1) ? reportData2 : reportData3);
                    file.writeAsBytesSync(data);
                    Share.shareFiles([file.path]);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.share),
                      SizedBox(width: 10,),
                      Text('SHARE',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamily,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            wordSpacing: 2.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(40, 5, 40, 10),
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Colors.green; // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    dynamic result = await ImageGallerySaver.saveImage(
                        (_currentIndex == 0)
                            ? reportData1
                            : ((_currentIndex == 1)
                                ? reportData2
                                : reportData3),
                        quality: 100,
                        name: 'Report_' + (_currentIndex + 1).toString());
                    if (result['isSuccess']) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        barrierColor: Colors.black54,
                        builder: (BuildContext context) {
                          return CustomAlert(
                            iconPath: "assets/images/success.svg",
                            title: "Successfully",
                            content: "Image has been saved,\ncheck your gallery.");
                        },
                      );
                    }
                    else {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        barrierColor: Colors.black54,
                        builder: (BuildContext context) {
                          return CustomAlert(
                              iconPath: "assets/images/error.svg",
                              content: "Something was wrong,\nplease try again.");
                        },
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.save_alt),
                      SizedBox(width: 10),
                      Text('SAVE',
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              wordSpacing: 2.0
                          ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget ImageFromUnit8List(Uint8List bytes) =>
      bytes != null ? Image.memory(bytes) : Container();
}
