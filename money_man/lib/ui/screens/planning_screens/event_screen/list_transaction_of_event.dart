import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

// HIển thị danh sách các event á
class EventListTransactionScreen extends StatefulWidget {
  Event currentEvent; // truyền vào event hiện tại
  Wallet eventWallet; // ví của event đó
  EventListTransactionScreen({Key key, this.currentEvent, this.eventWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EventListTransactionScreen();
  }
}

class _EventListTransactionScreen extends State<EventListTransactionScreen>
    with TickerProviderStateMixin {
  // event hiện tại
  Event _currentEvent;
  // ví của event đó
  Wallet _eventWallet;
  // Danh sách các ngày có giao dịch
  List<DateTime> dateInChoosenTime = [];

  @override
  void initState() {
    // Khởi tạo giá trị các biến state
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EventListTransactionScreen oldWidget) {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // Tham chiếu đến các hàm của firebase
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<Object>(
        // Stream lấy tất cả các transaction
        stream: _firestore.transactionStream(_eventWallet, 'full'),
        builder: (context, snapshot) {
          double total = 0;
          // Danh sách chứa tất cả transaction
          List<MyTransaction> listTransaction = snapshot.data ?? [];
          // Danh sách chứa các transaction được sort theo ngày
          List<MyTransaction> listTransactionOfEventByDate = [];
          // Danh sách các transaction hoàn taonf được sort thành các ngày khác nhau
          List<List<MyTransaction>> transactionListSorted = [];
          // Danh sách các ngày có giao dịch
          List<DateTime> dateInChoosenTime = [];

          // Tính toán total và thực hiện thêm những transaction của event vào danh sách transaction của event
          listTransaction.forEach((element) {
            if (element.eventID != null) if (element.eventID ==
                _currentEvent.id) {
              listTransactionOfEventByDate.add(element);
              if (element.category.type == 'income')
                total += element.amount;
              else
                total -= element.amount;
            }
          });
          // Sort lại theo ngày
          listTransactionOfEventByDate.sort((a, b) => b.date.compareTo(a.date));
          // lưu lại các ngày có transaction
          listTransactionOfEventByDate.forEach((element) {
            if (!dateInChoosenTime.contains(element.date))
              dateInChoosenTime.add(element.date);
          });
          // tiếp tục sort để được sortedd hoàn chỉnh, này là theo ngày luôn, cho cái list 2 chiều
          dateInChoosenTime.forEach((date) {
            final b = listTransactionOfEventByDate
                .where((element) => element.date.compareTo(date) == 0);
            transactionListSorted.add(b.toList());
          });
          // Nếu không có transaction nào thì hiển thị báo không có
          return (listTransactionOfEventByDate.length == 0)
              ? Scaffold(
                  backgroundColor: Style.backgroundColor,
                  appBar: new AppBar(
                    backgroundColor: Style.appBarColor,
                    centerTitle: true,
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(
                        Style.backIcon,
                        color: Style.foregroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: Text('Transaction List',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                  ),
                  body: Container(
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
                            'There are no events',
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Style.foregroundColor.withOpacity(0.24),
                            ),
                          ),
                        ],
                      )))
              // Nếu có thì hiển thị danh sách lên
              : Scaffold(
                  backgroundColor: Style.backgroundColor,
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(
                        Style.backIcon,
                        color: Style.foregroundColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    backgroundColor: Style.appBarColor,
                    centerTitle: true,
                    elevation: 0,
                    title: Text(
                      'Transaction List',
                      style: TextStyle(
                          color: Style.foregroundColor,
                          fontFamily: Style.fontFamily),
                    ),
                  ),
                  body: buildDisplayTransactionByDate(
                      transactionListSorted, total),
                );
        });
  }

// Hiển thị các transaction theo ngày
  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate, double total) {
    return Container(
      color: Style.backgroundColor,
      child: ListView.builder(
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

// hiển thị phần header tính toán income và expense
  Widget buildHeader(
      List<List<MyTransaction>> transListSortByDate, double total) {
    total = 0;
    transListSortByDate.forEach((element) {
      element.forEach((e) {
        if (e.category.type == "income") {
          total += e.amount;
        } else
          total -= e.amount;
      });
    });
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
                    Text(total >= 0 ? 'Income' : 'Outcome',
                        style: TextStyle(
                          color: Style.foregroundColor.withOpacity(0.54),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: Style.fontFamily,
                        )),
                    MoneySymbolFormatter(
                      text: total,
                      currencyId: widget.eventWallet.currencyID,
                      textStyle: TextStyle(
                        color: Style.foregroundColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: Style.fontFamily,
                      ),
                    ),
                  ]),
            ),
          ])),
    );
  }

// Hiển thị các transaction tại đây
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
                  currencyId: widget.eventWallet.currencyID,
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
                // Xem chi tiết transaction được click
                onTap: () async {
                  await Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            transaction: transListSortByDate[xIndex][yIndex],
                            wallet: widget.eventWallet,
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
                          currencyId: widget.eventWallet.currencyID,
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
                                  : Style.expenseColor),
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
