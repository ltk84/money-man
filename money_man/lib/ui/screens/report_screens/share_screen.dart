import 'dart:io';
import 'dart:typed_data';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ShareScreen extends StatefulWidget {

  // Các tham số truyền vào để lấy dữ liệu từ widget và chuyển sang hình ảnh.
  final Uint8List bytes1;
  final Uint8List bytes2;
  final Uint8List bytes3;

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

  // Các tham số truyền vào để lấy dữ liệu từ widget và chuyển sang hình ảnh.
  Uint8List reportData1;
  Uint8List reportData2;
  Uint8List reportData3;

  // Thứ tự của hình ảnh đang chọn để xuất.
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    reportData1 = widget.bytes1;
    reportData2 = widget.bytes2;
    reportData3 = widget.bytes3;
  }

  @override
  void didUpdateWidget(covariant ShareScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    reportData1 = widget.bytes1;
    reportData2 = widget.bytes2;
    reportData3 = widget.bytes3;
  }

  @override
  Widget build(BuildContext context) {

    // Gán tên file cho báo cáo được xuất theo sự chênh lệch giây giữa thời gian hiện tại và đầu năm 2021.
    // Việc này là để có thể xuất các file riêng biệt mà không bị trùng lặp, tránh dẫn tới việc file bị ghi đè khi xuất.
    String reportName = 'Report_' +
        DateTime.now().difference(DateTime(2021)).inSeconds.toString();

    return Scaffold(
      backgroundColor: Style.boxBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.appBarColor,
        title: Text('Share',
            style: TextStyle(
              color: Style.foregroundColor,
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
            )),
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
      ),
      body: Container(
          color: Style.backgroundColor1,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: ListView(
            children: [
              Container(
                child: CarouselSlider(
                  options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(),
                    autoPlay: false,
                    aspectRatio: 1.2,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  items: [
                    if (reportData1 != null) getImageFromUnit8List(reportData1),
                    if (reportData2 != null) getImageFromUnit8List(reportData2),
                    if (reportData3 != null) getImageFromUnit8List(reportData3),
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
                        await new File('${tempDir.path}/$reportName.jpg')
                            .create();
                    var data = (currentIndex == 0)
                        ? reportData1
                        : ((currentIndex == 1) ? reportData2 : reportData3);
                    file.writeAsBytesSync(data);
                    Share.shareFiles([file.path]);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.share),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'SHARE',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            wordSpacing: 2.0),
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
                    // Gọi hàm cấp phép truy cập storage để lưu ảnh.
                    if (await Permission.storage.request().isGranted && await Permission.photos.request().isGranted) {
                      // Lưu hình ảnh theo thứ tự đang được chọn.
                      dynamic result = await ImageGallerySaver.saveImage(
                          (currentIndex == 0)
                              ? reportData1
                              : ((currentIndex == 1)
                              ? reportData2
                              : reportData3),
                          quality: 100,
                          name: reportName);

                      if (result['isSuccess']) {
                        // Thông báo lưu thành công.
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Style.backgroundColor.withOpacity(0.54),
                          builder: (BuildContext context) {
                            return CustomAlert(
                                iconPath: "assets/images/success.svg",
                                title: "Successfully",
                                content:
                                "Image has been saved,\ncheck your gallery.");
                          },
                        );
                      } else {
                        // Thông báo lưu thất bại.
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          barrierColor: Style.backgroundColor.withOpacity(0.54),
                          builder: (BuildContext context) {
                            return CustomAlert(
                                iconPath: "assets/images/error.svg",
                                content:
                                "Something was wrong,\nplease try again.");
                          },
                        );
                      }
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.save_alt),
                      SizedBox(width: 10),
                      Text(
                        'SAVE',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            wordSpacing: 2.0),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  // Hàm chuyển từ dữ liệu của widget sang hình ảnh.
  Widget getImageFromUnit8List(Uint8List bytes) =>
      bytes != null ? Image.memory(bytes) : Container();
}
