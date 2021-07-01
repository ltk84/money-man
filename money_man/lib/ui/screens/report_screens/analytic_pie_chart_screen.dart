import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart_information_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/utils.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:money_man/ui/screens/report_screens/share_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/expandable_widget.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class AnalyticPieChartScreen extends StatefulWidget {
  // Ví được chọn hiện tại.
  final Wallet currentWallet;

  // Biến để xem đây là income chart hay expense chart.
  final String type;

  // Ngày bắt đầu và ngày kết thúc.
  final DateTime endDate;
  final DateTime beginDate;

  AnalyticPieChartScreen(
      {Key key,
      @required this.currentWallet,
      @required this.type,
      @required this.beginDate,
      @required this.endDate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AnalyticPieChartScreen();
}

class _AnalyticPieChartScreen extends State<AnalyticPieChartScreen> {
  // Biến nội dung và màu để nhận biệt là income chart hay expense chart.
  String content;
  Color color;

  // Biến thứ tự chạm để xử lý chạm cho pie chart.
  int touchedIndex = -1;

  // Các biến để chuyển widget thành dữ liệu để convert sang hình ảnh.
  GlobalKey key1;
  Uint8List bytes1;

  // Mở rộng phần danh sách transactions của pie chart.
  bool expandDetail;

  // Các biến về khoảng thời gian thống kê.
  DateTime beginDate;
  DateTime endDate;

  // Để kiểm tra xem scroll view được scroll tới đâu.
  ScrollController controller = ScrollController();

  // Lấy ví từ tham số mặc định.
  Wallet wallet;

  @override
  void initState() {
    super.initState();
    // Khởi tạo các giá trị từ tham số cũng như khởi tạo các giá trị mặc định.
    beginDate = widget.beginDate;
    endDate = widget.endDate;
    content = widget.type == 'expense' ? 'Expense' : 'Income';
    color = widget.type == 'expense' ? Style.expenseColor : Style.incomeColor2;
    controller = ScrollController();
    expandDetail = false;

    // Lấy ví từ tham số mặc định.
    wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'a')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant AnalyticPieChartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Lấy ví từ tham số mặc định.
    wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'a',
            iconID: 'b');
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
        backgroundColor: Style.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: new AppBar(
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'alo',
              child: Icon(Style.backIcon, color: Style.foregroundColor),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            Hero(
              tag: 'shareButton',
              child: MaterialButton(
                child: Icon(Icons.ios_share, color: Style.foregroundColor),
                onPressed: () async {
                  // Lấy dữ liệu của widget theo key.
                  final bytes1 = await Utils.capture(key1);

                  setState(() {
                    this.bytes1 = bytes1;
                  });
                  showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Style.boxBackgroundColor,
                      context: context,
                      builder: (context) => ShareScreen(
                          bytes1: this.bytes1, bytes2: null, bytes3: null));
                },
              ),
            ),
          ],
        ),
        body: StreamBuilder<Object>(
          stream: firestore.transactionStream(wallet, 'full'),
          builder: (context, snapshot) {
            // Lấy danh sách transaction từ stream.
            List<MyTransaction> transactionList = snapshot.data ?? [];
            // Khởi tạo danh sách danh mục.
            List<MyCategory> categoryList = [];

            // Tổng số tiền của chart.
            double total = 0;

            // Duyệt danh sách transactions để thực hiện các tác vụ lọc danh sách danh mục và tính toán các khoản tiền.
            transactionList.forEach((element) {
              if (element.date.compareTo(endDate) <= 0) {
                if (element.category.type == widget.type) {
                  if (element.date.compareTo(beginDate) >= 0) {
                    // Tính toán tổng số tiền.
                    total += element.amount;
                    // Lọc những danh mục từ danh sách transaction và thêm vào danh sách danh mục.
                    if (!categoryList.any((categoryElement) {
                      if (categoryElement.name == element.category.name)
                        return true;
                      else
                        return false;
                    })) {
                      categoryList.add(element.category);
                    }
                  }
                }
              }
            });
            // Lọc danh sách transactions trong khoảng thời gian đã được xác định.
            transactionList = transactionList
                .where((element) =>
                    element.date.compareTo(beginDate) >= 0 &&
                    element.date.compareTo(endDate) <= 0)
                .toList();
            return Container(
              color: Style.backgroundColor,
              child: ListView(
                controller: controller,
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: <Widget>[
                  Container(
                    color: Style.backgroundColor,
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: WidgetToImage(
                      builder: (key) {
                        // Lấy key để khi ấn share, có thể nhận biết được widget nào để convert sang hình ảnh.
                        this.key1 = key;

                        return Container(
                          color: Style
                              .backgroundColor, // để lúc export ra không bị transparent.
                          child: Column(children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  content,
                                  style: TextStyle(
                                    color:
                                        Style.foregroundColor.withOpacity(0.7),
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                ),
                                MoneySymbolFormatter(
                                  text: total,
                                  currencyId: wallet.currencyID,
                                  textStyle: TextStyle(
                                    color: color,
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                PieChartScreen(
                                    isShowPercent: true,
                                    currentList: transactionList,
                                    categoryList: categoryList,
                                    total: total),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: () async {
                                // Xử lý mở rộng phần danh sách transactions cho chart detail.
                                setState(() {
                                  expandDetail = !expandDetail;
                                  print(controller.position.maxScrollExtent
                                      .toString());
                                });
                                // Điều hướng controller scroll xuống dưới cùng.
                                if (expandDetail)
                                  controller.animateTo(
                                    categoryList.length == 0
                                        ? 0
                                        : categoryList.length.toDouble() *
                                                67.4 -
                                            193.2 +
                                            .05494505494505 +
                                            100,
                                    curve: Curves.fastOutSlowIn,
                                    duration: const Duration(milliseconds: 500),
                                  );
                                //_controller.jumpTo(100);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Style.boxBackgroundColor,
                                    border: Border(
                                        top: BorderSide(
                                          color: Style.foregroundColor
                                              .withOpacity(0.12),
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: Style.foregroundColor
                                              .withOpacity(0.12),
                                          width: 1,
                                        ))),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('View amount',
                                        style: TextStyle(
                                          fontFamily: Style.fontFamily,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                          color: Style.foregroundColor,
                                        )),
                                    Icon(Icons.arrow_drop_down,
                                        color: Style.foregroundColor
                                            .withOpacity(0.54)),
                                  ],
                                ),
                              ),
                            ),
                            ExpandableWidget(
                              expand: expandDetail,
                              child: PieChartInformationScreen(
                                currentList: transactionList,
                                categoryList: categoryList,
                                currentWallet: wallet,
                                color: color,
                              ),
                            )
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
