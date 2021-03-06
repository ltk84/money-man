import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ReportListTransaction extends StatefulWidget {
  final DateTime beginDate;
  final DateTime endDate;
  final Wallet currentWallet;
  final double totalMoney;
  final bool viewByCategory;
  final MyCategory category;
  const ReportListTransaction(
      {Key key,
      this.beginDate,
      this.endDate,
      this.totalMoney,
      this.currentWallet,
      this.viewByCategory,
      this.category})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ReportListTransaction();
}

class _ReportListTransaction extends State<ReportListTransaction> {
  // Biến để check xem view transaction list theo date hay category.
  bool viewByCategory;

  // Danh mục.
  MyCategory category;

  // sort theo date giảm dần
  DateTime beginDate;
  DateTime endDate;
  double total;
  double totalMoney;

  @override
  void initState() {
    super.initState();
    category = widget.category;
    viewByCategory = widget.viewByCategory;
    beginDate = widget.beginDate;
    endDate = widget.endDate;
    total = 0;
  }

  // Hàm kiểm tra xem ngày b có lớn hơn ngày a hay không.
  bool compareDate(DateTime a, DateTime b) {
    if (a.year < b.year) return true;
    if (a.year == b.year && a.month < b.month) return true;
    if (a.year == b.year && a.month == b.month && a.day <= b.day) return true;
    return false;
  }

  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);

    // Chuỗi mô tả khoảng thời gian.
    String dateDescription = DateFormat('dd/MM/yyyy').format(beginDate) +
        " - " +
        DateFormat('dd/MM/yyyy').format(endDate);

    // Chuỗi mô tả tên danh mục.
    String categoryDescription = category != null ? category.name : '';

    return Scaffold(
        backgroundColor: Style.backgroundColor,
        appBar: new AppBar(
          backgroundColor: Style.backgroundColor,
          centerTitle: true,
          elevation: 0,
          leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Hero(
              tag: 'alo',
              child: Icon(Icons.arrow_back_ios, color: Style.foregroundColor),
            ),
          ),
          title: Hero(
            tag: viewByCategory
                ? categoryDescription
                : beginDate.day.toString() + '-' + endDate.day.toString(),
            child: Material(
              color: Colors.transparent,
              child:
                  Text(viewByCategory ? categoryDescription : dateDescription,
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                        color: Style.foregroundColor,
                      )),
            ),
          ),
        ),
        body: StreamBuilder<Object>(
            stream: firestore.transactionStream(widget.currentWallet, 'full'),
            builder: (context, snapshot) {
              List<MyTransaction> transactionList = snapshot.data ?? [];

              // list các list transaction đã lọc
              List<List<MyTransaction>> transactionListSorted = [];

              // list những ngày trong các transaction đã lọc
              List<DateTime> dateInChoosenTime = [];
              // list những category trong các transaction đã lọc
              List<String> categoryInChoosenTime = [];

              // Sort transaction List giam dan.
              transactionList = transactionList
                  .where((element) =>
                      compareDate(element.date, endDate) &&
                      compareDate(beginDate, element.date) &&
                      element.category.type != 'debt & loan')
                  .toList();
              transactionList.sort((a, b) => b.date.compareTo(a.date));

              // trường hợp hiển thị category
              if (viewByCategory) {
                transactionList.forEach((element) {
                  // lấy các category trong transaction đã lọc
                  if (category != null &&
                      element.category.name == category.name) {
                    if (!categoryInChoosenTime.contains(element.category.name))
                      categoryInChoosenTime.add(element.category.name);
                  }
                });

                // lấy các transaction ra theo từng category
                categoryInChoosenTime.forEach((cate) {
                  final b = transactionList.where(
                      (element) => element.category.name.compareTo(cate) == 0);
                  transactionListSorted.add(b.toList());
                });
              } else {
                // trường hợp hiển thị theo date (tương tự)
                transactionList.forEach((element) {
                  if (!dateInChoosenTime.contains(element.date))
                    dateInChoosenTime.add(element.date);
                });
                dateInChoosenTime.forEach((date) {
                  final b = transactionList
                      .where((element) => element.date.compareTo(date) == 0);
                  b.forEach((element) {
                    if (element.category.type == "income") {
                      total += element.amount;
                    } else if (element.category.type == "expense") {
                      total -= element.amount;
                    }
                  });
                  transactionListSorted.add(b.toList());
                });
              }

              return viewByCategory
                  ? buildDisplayTransactionByCategory(
                      transactionListSorted, total)
                  : buildDisplayTransactionByDate(transactionListSorted, total);
            }));
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate, double total) {
    return Container(
      color: Style.backgroundColor,
      child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            // tính toán lượng amount trong ngày
            transactionListSortByDate[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else if (element.category.type == 'income')
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(transactionListSortByDate, total),
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  Container buildDisplayTransactionByCategory(
      List<List<MyTransaction>> transactionListSortByCategory, double total) {
    print('build function');
    return Container(
      color: Style.backgroundColor,
      child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: transactionListSortByCategory.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            // tính toán lượng amount trong 1 category
            transactionListSortByCategory[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else if (element.category.type == 'income')
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(transactionListSortByCategory, total),
                      buildBottomViewByCategory(transactionListSortByCategory,
                          xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByCategory(
                    transactionListSortByCategory, xIndex, totalAmountInDay);
          }),
    );
  }

  Widget buildHeader(List<List<MyTransaction>> transListSorted, double total) {
    totalMoney = 0;
    double totalExpense = 0;
    double totalIncome = 0;

    // Tính toán tổng thu nhập và tổng chi tiêu.
    transListSorted.forEach((element) {
      element.forEach((e) {
        if (e.category.type == "income") {
          //_totalMoney += e.amount;
          totalIncome += e.amount;
        } else if (e.category.type == 'expense')
          //_totalMoney -= e.amount;
          totalExpense += e.amount;
      });
    });

    // Tính toán thu nhập ròng.
    totalMoney = totalIncome - totalExpense;

    return StickyHeader(
      header: SizedBox(height: 0),
      content: Container(
          decoration: BoxDecoration(
              color: Style.boxBackgroundColor,
              border: Border(
                  bottom: BorderSide(
                color: Style.backgroundColor,
                width: 1.0,
              ))),
          padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Overview',
                    style: TextStyle(
                      color: Style.foregroundColor,
                      fontFamily: Style.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(
                  height: 5,
                ),
                if (!viewByCategory ||
                    (category != null && category.type == 'income'))
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Income',
                            style: TextStyle(
                              color: Style.foregroundColor.withOpacity(0.54),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: Style.fontFamily,
                            )),
                        MoneySymbolFormatter(
                            text: totalIncome,
                            currencyId: widget.currentWallet.currencyID,
                            textStyle: TextStyle(
                              color: Style.incomeColor2,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: Style.fontFamily,
                            )),
                      ]),
                SizedBox(
                  height: 2,
                ),
                if (!viewByCategory ||
                    (category != null && category.type == 'expense'))
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Expense',
                            style: TextStyle(
                              color: Style.foregroundColor.withOpacity(0.54),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: Style.fontFamily,
                            )),
                        MoneySymbolFormatter(
                            text: totalExpense,
                            currencyId: widget.currentWallet.currencyID,
                            textStyle: TextStyle(
                              color: Style.expenseColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              fontFamily: Style.fontFamily,
                            )),
                      ]),
                if (!viewByCategory)
                  Divider(
                    //height: 20,
                    thickness: 1,
                    color: Style.foregroundColor.withOpacity(0.12),
                  ),
                if (!viewByCategory)
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        MoneySymbolFormatter(
                            digit: totalMoney >= 0 ? '+' : '',
                            text: totalMoney,
                            currencyId: widget.currentWallet.currencyID,
                            textStyle: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: Style.fontFamily,
                            )),
                      ]),
              ])),
    );
  }

  Widget buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
    totalAmountInDay = 0;
    transListSortByDate[xIndex].forEach((element) {
      element.category.type == 'income'
          ? totalAmountInDay += element.amount
          : totalAmountInDay -= element.amount;
    });
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ),
              top: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ))),
      child: StickyHeader(
        header: Container(
          color: Style.boxBackgroundColor,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                    DateFormat("dd")
                        .format(transListSortByDate[xIndex][0].date),
                    style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 30.0,
                        color: Style.foregroundColor)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Text(
                    DateFormat("EEEE")
                            .format(transListSortByDate[xIndex][0].date)
                            .toString() +
                        '\n' +
                        DateFormat("MMMM yyyy")
                            .format(transListSortByDate[xIndex][0].date)
                            .toString(),
                    // 'hello',
                    style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Style.foregroundColor.withOpacity(0.54))),
              ),
              Expanded(
                child: MoneySymbolFormatter(
                  digit: totalAmountInDay >= 0 ? '+' : '',
                  text: totalAmountInDay,
                  currencyId: widget.currentWallet.currencyID,
                  textAlign: TextAlign.end,
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: Style.foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        content: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transListSortByDate[xIndex].length,
            itemBuilder: (context, yIndex) {
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            currentTransaction: transListSortByDate[xIndex]
                                [yIndex],
                            wallet: widget.currentWallet,
                          ),
                          type: PageTransitionType.rightToLeft));
                  setState(() {});
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                          child: SuperIcon(
                            iconPath: transListSortByDate[xIndex][yIndex]
                                .category
                                .iconID,
                            size: 30,
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                            transListSortByDate[xIndex][yIndex].category.name,
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Style.foregroundColor,
                            )),
                      ),
                      Expanded(
                        child: MoneySymbolFormatter(
                            text: transListSortByDate[xIndex][yIndex].amount,
                            currencyId: widget.currentWallet.currencyID,
                            textAlign: TextAlign.end,
                            textStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: transListSortByDate[xIndex][yIndex]
                                            .category
                                            .type ==
                                        'income'
                                    ? Style.incomeColor2
                                    : Style.expenseColor)),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Container buildBottomViewByCategory(
      List<List<MyTransaction>> transListSortByCategory,
      int xIndex,
      double totalAmountInDay) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
          color: Style.boxBackgroundColor,
          border: Border(
              bottom: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ),
              top: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ))),
      child: StickyHeader(
        header: Container(
          color: Style.boxBackgroundColor,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                  child: SuperIcon(
                    iconPath:
                        transListSortByCategory[xIndex][0].category.iconID,
                    size: 30.0,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Text(
                    transListSortByCategory[xIndex][0].category.name +
                        '\n' +
                        transListSortByCategory[xIndex].length.toString() +
                        ' transactions',
                    // 'hello',
                    style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Style.foregroundColor.withOpacity(0.54))),
              ),
              Expanded(
                child: MoneySymbolFormatter(
                  digit: totalAmountInDay >= 0 ? '+' : '',
                  text: totalAmountInDay,
                  currencyId: widget.currentWallet.currencyID,
                  textAlign: TextAlign.end,
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                    color: Style.foregroundColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        content: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transListSortByCategory[xIndex].length,
            itemBuilder: (context, yIndex) {
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            currentTransaction: transListSortByCategory[xIndex]
                                [yIndex],
                            wallet: widget.currentWallet,
                          ),
                          type: PageTransitionType.rightToLeft));
                  setState(() {});
                },
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Text(
                            DateFormat("dd").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 30.0,
                                color: Style.foregroundColor)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                            DateFormat("MMMM yyyy, EEEE").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                              color: Style.foregroundColor,
                            )),
                      ),
                      Expanded(
                        child: transListSortByCategory[xIndex][yIndex]
                                        .category
                                        .type ==
                                    'income' ||
                                transListSortByCategory[xIndex][yIndex]
                                        .category
                                        .name ==
                                    'Debt' ||
                                transListSortByCategory[xIndex][yIndex]
                                        .category
                                        .name ==
                                    'Debt Collection'
                            ? MoneySymbolFormatter(
                                text: transListSortByCategory[xIndex][yIndex]
                                    .amount,
                                currencyId: widget.currentWallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Style.incomeColor2),
                              )
                            : MoneySymbolFormatter(
                                text: transListSortByCategory[xIndex][yIndex]
                                    .amount,
                                currencyId: widget.currentWallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Style.expenseColor),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
