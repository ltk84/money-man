import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _TransactionScreen();
  }
}
class _TransactionScreen extends State<TransactionScreen> with TickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  var vi = ['vi 1' , 'vi 2', 'vi 3'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: DropdownButton(
              icon: const Icon(Icons.account_balance_wallet),


            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text('Cash', style: new TextStyle(
              color: Colors.black,
            )),

            bottom: TabBar(
              indicatorColor: Colors.green,
              isScrollable: false,
              indicatorWeight: 4.0,
              controller: _tabController,
              tabs:  <Widget>[
                Tab(
                    child: Container(
                      child: Text(
                        'Tap 1', style:   TextStyle(color:  Colors.black, fontSize: 18), ),
                    )
                ),
                Tab(
                    child: Container(
                      child: Text(
                        'Tap 2', style:   TextStyle(color:  Colors.black, fontSize: 18),),
                    )
                ),
                Tab(
                    child: Container(
                      child: Text(
                        'Tap 3', style:   TextStyle(color:  Colors.black, fontSize: 18),),
                    )
                )
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.add_alert),
                tooltip: 'Notify',

              ),
              IconButton(
                icon: const Icon(Icons.app_registration),

              ),
            ],

          ),

          body: TabBarView(
            controller: _tabController,
            children: <Widget>[
              Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      SizedBox(
                          height: 180.0,
                          child:  DecoratedBox(
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                                children:<Widget>[
                                  Text('\nOpening Balance:    ...    \$ \n '
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
                                  Text('                                           \$\n',
                                    style: TextStyle(fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('view report' ,
                                    textAlign:  TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),),
                                ]
                            ),
                          )
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
                                Text('Day  ',
                                  style: TextStyle(fontSize: 24),),
                                Text('Month\n'
                                    'Year'),
                                Text('                                       \(Total\)',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
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
                                Text('Day  ',
                                  style: TextStyle(fontSize: 24),),
                                Text('Month\n'
                                    'Year'),
                                Text('                                       \(Total\)',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
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
                  )
              ),
              Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      SizedBox(
                          height: 180.0,
                          child:  DecoratedBox(
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                                children:<Widget>[
                                  Text('\nOpening Balance:    ...    \$ \n '
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
                                  Text('                                           \$\n',
                                    style: TextStyle(fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('view report' ,
                                    textAlign:  TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),),
                                ]
                            ),
                          )
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
                                Text('Day  ',
                                  style: TextStyle(fontSize: 24),),
                                Text('Month\n'
                                    'Year'),
                                Text('                                       \(Total\)',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
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
                                Text('Day  ',
                                  style: TextStyle(fontSize: 24),),
                                Text('Month\n'
                                    'Year'),
                                Text('                                       \(Total\)',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
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
                  )
              ),
              Container(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      SizedBox(
                          height: 180.0,
                          child:  DecoratedBox(
                            decoration: const BoxDecoration(
                                color: Colors.white
                            ),
                            child: Column(
                                children:<Widget>[
                                  Text('\nOpening Balance:    ...    \$ \n '
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
                                  Text('                                           \$\n',
                                    style: TextStyle(fontSize: 24),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text('view report' ,
                                    textAlign:  TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),),
                                ]
                            ),
                          )
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
                                Text('Day  ',
                                  style: TextStyle(fontSize: 24),),
                                Text('Month\n'
                                    'Year'),
                                Text('                                       \(Total\)',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
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
                                Text('Day  ',
                                  style: TextStyle(fontSize: 24),),
                                Text('Month\n'
                                    'Year'),
                                Text('                                       \(Total\)',
                                  style: TextStyle(fontSize: 24),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.attach_email, size: 50.0,),
                                Text('\(Category\)\n'
                                    'name'),
                                Text('                                         \(amount\)\n'
                                    '',
                                  style: TextStyle(fontSize: 20.0),
                                  textAlign: TextAlign.end,)
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
                  )
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded, size: 20.0),label: 'Wallet',backgroundColor: Colors.black),
              BottomNavigationBarItem(icon: Icon(Icons.analytics_sharp), label: 'Report',backgroundColor: Colors.black),
              BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 60.0,), label: 'Add',backgroundColor: Colors.black ),
              BottomNavigationBarItem(icon: Icon(Icons.article_sharp), label: 'Report',backgroundColor: Colors.black),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Report',backgroundColor: Colors.black),
            ],
          ),
        )
    );
  }
}



