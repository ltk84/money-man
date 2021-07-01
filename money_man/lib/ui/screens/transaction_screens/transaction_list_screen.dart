import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail_screen.dart';

import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  final Wallet wallet;
  final String transactionId;

  TransactionListScreen({Key key, @required this.wallet, this.transactionId})
      : super(key: key);
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  // biến control việc loading
  bool isLoading = false;
  // List danh sách transaction được fliter theo ngày order giảm dần theo thời gian
  List<List<MyTransaction>> transactionListSortByDate = [];
  // tổng đầu vào của các transaction trả về
  double totalInCome;
  // tổng đầu ra của các transaction trả về
  double totalOutCome;
  // hiệu của đầu vào vs đầu ra
  double total;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var list = await setUp();
      setState(() {
        transactionListSortByDate = list;
      });
    });
  }

  Future<List<List<MyTransaction>>> setUp() async {
    total = 0;
    totalInCome = 0;
    totalOutCome = 0;
    final _firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);

    // Lấy danh sách transaction dựa trên searchPattern
    List<MyTransaction> _transactionList = await _firestore
        .searchTransactionInDebtLoan(widget.transactionId, widget.wallet.id);

    if (_transactionList.isEmpty) return [];
    print(_transactionList.length);

    // danh sách các date mà _transactionList có
    List<DateTime> listDateOfTrans = [];

    // if (_transactionList.length > 1)
    // thực hiện sort theo thứ tự thời gian giảm dần
    _transactionList.sort((a, b) => b.date.compareTo(a.date));
    // Lấy các ngày có trong _transactionList ra cho vào listDateOfTrans
    // tính toán tổng đầu vào, đàu ra, hiệu
    _transactionList.forEach((element) {
      if (!listDateOfTrans.contains(element.date))
        listDateOfTrans.add(element.date);
      if (element.category.name == 'Repayment')
        totalOutCome += element.amount;
      else
        totalInCome += element.amount;
    });
    total = totalInCome - totalOutCome;

    // Tạo thành list trans filter theo thời gian
    List<List<MyTransaction>> transactionListSortByDate = [];
    listDateOfTrans.forEach((date) {
      final b = _transactionList
          .where((element) => element.date.compareTo(date) == 0);
      transactionListSortByDate.add(b.toList());
    });

    return transactionListSortByDate;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      //backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor2,
        leading: Hero(
          tag: 'backButton',
          child: MaterialButton(
            onPressed: () async {
              MyTransaction newTransIfChange = await _firestore
                  .getTransactionByID(widget.transactionId, widget.wallet.id);
              Navigator.pop(context, newTransIfChange);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Style.foregroundColor,
            ),
          ),
        ),
        title: Hero(
          tag: 'title',
          child: Material(
            color: Colors.transparent,
            child: Text('Transaction List',
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: Style.fontFamily,
                    fontSize: 18.0)),
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: transactionListSortByDate.length == 0
            ? Container(
                color: Style.backgroundColor1,
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
                      'There are no transactions',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.24),
                      ),
                    ),
                  ],
                ))
            : ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                //shrinkWrap: true,
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
                            buildHeader(totalInCome, totalOutCome, total),
                            buildBottom(transactionListSortByDate, xIndex,
                                totalAmountInDay)
                          ],
                        )
                      : buildBottom(
                          transactionListSortByDate, xIndex, totalAmountInDay);
                }),
      ),
    );
  }

  Container buildBottom(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
    print('build bottom by date');
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
                  currencyId: widget.wallet.currencyID,
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
                            wallet: widget.wallet,
                          ),
                          type: PageTransitionType.rightToLeft));

                  var newList = await setUp();
                  setState(() {
                    transactionListSortByDate = newList;
                  });
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
                          size: 35.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: (transListSortByDate[xIndex][yIndex].eventID ==
                                    "" ||
                                transListSortByDate[xIndex][yIndex].eventID ==
                                    null)
                            ? Text(
                                transListSortByDate[xIndex][yIndex]
                                    .category
                                    .name,
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                  color: Style.foregroundColor,
                                ))
                            : Text(
                                transListSortByDate[xIndex][yIndex]
                                        .category
                                        .name +
                                    "\n🌴",
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.0,
                                  color: Style.foregroundColor,
                                )),
                      ),
                      Expanded(
                        child: transListSortByDate[xIndex][yIndex]
                                        .category
                                        .type ==
                                    'income' ||
                                transListSortByDate[xIndex][yIndex]
                                        .category
                                        .name ==
                                    'Debt' ||
                                transListSortByDate[xIndex][yIndex]
                                        .category
                                        .name ==
                                    'Debt Collection'
                            ? MoneySymbolFormatter(
                                text:
                                    transListSortByDate[xIndex][yIndex].amount,
                                currencyId: widget.wallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Style.incomeColor2),
                                //digit: _digit,
                              )
                            : MoneySymbolFormatter(
                                text:
                                    transListSortByDate[xIndex][yIndex].amount,
                                currencyId: widget.wallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.0,
                                    color: Style.expenseColor),
                                //digit: _digit,
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

  StickyHeader buildHeader(
      double totalInCome, double totalOutCome, double total) {
    print('build header');
    return StickyHeader(
      header: SizedBox(height: 0),
      content: Container(
          decoration: BoxDecoration(
              color: Style.boxBackgroundColor,
              border: Border(
                  bottom: BorderSide(
                color: Style.foregroundColor.withOpacity(0.12),
                width: 0.5,
              ))),
          padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Inflow',
                      style: TextStyle(
                        color: Style.foregroundColor.withOpacity(0.54),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: Style.fontFamily,
                      )),
                  MoneySymbolFormatter(
                    text: totalInCome,
                    currencyId: widget.wallet.currencyID,
                    textStyle: TextStyle(
                      color: Style.foregroundColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: Style.fontFamily,
                    ),
                    digit: '+',
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Outflow',
                        style: TextStyle(
                          color: Style.foregroundColor.withOpacity(0.54),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: Style.fontFamily,
                        )),
                    MoneySymbolFormatter(
                      text: totalOutCome,
                      currencyId: widget.wallet.currencyID,
                      textStyle: TextStyle(
                        color: Style.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Style.fontFamily,
                      ),
                      digit: '-',
                    ),
                  ]),
            ),
            Divider(
              //height: 20,
              thickness: 1,
              color: Style.foregroundColor.withOpacity(0.12),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    MoneySymbolFormatter(
                      digit: total >= 0 ? '+' : '',
                      text: total,
                      currencyId: widget.wallet.currencyID,
                      textStyle: TextStyle(
                        color: Style.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: Style.fontFamily,
                      ),
                    ),
                  ]),
            ),
          ])),
    );
  }
}
