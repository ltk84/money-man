import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/test.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TransactionScreen extends StatefulWidget {
  Wallet currentWallet;

  final List<Tab> myTabs = List.generate(200, (index) {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month + index - 100, now.day);
    String dateDisplay = DateFormat('MM/yyyy').format(date);
    return Tab(text: dateDisplay);
  });

  TransactionScreen({Key key, this.currentWallet}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TransactionScreen();
  }
}

class _TransactionScreen extends State<TransactionScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  Wallet _wallet;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 200, vsync: this, initialIndex: 150);
    _wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: 'a')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant TransactionScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'a',
            iconID: 'b');
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    // print('transaction build ' + wallet.id);
    return DefaultTabController(
        length: 300,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              centerTitle: true,
              elevation: 0,
              leading: Row(
                children: [
                  Expanded(
                    child: IconButton(
                        icon: const Icon(Icons.account_balance_wallet,
                            color: Colors.grey),
                        onPressed: () async {
                          // print('pressed' + widget.currentWallet.id);
                          // buildShowDialog(context, widget.currentWallet.id);
                          buildShowDialog(context, _wallet.id);
                        }),
                  ),
                  Expanded(
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      onPressed: () async {
                        // buildShowDialog(context, widget.currentWallet.id);
                        buildShowDialog(context, _wallet.id);
                      },
                    ),
                  )
                ],
              ),
              title: Column(children: [
                Text(_wallet.name,
                    style: TextStyle(color: Colors.grey[500], fontSize: 10.0)),
                Text(_wallet.amount.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold)),
              ]),
              bottom: TabBar(
                unselectedLabelColor: Colors.grey[500],
                labelColor: Colors.white,
                indicatorColor: Colors.yellow[700],
                physics: NeverScrollableScrollPhysics(),
                isScrollable: true,
                indicatorWeight: 3.0,
                controller: _tabController,
                tabs: widget.myTabs,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.grey),
                  tooltip: 'Notify',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
            body: StreamBuilder<List<MyTransaction>>(
                stream: _firestore.transactionStream(_wallet),
                builder: (context, snapshot) {
                  List<MyTransaction> _transactionList = snapshot.data ?? [];
                  List<DateTime> a = [];

                  _transactionList.sort((a, b) => a.date.compareTo(b.date));
                  _transactionList.forEach((element) {
                    if (!a.contains(element.date)) a.add(element.date);
                  });

                  // a.map((e) => print(e)).toList();
                  List<List<MyTransaction>> x = [];
                  a.forEach((date) {
                    final b = _transactionList
                        .where((element) => element.date.compareTo(date) == 0);
                    x.add(b.toList());
                  });

                  // x.map((e) => e.map((k) => print(k.id)).toList()).toList();

                  return TabBarView(
                    controller: _tabController,
                    children: widget.myTabs.map((tab) {
                      return Container(
                        color: Colors.black,
                        child: Column(
                          children: [
                            _transactionList.length == 0
                                ? Container()
                                : StickyHeader(
                                    header: SizedBox(height: 0),
                                    content: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[900],
                                            border: Border(
                                                bottom: BorderSide(
                                              color: Colors.black,
                                              width: 1.0,
                                            ))),
                                        padding: EdgeInsets.fromLTRB(
                                            12.0, 12.0, 12.0, 0),
                                        child: Column(children: <Widget>[
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text('Opening balance',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[500])),
                                                Text('+1,000,000 đ',
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text('Ending balance',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[500])),
                                                  Text('-900,000 đ',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ]),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                  ColoredBox(
                                                      color: Colors.black87)
                                                ]),
                                          ),
                                          Container(
                                            margin:
                                                EdgeInsets.fromLTRB(2, 2, 2, 2),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('+100,000 đ',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ]),
                                          ),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'View report for this period',
                                              style: TextStyle(
                                                  color: Colors.yellow[700]),
                                            ),
                                            style: TextButton.styleFrom(
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap),
                                          )
                                        ])),
                                  ),
                            Expanded(
                              child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  //primary: false,
                                  shrinkWrap: true,
                                  // itemCount: TRANSACTION_DATA.length + 1,
                                  itemCount: x.length,
                                  itemBuilder: (context, xIndex) {
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
                                          padding: EdgeInsets.fromLTRB(
                                              10.0, 10.0, 10.0, 5.0),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 0, 4, 0),
                                                child: Text(
                                                    DateFormat("dd").format(
                                                        x[xIndex][0].date),
                                                    style: TextStyle(
                                                        fontSize: 30.0,
                                                        color: Colors.white)),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        14, 0, 14, 0),
                                                child: Text(
                                                    DateFormat("EEEE")
                                                            .format(x[xIndex][0]
                                                                .date)
                                                            .toString() +
                                                        '\n' +
                                                        DateFormat("MMMM yyyy")
                                                            .format(x[xIndex][0]
                                                                .date)
                                                            .toString(),
                                                    // 'hello',
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            Colors.grey[500])),
                                              ),
                                              Expanded(
                                                  child: Text('-1,000,000 đ',
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.white))),
                                            ],
                                          ),
                                        ),
                                        content: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: x[xIndex].length,
                                            itemBuilder: (context, yIndex) {
                                              return Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10.0, 5.0, 10.0, 10.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(4, 0, 4, 0),
                                                      child: Icon(Icons.school,
                                                          size: 30.0,
                                                          color:
                                                              Colors.grey[600]),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          18, 0, 18, 0),
                                                      child: Text(
                                                          x[xIndex][yIndex]
                                                              .category
                                                              .name,
                                                          style: TextStyle(
                                                              fontSize: 14.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            x[xIndex][yIndex]
                                                                .amount
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: x[xIndex][yIndex]
                                                                            .category
                                                                            .type ==
                                                                        'income'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors.red[
                                                                        600]))),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                })));
  }

  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.grey[900],
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}
