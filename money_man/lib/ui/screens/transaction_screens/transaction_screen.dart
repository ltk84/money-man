import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  // var vi = ['vi 1' , 'vi 2', 'vi 3'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 200,
        child: Scaffold(
          appBar: AppBar(
            leading: DropdownButton(
              icon: const Icon(Icons.account_balance_wallet),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text('Cash',
                style: new TextStyle(
                  color: Colors.black,
                )),
            bottom: TabBar(
              labelColor: Colors.grey[900],
              indicatorColor: Colors.green,
              //isScrollable: false,
              isScrollable: true,
              indicatorWeight: 4.0,
              controller: _tabController,
              tabs: widget.myTabs,
              //<Widget>[
              // Tab(
              //     child: Container(
              //       child: Text(
              //         'Tap 1', style:   TextStyle(color:  Colors.black, fontSize: 18), ),
              //     )
              // ),
              // Tab(
              //     child: Container(
              //       child: Text(
              //         'Tap 2', style:   TextStyle(color:  Colors.black, fontSize: 18),),
              //     )
              // ),
              // Tab(
              //     child: Container(
              //       child: Text(
              //         'Tap 3', style:   TextStyle(color:  Colors.black, fontSize: 18),),
              //     )
              // )
              //],
            ),
            actions: <Widget>[
              IconButton(
                color: Colors.red,
                icon: const Icon(Icons.logout),
                tooltip: 'Notify',
                onPressed: () {
                  final _auth = FirebaseAuthService();
                  _auth.signOut();
                },
              ),
              IconButton(
                icon: const Icon(Icons.app_registration),
                onPressed: () {},
              ),
            ],
          ),

          body: TabBarView(
            controller: _tabController,
            children: widget.myTabs.map((tab) {
              return Container(
                  child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  SizedBox(
                      height: 180.0,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(children: <Widget>[
                          Text(
                            '\nOpening Balance:    ...    \$ \n '
                            '  Ending Balance:    ...    \$',
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            color: Colors.black,
                            height: 15.0,
                            indent: 240.0,
                            endIndent: 50.0,
                            thickness: 2.0,
                          ),
                          Text(
                            '                                           \$\n',
                            style: TextStyle(fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'view report',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ]),
                      )),
                  Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Day  ',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text('Month\n'
                                'Year'),
                            Text(
                              '                                       \(Total\)',
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_email,
                              size: 50.0,
                            ),
                            Text('\(Category\)\n'
                                'name'),
                            Text(
                              '                                         \(amount\)\n'
                              '',
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_email,
                              size: 50.0,
                            ),
                            Text('\(Category\)\n'
                                'name'),
                            Text(
                              '                                         \(amount\)\n'
                              '',
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  SizedBox(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Day  ',
                              style: TextStyle(fontSize: 24),
                            ),
                            Text('Month\n'
                                'Year'),
                            Text(
                              '                                       \(Total\)',
                              style: TextStyle(fontSize: 24),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_email,
                              size: 50.0,
                            ),
                            Text('\(Category\)\n'
                                'name'),
                            Text(
                              '                                         \(amount\)\n'
                              '',
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_email,
                              size: 50.0,
                            ),
                            Text('\(Category\)\n'
                                'name'),
                            Text(
                              '                                         \(amount\)\n'
                              '',
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.end,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 2.0,
                  ),
                ],
              ));
            }).toList(),
            // children: <Widget>[
            //   Container(
            //       child: ListView(
            //         scrollDirection: Axis.vertical,
            //         children: <Widget>[
            //           SizedBox(
            //               height: 180.0,
            //               child:  DecoratedBox(
            //                 decoration: const BoxDecoration(
            //                     color: Colors.white
            //                 ),
            //                 child: Column(
            //                     children:<Widget>[
            //                       Text('\nOpening Balance:    ...    \$ \n '
            //                           '  Ending Balance:    ...    \$',
            //                         style: TextStyle(fontSize: 24),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       Divider(
            //                         color: Colors.black,
            //                         height: 15.0,
            //                         indent: 240.0,
            //                         endIndent: 50.0,
            //                         thickness: 2.0,
            //                       ),
            //                       Text('                                           \$\n',
            //                         style: TextStyle(fontSize: 24),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       Text('view report' ,
            //                         textAlign:  TextAlign.center,
            //                         style: TextStyle(fontSize: 18.0),),
            //                     ]
            //                 ),
            //               )
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           SizedBox(
            //             child: Column(
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     Text('Day  ',
            //                       style: TextStyle(fontSize: 24),),
            //                     Text('Month\n'
            //                         'Year'),
            //                     Text('                                       \(Total\)',
            //                       style: TextStyle(fontSize: 24),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           SizedBox(
            //             child: Column(
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     Text('Day  ',
            //                       style: TextStyle(fontSize: 24),),
            //                     Text('Month\n'
            //                         'Year'),
            //                     Text('                                       \(Total\)',
            //                       style: TextStyle(fontSize: 24),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //         ],
            //       )
            //   ),
            //   Container(
            //       child: ListView(
            //         scrollDirection: Axis.vertical,
            //         children: <Widget>[
            //           SizedBox(
            //               height: 180.0,
            //               child:  DecoratedBox(
            //                 decoration: const BoxDecoration(
            //                     color: Colors.white
            //                 ),
            //                 child: Column(
            //                     children:<Widget>[
            //                       Text('\nOpening Balance:    ...    \$ \n '
            //                           '  Ending Balance:    ...    \$',
            //                         style: TextStyle(fontSize: 24),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       Divider(
            //                         color: Colors.black,
            //                         height: 15.0,
            //                         indent: 240.0,
            //                         endIndent: 50.0,
            //                         thickness: 2.0,
            //                       ),
            //                       Text('                                           \$\n',
            //                         style: TextStyle(fontSize: 24),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       Text('view report' ,
            //                         textAlign:  TextAlign.center,
            //                         style: TextStyle(fontSize: 18.0),),
            //                     ]
            //                 ),
            //               )
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           SizedBox(
            //             child: Column(
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     Text('Day  ',
            //                       style: TextStyle(fontSize: 24),),
            //                     Text('Month\n'
            //                         'Year'),
            //                     Text('                                       \(Total\)',
            //                       style: TextStyle(fontSize: 24),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           SizedBox(
            //             child: Column(
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     Text('Day  ',
            //                       style: TextStyle(fontSize: 24),),
            //                     Text('Month\n'
            //                         'Year'),
            //                     Text('                                       \(Total\)',
            //                       style: TextStyle(fontSize: 24),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //         ],
            //       )
            //   ),
            //   Container(
            //       child: ListView(
            //         scrollDirection: Axis.vertical,
            //         children: <Widget>[
            //           SizedBox(
            //               height: 180.0,
            //               child:  DecoratedBox(
            //                 decoration: const BoxDecoration(
            //                     color: Colors.white
            //                 ),
            //                 child: Column(
            //                     children:<Widget>[
            //                       Text('\nOpening Balance:    ...    \$ \n '
            //                           '  Ending Balance:    ...    \$',
            //                         style: TextStyle(fontSize: 24),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       Divider(
            //                         color: Colors.black,
            //                         height: 15.0,
            //                         indent: 240.0,
            //                         endIndent: 50.0,
            //                         thickness: 2.0,
            //                       ),
            //                       Text('                                           \$\n',
            //                         style: TextStyle(fontSize: 24),
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       Text('view report' ,
            //                         textAlign:  TextAlign.center,
            //                         style: TextStyle(fontSize: 18.0),),
            //                     ]
            //                 ),
            //               )
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           SizedBox(
            //             child: Column(
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     Text('Day  ',
            //                       style: TextStyle(fontSize: 24),),
            //                     Text('Month\n'
            //                         'Year'),
            //                     Text('                                       \(Total\)',
            //                       style: TextStyle(fontSize: 24),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           SizedBox(
            //             child: Column(
            //               children: <Widget>[
            //                 Row(
            //                   children: <Widget>[
            //                     Text('Day  ',
            //                       style: TextStyle(fontSize: 24),),
            //                     Text('Month\n'
            //                         'Year'),
            //                     Text('                                       \(Total\)',
            //                       style: TextStyle(fontSize: 24),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //                 Row(
            //                   children: <Widget>[
            //                     Icon(Icons.attach_email, size: 50.0,),
            //                     Text('\(Category\)\n'
            //                         'name'),
            //                     Text('                                         \(amount\)\n'
            //                         '',
            //                       style: TextStyle(fontSize: 20.0),
            //                       textAlign: TextAlign.end,)
            //                   ],
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //           Divider(
            //             color: Colors.black,
            //             thickness: 2.0,
            //           ),
            //         ],
            //       )
            //   ),
            // ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   backgroundColor: Colors.white,
          //   items: [
          //     BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded, size: 20.0),label: 'Wallet',backgroundColor: Colors.black),
          //     BottomNavigationBarItem(icon: Icon(Icons.analytics_sharp), label: 'Report',backgroundColor: Colors.black),
          //     BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 60.0,), label: 'Add',backgroundColor: Colors.black ),
          //     BottomNavigationBarItem(icon: Icon(Icons.article_sharp), label: 'Report',backgroundColor: Colors.black),
          //     BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Report',backgroundColor: Colors.black),
          //   ],
          // ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => throw UnimplementedError();
}
