import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class EventListTransactionScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  EventListTransactionScreen({Key key, this.currentEvent, this.eventWallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EventListTransactionScreen();
  }
}

class _EventListTransactionScreen extends State<EventListTransactionScreen>
    with TickerProviderStateMixin {
  Event _currentEvent;
  Wallet _eventWallet;
  List<DateTime> dateInChoosenTime = [];

  @override
  void initState() {
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
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<Object>(
        stream: _firestore.transactionStream(_eventWallet, 'full'),
        builder: (context,snapshot) {
          double total = 0;
          List<MyTransaction> listTransaction = snapshot.data ?? [];
          List<MyTransaction> listTransactionOfEventByDate = [];
          List<List<MyTransaction>> transactionListSorted = [];
          List<DateTime> dateInChoosenTime = [];

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
          listTransactionOfEventByDate.sort((a, b) => b.date.compareTo(a.date));

          listTransactionOfEventByDate.forEach((element) {
            if (!dateInChoosenTime.contains(element.date))
              dateInChoosenTime.add(element.date);
          });
          dateInChoosenTime.forEach((date) {
            final b = listTransactionOfEventByDate
                .where((element) => element.date.compareTo(date) == 0);
            transactionListSorted.add(b.toList());
          });
          return (listTransactionOfEventByDate.length == 0)?
          Scaffold(
              backgroundColor: Colors.black,
              appBar: new AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                elevation: 0,
                title: Text('Transaction List'),
              ),
              body: Container(
                alignment:  Alignment.center,
                child: Text(
                  'No transaction',
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white54,
                  ),
                ),
              )
          ) : Scaffold(
            backgroundColor: Colors.black,
            appBar: new AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              elevation: 0,
              title: Text('Transaction List'),
            ),
            body: buildDisplayTransactionByDate(transactionListSorted, total),
          );
        }
    );
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate, double total) {
    return Container(
      color: Colors.black,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
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

  Widget buildHeader(List<List<MyTransaction>> transListSortByDate, double total) {
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
                    Text(total >= 0 ? 'Income' : 'Outcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                        )),
                    MoneySymbolFormatter(
                        text: total,
                        currencyId: widget.eventWallet.currencyID,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Montserrat',
                        )
                    ),
                  ]),
            ),
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
                    style:
                    TextStyle(fontSize: 30.0, color: Colors.white)),
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
                        fontSize: 12.0, color: Colors.grey[500])),
              ),
              Expanded(
                child: MoneySymbolFormatter(
                  text: totalAmountInDay,
                  currencyId: widget.eventWallet.currencyID,
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
                onTap: () async {
                  await Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                            transaction: transListSortByDate[xIndex]
                            [yIndex],
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
                            transListSortByDate[xIndex][yIndex]
                                .category
                                .name,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                        child: MoneySymbolFormatter(
                            text: transListSortByDate[xIndex][yIndex]
                                .amount,
                            currencyId: widget.eventWallet.currencyID,
                            textAlign: TextAlign.end,

                            textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transListSortByDate[xIndex][yIndex]
                                    .category
                                    .type ==
                                    'income'
                                    ? Colors.green
                                    : Colors.red[600])
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
