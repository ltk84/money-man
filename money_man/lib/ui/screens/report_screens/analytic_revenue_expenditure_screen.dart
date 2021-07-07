import 'dart:typed_data';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart_information_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/utils.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:money_man/ui/screens/report_screens/share_screen.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';

class AnalyticRevenueAndExpenditureScreen extends StatefulWidget {
  final Wallet currentWallet;
  final DateTime endDate;
  final DateTime beginDate;
  AnalyticRevenueAndExpenditureScreen({
    Key key,
    this.currentWallet,
    this.endDate,
    this.beginDate,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AnalyticRevenueAndExpenditureScreen();
  }
}

class _AnalyticRevenueAndExpenditureScreen
    extends State<AnalyticRevenueAndExpenditureScreen>
    with TickerProviderStateMixin {
  // Các biến để chuyển widget thành dữ liệu để convert sang hình ảnh.
  GlobalKey key1;
  Uint8List bytes1;

  // Việc để fontSize này là để căn chuẩn lúc nào text ở title chạm top của app bar.
  final double fontSizeText = 29.7;

  // Cái này để check xem element đầu tiên trong ListView chạm đỉnh chưa.
  int reachTop = 0;
  int reachAppBar = 0;
  DateTime beginDate;
  DateTime endDate;

  // Phần này để check xem mình đã Scroll tới đâu trong ListView
  ScrollController controller = ScrollController();
  scrollListener() {
    if (controller.offset > 0) {
      setState(() {
        reachAppBar = 1;
      });
    } else {
      setState(() {
        reachAppBar = 0;
      });
    }
    if (controller.offset >= fontSizeText - 5) {
      setState(() {
        reachTop = 1;
      });
    } else {
      setState(() {
        reachTop = 0;
      });
    }
  }

  // Lấy ví được truyền vào từ tham số.
  Wallet wallet;

  // Khởi tạo mốc thời gian cần thống kê.
  String dateDescription = 'This month';

  @override
  void initState() {
    // Lấy các giá trị được truyền vào từ tham số.
    beginDate = widget.beginDate;
    endDate = widget.endDate;

    // Cài đặt khởi tạo cho controller.
    controller = ScrollController();
    controller.addListener(scrollListener);
    super.initState();

    // Lấy ví được truyền vào từ tham số.
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
  void didUpdateWidget(
      covariant AnalyticRevenueAndExpenditureScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Lấy ví được truyền vào từ tham số.
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
        appBar: AppBar(
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'alo',
              child: Icon(Style.backIcon, color: Style.foregroundColor),
            ),
          ),
          centerTitle: true,
          backgroundColor: Style.backgroundColor,
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
                  color: Colors.grey[
                          reachAppBar == 1 ? (reachTop == 1 ? 800 : 850) : 900]
                      .withOpacity(0.2),
                ),
              ),
            ),
          ),
          title: AnimatedOpacity(
              opacity: reachTop == 1 ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Text('Net Income',
                  style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                  ))),
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

              // Khởi tạo danh sách để các danh mục income, expense.
              List<MyCategory> incomeCategoryList = [];
              List<MyCategory> expenseCategoryList = [];

              // Các biến tính toán số tiền.
              double openingBalance = 0;
              double closingBalance = 0;

              // Duyệt danh sách transactions để thực hiện các tác vụ lọc danh sách danh mục và tính toán các khoản tiền.
              transactionList.forEach((element) {
                if (element.date.isBefore(beginDate)) {
                  // Tính toán opening balance.
                  if (element.category.type == 'expense')
                    openingBalance -= element.amount;
                  else if (element.category.type == 'income')
                    openingBalance += element.amount;
                }
                if (element.date.compareTo(endDate) <= 0) {
                  // Tính toán closing balance.
                  if (element.category.type == 'expense') {
                    closingBalance -= element.amount;

                    // Lọc những danh mục expense từ danh sách transaction hiện có và thêm vào danh sách danh mục expense.
                    if (element.date.compareTo(beginDate) >= 0) {
                      if (!expenseCategoryList.any((categoryElement) {
                        if (categoryElement.name == element.category.name)
                          return true;
                        else
                          return false;
                      })) {
                        expenseCategoryList.add(element.category);
                      }
                    }
                  } else if (element.category.type == 'income') {
                    closingBalance += element.amount;

                    // Lọc những danh mục income từ danh sách transaction hiện có và thêm vào danh sách danh mục income.
                    if (element.date.compareTo(beginDate) >= 0) {
                      if (!incomeCategoryList.any((categoryElement) {
                        if (categoryElement.name == element.category.name)
                          return true;
                        else
                          return false;
                      })) {
                        incomeCategoryList.add(element.category);
                      }
                    }
                  }
                }
              });
              // Lọc danh sách transactions trong khoảng thời gian đã được xác định.
              transactionList = transactionList
                  .where((element) =>
                      element.date.compareTo(beginDate) >= 0 &&
                      element.date.compareTo(endDate) <= 0 &&
                      element.category.type != 'debt & loan')
                  .toList();
              return Container(
                color: Style.backgroundColor,
                child: ListView(
                  controller: controller,
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: <Widget>[
                    WidgetToImage(builder: (key) {
                      // Lấy key để khi ấn share, có thể nhận biết được widget nào để convert sang hình ảnh.
                      this.key1 = key;
                      return Column(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                              color: Style.backgroundColor, // để lúc export ra không bị transparent.
                              child: Hero(
                                tag: 'netIncomeChart',
                                child: Material(
                                  color: Style.backgroundColor,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Net Income',
                                          style: TextStyle(
                                            color: Style.foregroundColor
                                                .withOpacity(0.7),
                                            fontFamily: Style.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          )),
                                      MoneySymbolFormatter(
                                          text: closingBalance - openingBalance,
                                          currencyId: wallet.currencyID,
                                          textStyle: TextStyle(
                                            color: (closingBalance -
                                                        openingBalance) >
                                                    0
                                                ? Style.incomeColor
                                                : (closingBalance -
                                                            openingBalance) ==
                                                        0
                                                    ? Style.foregroundColor
                                                    : Style.expenseColor,
                                            fontFamily: Style.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 26,
                                            height: 1.5,
                                          )),
                                      Container(
                                        width: 450,
                                        height: 200,
                                        child: BarChartScreen(
                                            currentList: transactionList,
                                            beginDate: beginDate,
                                            endDate: endDate),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Container(
                            child: BarChartInformation(
                              currentList: transactionList,
                              beginDate: beginDate,
                              endDate: endDate,
                              currentWallet: wallet,
                            ),
                          )
                        ],
                      );
                    })
                  ],
                ),
              );
            }));
  }
}
