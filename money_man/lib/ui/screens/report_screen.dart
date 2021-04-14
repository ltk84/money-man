import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReportScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _ReportScreen();
  }
}
class _ReportScreen extends State<ReportScreen> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,

        leading: DropdownButton(
          icon: Icon(Icons.account_balance_wallet_outlined),
          iconSize: 30.0,
        ),
        centerTitle: true,
        title: TextButton(
          child: Text('This Month \n\(Time range\)', style: TextStyle(color: Colors.black),),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share_outlined),
            iconSize: 30,
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
            Row(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text('                           '),
                      ],
                    ),
                    Column(
                        children: <Widget>[
                          Text('Opening  balance\n', textAlign: TextAlign.left,),
                          Text('100\$',
                            style: TextStyle(color: Colors.black, fontSize: 24),
                            textAlign: TextAlign.left,
                          )
                        ]
                    ),
                    Column(
                      children: <Widget>[
                        Text('        '),
                      ],
                    ),
                    Column(
                        children: <Widget>[
                          Text('Ending  balance\n', textAlign: TextAlign.right,),
                          Text('100\$',
                            style: TextStyle(color: Colors.black, fontSize: 24),
                            textAlign: TextAlign.right,
                          )
                        ]
                    ),
                    Column(
                      children: <Widget>[
                        Text('        '),
                      ],
                    ),
                  ],
                )
              ],
            ),
            Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
            SizedBox(
              child: Column(
                children: <Widget>[
                  Text('Net Income',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text('0\$',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text('\n\n\n\n\n')
                ],
              ),
            ),
            Divider(
              thickness: 2.0,
              color: Colors.black,
            ),
            SizedBox(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                          children: <Widget>[
                            Text('Opening Balance' ,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          ]
                      ),
                      Row(
                          children: <Widget>[
                            Text('100\$' ,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          ]
                      ),
                      Row(
                          children: <Widget>[
                          ]
                      ),

                    ],
                  ),

                  VerticalDivider(
                    thickness: 5.0,
                    color: Colors.black,
                  ),
                  Column(

                  )
                ],
              ),
            )
          ],
        ),
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
    );
  }
}