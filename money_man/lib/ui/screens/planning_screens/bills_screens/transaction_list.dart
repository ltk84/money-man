import 'dart:core';
import 'dart:ui';
import 'package:currency_picker/currency_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class BillTransactionList extends StatefulWidget {
  final Wallet currentWallet;
  final List<String> transactionListID;
  const BillTransactionList(
      {Key key,
        this.transactionListID,
        this.currentWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => BillTransactionListState();
}

class BillTransactionListState extends State<BillTransactionList> {
  List<String> _transactionListID;

  String currencySymbol;

  @override
  void initState() {
    super.initState();
    currencySymbol = CurrencyService().findByCode(widget.currentWallet.currencyID).symbol;
    _transactionListID = widget.transactionListID ?? [];
  }

  @override
  void didUpdateWidget(covariant BillTransactionList oldWidget) {
    _transactionListID = widget.transactionListID ?? [];
  }

  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        backgroundColor: Colors.grey[900].withOpacity(0.2),
        elevation: 0.0,
        leading: Hero(
          tag: 'billToDetail_backBtn',
          child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_outlined,
                color: Colors.white,
              )),
        ),
        title: Hero(
          tag: 'billToDetail_title',
          child: Text('Transaction List',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
        ),
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: AnimatedOpacity(
            opacity: 1,
            duration: Duration(milliseconds: 0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 500, sigmaY: 500, tileMode: TileMode.values[0]),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 1),
                  //child: Container(
                  //color: Colors.transparent,
                  color: Colors.transparent
                //),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<Object>(
        stream: _firestore.transactionStream(widget.currentWallet, 'full'),
        builder: (context, snapshot) {
          List<MyTransaction> listTransactions = snapshot.data ?? [];

          print("test 1: " + listTransactions.length.toString());
          // Lấy danh sách transaction từ transaction ID của bill.
          List<MyTransaction> billTransactions = listTransactions.where((element) => _transactionListID.contains(element.id)).toList();


          print("test 2: " + billTransactions.length.toString());
          List<List<MyTransaction>> transactionListSorted = [];
          List<DateTime> dateInChoosenTime = [];
          double total = 0;

          billTransactions.sort((a, b) => b.date.compareTo(a.date));
          billTransactions.forEach((element) {
            if (!dateInChoosenTime.contains(element.date))
              dateInChoosenTime.add(element.date);
            total += element.amount;
          });
          dateInChoosenTime.forEach((date) {
            final b = billTransactions
                .where((element) => element.date.compareTo(date) == 0);
            transactionListSorted.add(b.toList());
          });

          if (transactionListSorted.length == 0) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  'No transaction',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                )
              );
          } else {
            return buildDisplayTransactionByDate(transactionListSorted, total);
          }
        }
      ),
    );
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate, double total) {
    return Container(
      height: double.infinity,
      color: Colors.black,
      child: ListView.builder(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          //primary: false,
          shrinkWrap: true,
          // itemCount: TRANSACTION_DATA.length + 1,
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {
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

  StickyHeader buildHeader(double total) {
    return StickyHeader(
      header: SizedBox(height: 0),
      content: Container(
          decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
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
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      width: 10,
                      height: 10,
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0,
                      height: 10,
                    ),
                    ColoredBox(color: Colors.black87)
                  ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 15),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Expense',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                        )
                    ),
                    Text('$currencySymbol $total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        )),
                  ]),
            ),
          ])),
    );
  }

  Container buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      decoration: BoxDecoration(
          color: Colors.grey[900],
          border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              top: BorderSide(
                color: Colors.black,
                width: 1.0,
              ))),
      child: StickyHeader(
        header: Container(
          color: Colors.grey[900],
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Text(
                    DateFormat("dd")
                        .format(transListSortByDate[xIndex][0].date),
                    style: TextStyle(fontSize: 30.0, color: Colors.white)),
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
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
              ),
              Expanded(
                child: Text(
                    currencySymbol
                    + ' ' +
                    totalAmountInDay.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
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
                  setState(() { });
                },
                child: Container(
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
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                        child: Text(
                            currencySymbol
                                + ' ' +
                            transListSortByDate[xIndex][yIndex]
                                .amount
                                .toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transListSortByDate[xIndex][yIndex]
                                    .category
                                    .type ==
                                    'income'
                                    ? Colors.green
                                    : Colors.red[600])),
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
