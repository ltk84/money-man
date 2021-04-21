import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/test.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:money_man/ui/screens/wallet_selection.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:provider/provider.dart';

class TransactionScreen extends StatefulWidget {
  final List<Tab> myTabs = List.generate(200, (index) {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month + index - 100, now.day);
    String dateDisplay = DateFormat('MM/yyyy').format(date);
    return Tab(text: dateDisplay);
  });

  @override
  State<StatefulWidget> createState() {
    return _TransactionScreen();
  }
}

class _TransactionScreen extends State<TransactionScreen>
    with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 200, vsync: this, initialIndex: 150);
  }
  @override
  Widget build(BuildContext context) {
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
                  icon: const Icon(Icons.account_balance_wallet, color: Colors.grey), onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return Wallet_Selection();
                      }
                    );
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey), onPressed: () {  },
                ),
              )
            ],
          ),
          title: Column(
            children: [
              Text('Wallet', style: TextStyle(color: Colors.grey[500], fontSize: 10.0)),
              Text('+100,000 đ', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold)),
            ]
          ),
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
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: widget.myTabs.map((tab){
            return
              Container(
                color: Colors.black,
                child: ListView.builder(
                  //primary: false,
                  shrinkWrap: true,
                  itemCount: TRANSACTION_DATA.length + 1,
                  itemBuilder: (context, index){
                    // if (index != 0)
                    // {
                    //   var date = DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"]); // có cần try catch chỗ này khơm?
                    //   var dayNum = DateFormat("dd").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"]));
                    //   var day = DateFormat("EEEE").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"]));
                    //   var monthInYear = DateFormat("MMMM yyyy").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"]));
                    // }
                    return index == 0 ? StickyHeader(
                      header: SizedBox(height: 0),
                      content: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            )
                          )
                        ),
                        padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Opening balance', style: TextStyle(color: Colors.grey[500])),
                                  Text('+1,000,000 đ', style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text('Ending balance', style: TextStyle(color: Colors.grey[500])),
                                    Text('-900,000 đ', style: TextStyle(color: Colors.white)),
                                  ]
                              ),
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
                                  ]
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('+100,000 đ', style: TextStyle(color: Colors.white)),
                                  ]
                              ),
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
                          ]
                        )
                      ),
                    ) :
                    Container(
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
                            width:1.0,
                          )
                        )
                      ),
                      child: StickyHeader(
                        header: Container(
                          color: Colors.grey[900],
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: Text(DateFormat("dd").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"])).toString(), style: TextStyle(fontSize: 30.0, color: Colors.white)),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                                child: Text(DateFormat("EEEE").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"])).toString()+'\n'+DateFormat("MMMM yyyy").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"])).toString(), style: TextStyle(fontSize: 12.0, color: Colors.grey[500])),
                              ),
                              Expanded(child: Text('-1,000,000 đ', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                            ],
                          ),
                        ),
                        content: Container(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: Icon(Icons.school, size: 30.0, color: Colors.grey[600]),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                child: Text(TRANSACTION_DATA[index-1]["category"], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                              Expanded(child: Text('1,000,000 đ', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[600]))),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                ),
              );
          }).toList(),
        )
      )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}