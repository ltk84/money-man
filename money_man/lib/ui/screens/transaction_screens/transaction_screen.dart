import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/shared_screens/search_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';

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
  bool viewByCategory = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 200, vsync: this, initialIndex: 100);
    _tabController.addListener(() {
      setState(() {});
    });
    _wallet = widget.currentWallet == null
        ? Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 0,
            currencyID: 'USD',
            iconID: '58666')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant TransactionScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    _wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'USD',
            iconID: '58666');
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    print('transaction build ' + _wallet.amount.toString());
    return DefaultTabController(
        length: 200,
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
                          buildShowDialog(context, _wallet.id);
                        }),
                  ),
                  Expanded(
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      onPressed: () async {
                        buildShowDialog(context, _wallet.id);
                      },
                    ),
                  )
                ],
              ),
              title: Column(children: [
                Text(_wallet.name,
                    style: TextStyle(color: Colors.grey[500], fontSize: 10.0)),
                Text(
                    MoneyFormatter(amount: _wallet.amount)
                        .output
                        .withoutFractionDigits,
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
                PopupMenuButton(onSelected: (value) {
                  print(value);
                  if (value == 'Search for transaction') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SearchTransactionScreen(
                                  wallet: _wallet,
                                )));
                  } else if (value == 'change display') {
                    setState(() {
                      viewByCategory = !viewByCategory;
                    });
                  }
                }, itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        value: 'Select time range',
                        child: Text(
                          'Select time range',
                          style: TextStyle(color: Colors.black),
                        )),
                    PopupMenuItem(
                        value: 'change display',
                        child: Text(
                          viewByCategory
                              ? 'View by transaction'
                              : 'View by category',
                          style: TextStyle(color: Colors.black),
                        )),
                    PopupMenuItem(
                        value: 'Adjust Balance',
                        child: Text(
                          'Adjust Balance',
                          style: TextStyle(color: Colors.black),
                        )),
                    PopupMenuItem(
                        value: 'Transfer money',
                        child: Text(
                          'Transfer money',
                          style: TextStyle(color: Colors.black),
                        )),
                    PopupMenuItem(
                        value: 'Search for transaction',
                        child: Text(
                          'Search for transaction',
                          style: TextStyle(color: Colors.black),
                        )),
                    PopupMenuItem(
                        value: 'Synchronize',
                        child: Text(
                          'Synchronize',
                          style: TextStyle(color: Colors.black),
                        )),
                  ];
                })
              ],
            ),
            body: StreamBuilder<List<MyTransaction>>(
                stream: _firestore.transactionStream(_wallet),
                builder: (context, snapshot) {
                  List<MyTransaction> _transactionList = snapshot.data ?? [];

                  var chooseTime =
                      widget.myTabs[_tabController.index].text.split('/');

                  _transactionList = _transactionList
                      .where((element) =>
                          element.date.month == int.parse(chooseTime[0]) &&
                          element.date.year == int.parse(chooseTime[1]))
                      .toList();

                  List<DateTime> dateInChoosenTime = [];
                  List<String> categoryInChoosenTime = [];

                  double totalInCome = 0;
                  double totalOutCome = 0;
                  double total = 0;

                  List<List<MyTransaction>> transactionListSorted = [];

                  _transactionList.sort((a, b) => b.date.compareTo(a.date));

                  if (viewByCategory) {
                    _transactionList.forEach((element) {
                      if (!categoryInChoosenTime
                          .contains(element.category.name))
                        categoryInChoosenTime.add(element.category.name);
                      if (element.category.type == 'expense')
                        totalOutCome += element.amount;
                      else
                        totalInCome += element.amount;
                    });
                    total = totalInCome - totalOutCome;

                    categoryInChoosenTime.forEach((cate) {
                      final b = _transactionList.where((element) =>
                          element.category.name.compareTo(cate) == 0);
                      transactionListSorted.add(b.toList());
                    });
                  } else {
                    _transactionList.forEach((element) {
                      if (!dateInChoosenTime.contains(element.date))
                        dateInChoosenTime.add(element.date);
                      if (element.category.type == 'expense')
                        totalOutCome += element.amount;
                      else
                        totalInCome += element.amount;
                    });
                    total = totalInCome - totalOutCome;

                    dateInChoosenTime.forEach((date) {
                      final b = _transactionList.where(
                          (element) => element.date.compareTo(date) == 0);
                      transactionListSorted.add(b.toList());
                    });
                  }

                  return TabBarView(
                    controller: _tabController,
                    children: widget.myTabs.map((tab) {
                      return viewByCategory == true
                          ? buildDisplayTransactionByCategory(
                              transactionListSorted,
                              totalInCome,
                              totalOutCome,
                              total)
                          : buildDisplayTransactionByDate(transactionListSorted,
                              totalInCome, totalOutCome, total);
                    }).toList(),
                  );
                })));
  }

  Container buildDisplayTransactionByCategory(
      List<List<MyTransaction>> transactionListSortByCategory,
      double totalInCome,
      double totalOutCome,
      double total) {
    return Container(
      color: Colors.black,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactionListSortByCategory.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            transactionListSortByCategory[xIndex].forEach((element) {
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });

            return xIndex == 0
                ? Column(
                    children: [
                      buildHeader(totalInCome, totalOutCome, total),
                      buildBottomViewByCategory(transactionListSortByCategory,
                          xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByCategory(
                    transactionListSortByCategory, xIndex, totalAmountInDay);
          }),
    );
  }

  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate,
      double totalInCome,
      double totalOutCome,
      double total) {
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
                      buildHeader(totalInCome, totalOutCome, total),
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

  Container buildBottomViewByCategory(
      List<List<MyTransaction>> transListSortByCategory,
      int xIndex,
      double totalAmountInDay) {
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
                  child: Icon(Icons.ac_unit_rounded)),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Text(
                    transListSortByCategory[xIndex][0].category.name +
                        '\n' +
                        transListSortByCategory[xIndex].length.toString() +
                        ' transactions',
                    // 'hello',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
              ),
              Expanded(
                child: Text(totalAmountInDay.toString(),
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
            itemCount: transListSortByCategory[xIndex].length,
            itemBuilder: (context, yIndex) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TransactionDetail(
                                transaction: transListSortByCategory[xIndex]
                                    [yIndex],
                                wallet: widget.currentWallet,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Text(
                            DateFormat("dd").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: Text(
                            DateFormat("MMMM yyyy, EEEE").format(
                                transListSortByCategory[xIndex][yIndex].date),
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      Expanded(
                        child: Text(
                            transListSortByCategory[xIndex][yIndex]
                                .amount
                                .toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: transListSortByCategory[xIndex][yIndex]
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
                child: Text(totalAmountInDay.toString(),
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
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: TransactionDetail(
                                transaction: transListSortByDate[xIndex]
                                    [yIndex],
                                wallet: widget.currentWallet,
                              ),
                          type: PageTransitionType.rightToLeft
                      )
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: Icon(Icons.school,
                            size: 30.0, color: Colors.grey[600]),
                      ),
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

  StickyHeader buildHeader(
      double totalInCome, double totalOutCome, double total) {
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
                  Text('Opening balance',
                      style: TextStyle(color: Colors.grey[500])),
                  Text('+$totalInCome đ',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Ending balance',
                        style: TextStyle(color: Colors.grey[500])),
                    Text('-$totalOutCome đ',
                        style: TextStyle(color: Colors.white)),
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
                    Text('$total đ', style: TextStyle(color: Colors.white)),
                  ]),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View report for this period',
                style: TextStyle(color: Colors.yellow[700]),
              ),
              style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            )
          ])),
    );
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
