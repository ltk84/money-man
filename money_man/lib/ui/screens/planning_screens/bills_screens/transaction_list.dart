import 'dart:core';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BillTransactionList extends StatefulWidget {
  final Wallet currentWallet;
  final List<String> transactionListID;
  const BillTransactionList(
      {Key key, this.transactionListID, this.currentWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => BillTransactionListState();
}

class BillTransactionListState extends State<BillTransactionList> {
  // Biến lưu danh dách id của các giao dịch.
  List<String> transactionListID;

  @override
  void initState() {
    super.initState();

    // Gán giá trị mặc định cho danh sách id các giao dịch.
    transactionListID = widget.transactionListID ?? [];
  }

  @override
  void didUpdateWidget(covariant BillTransactionList oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Gán giá trị mặc định cho danh sách id các giao dịch.
    transactionListID = widget.transactionListID ?? [];
  }

  Widget build(BuildContext context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        backgroundColor: Style.appBarColor,
        elevation: 0.0,
        leading: Hero(
          tag: 'billToDetail_backBtn',
          child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Style.backIcon,
                color: Style.foregroundColor,
              )),
        ),
        title: Hero(
          tag: 'billToDetail_title',
          child: Text('Transaction List',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Style.foregroundColor,
              )),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Object>(
          stream: firestore.transactionStream(widget.currentWallet, 'full'),
          builder: (context, snapshot) {
            // Danh sách tất cả các giao dịch thuộc ví.
            List<MyTransaction> listTransactions = snapshot.data ?? [];

            print("test 1: " + listTransactions.length.toString());

            // Lấy danh sách transaction từ transaction ID của bill (dựa vào danh sách tất cả các giao dịch ở trên).
            List<MyTransaction> billTransactions = listTransactions
                .where((element) => transactionListID.contains(element.id))
                .toList();

            print("test 2: " + billTransactions.length.toString());

            // Danh sách các giao dịch đã sắp xếp.
            List<List<MyTransaction>> transactionListSorted = [];

            // Danh sách các thời gian giao dịch.
            List<DateTime> dateInChoosenTime = [];

            // Biến để tính tổng số tiền trong danh sách giao dịch thuộc hóa đơn.
            double total = 0;

            // Sắp xếp danh sách giao dịch thuộc hóa đơn theo thời gian giảm dần.
            billTransactions.sort((a, b) => b.date.compareTo(a.date));

            // Tính toán tổng số tiền trong danh sách giao dịch của hóa đơn.
            // Đồng thời lưu các ngày giao dịch thuộc hóa đơn vào danh sách thời gian giao dịch.
            billTransactions.forEach((element) {
              if (!dateInChoosenTime.contains(element.date))
                dateInChoosenTime.add(element.date);
              total += element.amount;
            });

            // Thêm giao dịch có trong danh sách giao dịch thuộc hóa đơn theo ngày trong danh sách thời gian giao dịch vào trong danh sách giao dịch đã sắp xếp.
            dateInChoosenTime.forEach((date) {
              final b = billTransactions
                  .where((element) => element.date.compareTo(date) == 0);
              transactionListSorted.add(b.toList());
            });

            if (transactionListSorted.length == 0) {
              return Container(
                  color: Style.backgroundColor,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        color: Style.foregroundColor.withOpacity(0.12),
                        size: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'No transaction',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Style.foregroundColor.withOpacity(0.24),
                        ),
                      ),
                    ],
                  ));
            } else {
              return buildDisplayTransactionByDate(
                  transactionListSorted, total);
            }
          }),
    );
  }

  // Display screen transaction list.
  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate, double total) {
    return Container(
      height: double.infinity,
      color: Style.backgroundColor,
      child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {

            // Tính tổng số tiền trong ngày.
            double totalAmountInDay = 0;
            transactionListSortByDate[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(total),
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  // Build thông tin chung.
  StickyHeader buildHeader(double total) {
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
          padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Overview',
                        style: TextStyle(
                          color: Style.foregroundColor,
                          fontFamily: Style.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Divider(
                      color: Style.backgroundColor,
                      thickness: 1.0,
                      height: 10,
                    ),
                    ColoredBox(color: Style.backgroundColor.withOpacity(0.87))
                  ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 15),
              child: Row(
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
                      text: total,
                      currencyId: widget.currentWallet.currencyID,
                      textStyle: TextStyle(
                        color: Style.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Style.fontFamily,
                      ),
                      digit: '-',
                    )
                  ]),
            ),
          ])),
    );
  }

  // Build thông tin các giao dịch.
  Container buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
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
                            transaction: transListSortByDate[xIndex][yIndex],
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
