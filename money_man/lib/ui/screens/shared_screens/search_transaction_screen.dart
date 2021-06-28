import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:intl/intl.dart';

class SearchTransactionScreen extends StatefulWidget {
  final Wallet wallet;
  final String muserSearch;

  const SearchTransactionScreen(
      {Key key, @required this.wallet, this.muserSearch})
      : super(key: key);
  @override
  _SearchTransactionScreenState createState() =>
      _SearchTransactionScreenState();
}

class _SearchTransactionScreenState extends State<SearchTransactionScreen> {
  // pattern mà user search
  String searchPattern;
  // biến control việc loading
  bool isLoading = false;
  // List danh sách transaction được fliter theo ngày order giảm dần theo thời gian
  List<List<MyTransaction>> transactionListSortByDate = [];
  // tổng đầu vào của các transaction trả về
  double totalInCome = 0;
  // tổng đầu ra của các transaction trả về
  double totalOutCome = 0;
  // hiệu của đầu vào vs đầu ra
  double total = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.muserSearch != null) {
      setState(() {
        searchPattern = widget.muserSearch;
      });
    }
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Style.appBarColor,
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(
              Icons.settings,
              color: Style.foregroundColor,
            ),
          )
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Style.boxBackgroundColor.withOpacity(0.8),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: TextFormField(
              initialValue: searchPattern,
              onChanged: (value) => searchPattern = value,
              onEditingComplete: () async {
                // làm bàn phím down
                FocusScope.of(context).unfocus();
                // control cho loading screen xuất hiện
                setState(() {
                  isLoading = true;
                });

                // Lấy danh sách transaction dựa trên searchPattern
                List<MyTransaction> _transactionList =
                    await _firestore.queryTransactionByCategoryOrAmount(
                        searchPattern, widget.wallet);

                // danh sách các date mà _transactionList có
                List<DateTime> listDateOfTrans = [];

                total = 0;
                totalInCome = 0;
                totalOutCome = 0;

                // thực hiện sort theo thứ tự thời gian giảm dần
                _transactionList.sort((a, b) => b.date.compareTo(a.date));
                // Lấy các ngày có trong _transactionList ra cho vào listDateOfTrans
                // tính toán tổng đầu vào, đàu ra, hiệu
                _transactionList.forEach((element) {
                  if (!listDateOfTrans.contains(element.date))
                    listDateOfTrans.add(element.date);
                  if (element.category.type == 'expense' ||
                      element.category.name == 'Repayment' ||
                      element.category.name == 'Loan')
                    totalOutCome += element.amount;
                  else
                    totalInCome += element.amount;
                });
                total = totalInCome - totalOutCome;

                // Tạo thành list trans filter theo thời gian
                transactionListSortByDate.clear();
                listDateOfTrans.forEach((date) {
                  final b = _transactionList
                      .where((element) => element.date.compareTo(date) == 0);
                  transactionListSortByDate.add(b.toList());
                });

                // control loading screen mất => hiện kết quả truy ván ra
                setState(() {
                  isLoading = false;
                });
              },
              style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Style.foregroundColor),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  prefixIconConstraints: BoxConstraints(
                    minHeight: 15,
                    minWidth: 40,
                    maxHeight: 15,
                    maxWidth: 40,
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  prefixIcon: Icon(Icons.search,
                      color: Style.foregroundColor.withOpacity(0.38)),
                  hintText: 'Search by #tag, category, etc',
                  hintStyle: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.24))),
            ),
          ),
          Container(
            child: transactionListSortByDate.length == 0
                ? Text(
                    'No transaction',
                    style: TextStyle(
                      color: Style.foregroundColor.withOpacity(0.24),
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.center,
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: transactionListSortByDate.length,
                    itemBuilder: (context, xIndex) {
                      double totalAmountInDay = 0;
                      transactionListSortByDate[xIndex].forEach((element) {
                        if (element.category.type == 'expense' ||
                            element.category.name == 'Repayment' ||
                            element.category.name == 'Loan')
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
                          : buildBottom(transactionListSortByDate, xIndex,
                              totalAmountInDay);
                    }),
          ),
        ],
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
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            transaction: transListSortByDate[xIndex][yIndex],
                            wallet: widget.wallet,
                          ),
                          type: PageTransitionType.rightToLeft));
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
                                  ))),
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
                                //digit: '+',
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
                                //digit: '-',
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
