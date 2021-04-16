import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionDetailScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _TransactionDetailScreen();
  }
}
class _TransactionDetailScreen extends State<TransactionDetailScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }
  var vi = ['vi 1' , 'vi 2', 'vi 3'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: null),
          title: Text('Transaction', style: TextStyle(fontSize: 20, color: Colors.black), ),
          actions: <Widget>[
            TextButton(
              onPressed: null,
              child: Text('edit', style: TextStyle(color: Colors.red, fontSize: 18),),
            )
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                child: Column(
                    children: <Widget>[
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      Row(
                          children: <Widget>[
                            Icon(Icons.airplanemode_active, size: 100.0,),
                            Column(
                              children: <Widget>[
                                Text('\(Category\)\n'
                                    'note\n'
                                    '\(amount\)\n', style: TextStyle(fontSize: 28),)
                              ],
                            ),
                          ]
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 1.5,
                        indent: 35,
                        endIndent: 35,
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.access_time_sharp,size: 30.0,),
                              Text(' Date time', style: TextStyle(fontSize: 20),),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.account_balance_wallet_outlined,size: 30.0,),
                              Text(' Wallet name', style: TextStyle(fontSize: 20),),
                            ],
                          )

                        ],
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(' Budget', style: TextStyle(fontSize: 20 ),),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(' Lorem ipsion', style: TextStyle(fontSize: 20),),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Icon(Icons.airplanemode_active, size: 30.0)
                                  ],
                                ),
                                Column(
                                    children: <Widget>[
                                      Text('\(Category\)\n', style: TextStyle(fontSize: 18.0),),
                                    ]
                                )
                              ],
                            )
                          ]
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      TextButton(
                        onPressed: null,
                        child: Text('Share', style: TextStyle(color: Colors.blue, fontSize: 18),),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),
                      TextButton(
                        onPressed: null,
                        child: Text('Delete Transaction', style: TextStyle(color: Colors.red, fontSize: 18),),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 2.0,
                      ),

                    ]
                ),
              ),
              SizedBox(
                child: Column(
                  children: <Widget>[
                    Row(

                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}