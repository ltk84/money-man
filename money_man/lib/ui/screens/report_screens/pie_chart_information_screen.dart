import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/report_screens/report_list_transaction_in_time.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PieChartInformationScreen extends StatefulWidget {
  final List<MyTransaction> currentList;
  final List<MyCategory> categoryList;
  final Wallet currentWallet;
  final Color color;
  PieChartInformationScreen(
      {Key key,
      @required this.currentList,
      @required this.categoryList,
      @required this.color,
      this.currentWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _PieChartInformationScreen();
}

class _PieChartInformationScreen extends State<PieChartInformationScreen> {
  // Biến để lấy vị trí đã chạm vào pie chart.
  int touchedIndex = -1;

  // Danh sách transactions.
  List<MyTransaction> transactionList;

  // Danh sách transactions của mỗi danh mục.
  List<List<MyTransaction>> listTransactionOfEachCategory = [];

  // Danh sách danh mục.
  List<MyCategory> categoryList;


  // Danh sách tổng số tiền của từng danh mục.
  List<double> info = [];

  // Màu để hỗ trợ cho việc phân biệt Expense hay Income chart.
  Color color;

  // Danh sách danh mục thực tế sẽ tính toán để đưa lên chart.
  List<MyCategory> listCategoryReport = [];

  // Hàm để kiểm tra xem danh mục hiện tại có trong danh sách danh mục hay không.
  bool isContained(MyCategory currentCategory, List<MyCategory> categoryList) {
    if (categoryList.isEmpty) return false;
    int n = 0;
    categoryList.forEach((element) {
      if (element.name == currentCategory.name) n += 1;
    });
    if (n == 1) return true;
    return false;
  }

  // Hàm lấy thông tin để đưa vào danh sách thông tin.
  void generateData(List<MyCategory> categoryList,
      List<MyTransaction> transactionList) {
    // Duyệt danh sách danh mục ban đầu để lọc danh mục vào danh sách danh mục thức tế.
    // Việc lọc này là để tránh việc các danh mục bị lặp lại trong danh sách danh mục.
    categoryList.forEach((element) {
      if (!isContained(element, listCategoryReport)) {
        listCategoryReport.add(element);
      }
    });

    // Tính toán tổng số tiền của từng danh mục vào thêm vào danh sách thông tin.
    listCategoryReport.forEach((element) {
      info.add(calculateByCategory(element, transactionList));
    });
  }

  // Hàm tính toán tổng số tiền của danh mục và thêm danh sách các giao dịch thuộc danh mục vào danh sách listTransactionOfEachCategory được khai báo khi khởi tạo.
  double calculateByCategory(MyCategory category,
      List<MyTransaction> transactionList) {

    // Tính toán tổng số tiền của danh mục.
    double sum = 0;
    transactionList.forEach((element) {
      if (element.category.name == category.name) {
        sum += element.amount;
      }
    });

    // Thêm danh sách các giao dịch thuộc danh mục vào danh sách listTransactionOfEachCategory.
    final b = transactionList
        .where((element) => element.category.name == category.name);
    listTransactionOfEachCategory.add(b.toList());
    listTransactionOfEachCategory[listTransactionOfEachCategory.length - 1]
        .sort((a, b) => b.date.compareTo(a.date));
    return sum;
  }

  @override
  void initState() {
    // Khởi tạo giá trị biến từ tham số đầu vào.
    transactionList = widget.currentList;
    transactionList.sort((a, b) => b.date.compareTo(a.date));
    categoryList = widget.categoryList;
    color = widget.color;

    // Tính toán cái thông tin.
    generateData(categoryList, transactionList);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PieChartInformationScreen oldWidget) {
    // Khởi tạo giá trị biến từ tham số đầu vào.
    transactionList = widget.currentList ?? [];
    transactionList.sort((a, b) => b.date.compareTo(a.date));
    categoryList = widget.categoryList ?? [];
    color = widget.color;
    listTransactionOfEachCategory = [];
    info = [];
    listCategoryReport = [];

    // Tính toán cái thông tin.
    generateData(categoryList, transactionList);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<Object>(
        stream: firestore.transactionStream(widget.currentWallet, 50),
        builder: (context, snapshot) {
          return Container(
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
                  border: Border(
                      bottom: BorderSide(
                        color: Style.foregroundColor.withOpacity(0.12),
                        width: 1,
                      )
                  )
              ),
              padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5),
              child: listCategoryReport.length > 0 ? Column(
                children: List.generate(
                    listCategoryReport.length,
                        (index) =>
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    childCurrent: this.widget,
                                    child: ReportListTransaction(
                                        endDate: listTransactionOfEachCategory[index]
                                        [0]
                                            .date,
                                        beginDate: listTransactionOfEachCategory[
                                        index][
                                        listTransactionOfEachCategory[index]
                                            .length -
                                            1]
                                            .date,
                                        totalMoney:
                                        listTransactionOfEachCategory[index][0]
                                            .category
                                            .type ==
                                            'expense'
                                            ? -info[index]
                                            : info[index],
                                        currentWallet: widget.currentWallet,
                                        viewByCategory: true,
                                        category: listCategoryReport[index]
                                    ),
                                    type: PageTransitionType.rightToLeft));
                          },
                          child: Container(
                            color: Colors.transparent, // Khắc phục lỗi không ấn được ở giữa Row khi dùng space between và gesture detector.
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SuperIcon(
                                  iconPath: listCategoryReport[index].iconID,
                                  size: 30,
                                ),
                                SizedBox(width: 15,),
                                Expanded(
                                  child: Hero(
                                    tag: listCategoryReport[index].name,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(listCategoryReport[index].name,
                                          style: TextStyle(
                                            fontFamily: Style.fontFamily,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.0,
                                            color: Style.foregroundColor,
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    MoneySymbolFormatter(
                                        text: info[index],
                                        currencyId: widget.currentWallet
                                            .currencyID,
                                        textStyle: TextStyle(
                                            fontFamily: Style.fontFamily,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0,
                                            color: color)
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                ),
              ) : Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text(
                    'No transaction',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.24),
                    ),
                  )
              )
          );
        });
  }
}
