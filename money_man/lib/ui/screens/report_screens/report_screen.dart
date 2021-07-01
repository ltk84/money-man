import 'dart:typed_data';
import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/report_screens/analytic_revenue_expenditure_screen.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/report_screens/analytic_pie_chart_screen.dart';
import 'package:money_man/ui/screens/report_screens/share_report/utils.dart';
import 'package:money_man/ui/screens/report_screens/share_report/widget_to_image.dart';
import 'package:money_man/ui/screens/report_screens/share_screen.dart';
import 'package:money_man/ui/screens/report_screens/time_selection.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import '../../style.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:provider/provider.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';

class ReportScreen extends StatefulWidget {
  final Wallet currentWallet;
  final DateTime beginDate;
  final DateTime endDate;
  ReportScreen({Key key, this.currentWallet, this.endDate, this.beginDate})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReportScreen();
  }
}

class _ReportScreen extends State<ReportScreen> with TickerProviderStateMixin {
  // Các biến để chuyển widget thành dữ liệu để convert sang hình ảnh.
  GlobalKey key1;
  GlobalKey key2;
  GlobalKey key3;
  Uint8List bytes1;
  Uint8List bytes2;
  Uint8List bytes3;

  // Lấy ví được truyền vào từ tham số.
  Wallet wallet;

  // Khởi tạo mốc thời gian cần thống kê.
  DateTime beginDate;
  DateTime endDate;
  String dateDescription = 'This month';

  @override
  void initState() {
    // Lấy ngày đầu tiên của tháng và năm hiện tại.
    beginDate = widget.beginDate ??
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    // Lấy ngày cuối cùng của tháng và năm hiện tại.
    endDate = widget.endDate ??
        DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    super.initState();
    wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant ReportScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return DefaultTabController(
      length: 300,
      child: Scaffold(
          backgroundColor: Style.backgroundColor,
          //extendBodyBehindAppBar: true,
          appBar: new AppBar(
            backgroundColor: Style.backgroundColor,
            centerTitle: true,
            elevation: 0,
            leadingWidth: 70,
            leading: GestureDetector(
              onTap: () async {
                buildShowDialog(context, wallet.id);
              },
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    SuperIcon(
                      iconPath: wallet.iconID,
                      size: 25.0,
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: Style.foregroundColor.withOpacity(0.54)),
                  ],
                ),
              ),
            ),
            title: GestureDetector(
              onTap: () async {
                final result = await showCupertinoModalBottomSheet(
                    isDismissible: true,
                    context: context,
                    builder: (context) => TimeRangeSelection(
                        dateDescription: dateDescription,
                        beginDate: beginDate,
                        endDate: endDate));
                if (result != null) {
                  setState(() {
                    dateDescription = result.description;
                    beginDate = result.begin;
                    endDate = result.end;
                  });
                }
              },
              child: Container(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: <Widget>[
                        Text(
                          dateDescription,
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor,
                            fontSize: 14.0,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy').format(beginDate) +
                              " - " +
                              DateFormat('dd/MM/yyyy').format(endDate),
                          style: TextStyle(
                              fontFamily: Style.fontFamily,
                              color: Style.foregroundColor.withOpacity(0.7),
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_drop_down, color: Style.foregroundColor),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Hero(
                tag: 'shareButton',
                child: MaterialButton(
                  child: Icon(Icons.ios_share, color: Style.foregroundColor),
                  onPressed: () async {
                    // Lấy dữ liệu của widget theo key.
                    final bytes1 = await Utils.capture(key1);
                    final bytes2 = await Utils.capture(key2);
                    final bytes3 = await Utils.capture(key3);

                    setState(() {
                      this.bytes1 = bytes1;
                      this.bytes2 = bytes2;
                      this.bytes3 = bytes3;
                    });
                    showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.boxBackgroundColor,
                        context: context,
                        builder: (context) => ShareScreen(
                            bytes1: this.bytes1,
                            bytes2: this.bytes2,
                            bytes3: this.bytes3));
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
                double income = 0;
                double expense = 0;

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
                      if (element.date.compareTo(beginDate) >= 0) {
                        // Tính toán khoản tiền chi.
                        expense += element.amount;
                        // Lọc những danh mục expense từ danh sách transaction hiện có và thêm vào danh sách danh mục expense.
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
                      if (element.date.compareTo(beginDate) >= 0) {
                        // Tính toán khoản tiền thu.
                        income += element.amount;
                        // Lọc những danh mục income từ danh sách transaction hiện có và thêm vào danh sách danh mục income.
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
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        decoration: BoxDecoration(
                            color: Style.backgroundColor,
                            border: Border(
                              bottom: BorderSide(
                                color: Style.foregroundColor.withOpacity(0.24),
                                width: 0.5,
                              ),
                            )),
                        child: WidgetToImage(
                          builder: (key) {
                            // Lấy key để khi ấn share, có thể nhận biết được widget nào để convert sang hình ảnh.
                            this.key1 = key;

                            return Container(
                              color: Style
                                  .backgroundColor, // để lúc export ra không bị transparent.
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Opening balance',
                                              style: TextStyle(
                                                color: Style.foregroundColor
                                                    .withOpacity(0.7),
                                                fontFamily: Style.fontFamily,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            MoneySymbolFormatter(
                                              text: openingBalance,
                                              currencyId: wallet.currencyID,
                                              textStyle: TextStyle(
                                                color: Style.foregroundColor,
                                                fontFamily: Style.fontFamily,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                height: 1.5,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              'Closing balance',
                                              style: TextStyle(
                                                color: Style.foregroundColor
                                                    .withOpacity(0.7),
                                                fontFamily: Style.fontFamily,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15,
                                              ),
                                            ),
                                            MoneySymbolFormatter(
                                              text: closingBalance,
                                              currencyId: wallet.currencyID,
                                              textStyle: TextStyle(
                                                color: Style.foregroundColor,
                                                fontFamily: Style.fontFamily,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                height: 1.5,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    color:
                                        Style.foregroundColor.withOpacity(0.12),
                                    thickness: 2,
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Hero(
                                    tag: 'netIncomeChart',
                                    child: Material(
                                      color: Style.backgroundColor,
                                      child: Column(
                                        children: [
                                          Text('Net Income',
                                              style: TextStyle(
                                                color: Style.foregroundColor
                                                    .withOpacity(0.7),
                                                fontFamily: Style.fontFamily,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                              )),
                                          MoneySymbolFormatter(
                                              text: closingBalance -
                                                  openingBalance,
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
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      childCurrent: this.widget,
                                                      child:
                                                          AnalyticRevenueAndExpenditureScreen(
                                                        currentWallet: wallet,
                                                        beginDate: beginDate,
                                                        endDate: endDate,
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeft));
                                            },
                                            child: Container(
                                              width: 450,
                                              height: 200,
                                              child: BarChartScreen(
                                                  currentList: transactionList,
                                                  beginDate: beginDate,
                                                  endDate: endDate),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: WidgetToImage(
                                  builder: (key) {
                                    // Lấy key để khi ấn share, có thể nhận biết được widget nào để convert sang hình ảnh.
                                    this.key2 = key;

                                    return Container(
                                      color: Style
                                          .backgroundColor, // để lúc export ra không bị transparent.
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Income',
                                            style: TextStyle(
                                              color: Style.foregroundColor
                                                  .withOpacity(0.7),
                                              fontFamily: Style.fontFamily,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          MoneySymbolFormatter(
                                            text: income,
                                            currencyId: wallet.currencyID,
                                            textStyle: TextStyle(
                                              color: Style.incomeColor2,
                                              fontFamily: Style.fontFamily,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 24,
                                              height: 1.5,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      childCurrent: this.widget,
                                                      child:
                                                          AnalyticPieChartScreen(
                                                        currentWallet: wallet,
                                                        type: 'income',
                                                        beginDate: beginDate,
                                                        endDate: endDate,
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeft));
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: PieChartScreen(
                                                  isShowPercent: false,
                                                  currentList: transactionList,
                                                  categoryList:
                                                      incomeCategoryList,
                                                  total: income),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: WidgetToImage(
                                  builder: (key) {
                                    // Lấy key để khi ấn share, có thể nhận biết được widget nào để convert sang hình ảnh.
                                    this.key3 = key;

                                    return Container(
                                      color: Style
                                          .backgroundColor, // để lúc export ra không bị transparent.
                                      child: Column(children: <Widget>[
                                        Text(
                                          'Expense',
                                          style: TextStyle(
                                            color: Style.foregroundColor
                                                .withOpacity(0.7),
                                            fontFamily: Style.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        MoneySymbolFormatter(
                                          text: expense,
                                          currencyId: wallet.currencyID,
                                          textStyle: TextStyle(
                                            color: Style.expenseColor,
                                            fontFamily: Style.fontFamily,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 24,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    childCurrent: this.widget,
                                                    child:
                                                        AnalyticPieChartScreen(
                                                      currentWallet: wallet,
                                                      type: 'expense',
                                                      beginDate: beginDate,
                                                      endDate: endDate,
                                                    ),
                                                    type: PageTransitionType
                                                        .rightToLeft));
                                          },
                                          child: Container(
                                            color: Colors.transparent,
                                            child: PieChartScreen(
                                                isShowPercent: false,
                                                currentList: transactionList,
                                                categoryList:
                                                    expenseCategoryList,
                                                total: expense),
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  // Hàm hiển thị wallet selection.
  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);

    await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Style.boxBackgroundColor,
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: _auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
  }
}
