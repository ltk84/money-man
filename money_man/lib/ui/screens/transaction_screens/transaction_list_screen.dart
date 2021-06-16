import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  final Wallet wallet;
  final String muserSearch;

  const TransactionListScreen(
      {Key key, @required this.wallet, this.muserSearch})
      : super(key: key);
  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
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
      backgroundColor: Color(0xFF111111),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[900],
        leading: CloseButton(),
        // leading: IconButton(
        //   icon: Icon(Icons.close),
        //   onPressed: () => Navigator.pop(context),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Icon(Icons.settings),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[900].withOpacity(0.8),
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
                    await _firestore.queryTransationByCategoryOrAmount(
                        searchPattern, widget.wallet);

                // danh sách các date mà _transactionList có
                List<DateTime> listDateOfTrans = [];

                // thực hiện sort theo thứ tự thời gian giảm dần
                _transactionList.sort((a, b) => b.date.compareTo(a.date));
                // Lấy các ngày có trong _transactionList ra cho vào listDateOfTrans
                // tính toán tổng đầu vào, đàu ra, hiệu
                _transactionList.forEach((element) {
                  if (!listDateOfTrans.contains(element.date))
                    listDateOfTrans.add(element.date);
                  if (element.category.type == 'expense')
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
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
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
                  prefixIcon: Icon(Icons.search, color: Colors.white38),
                  hintText: 'Search by #tag, category, etc',
                  hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white24)),
            ),
          ),
          Container(
            child: transactionListSortByDate.length == 0
                ? Text(
                    'Nothing',
                    style: TextStyle(color: Colors.white),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
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
                child: MoneySymbolFormatter(
                  text: totalAmountInDay,
                  currencyId: widget.wallet.currencyID,
                  textAlign: TextAlign.end,
                  textStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
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
                onTap: () {
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
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                              : Text(
                                  transListSortByDate[xIndex][yIndex]
                                          .category
                                          .name +
                                      "\n🌴",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))),
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
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                                digit: '+',
                              )
                            : MoneySymbolFormatter(
                                text:
                                    transListSortByDate[xIndex][yIndex].amount,
                                currencyId: widget.wallet.currencyID,
                                textAlign: TextAlign.end,
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600]),
                                digit: '-',
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
                  Text('Inflow', style: TextStyle(color: Colors.grey[500])),
                  MoneySymbolFormatter(
                    text: totalInCome,
                    currencyId: widget.wallet.currencyID,
                    textStyle: TextStyle(color: Colors.white),
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
                    Text('Outflow', style: TextStyle(color: Colors.grey[500])),
                    MoneySymbolFormatter(
                      text: totalOutCome,
                      currencyId: widget.wallet.currencyID,
                      textStyle: TextStyle(color: Colors.white),
                      digit: '-',
                    ),
                  ]),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    MoneySymbolFormatter(
                      text: total,
                      currencyId: widget.wallet.currencyID,
                      textStyle: TextStyle(color: Colors.white),
                    ),
                  ]),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View report for this period',
                style: TextStyle(color: Color(0xff36D1B5)),
              ),
              style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            )
          ])),
    );
  }
}
