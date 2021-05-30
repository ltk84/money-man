import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _TransactionListScreen();
  }
}
class _TransactionListScreen extends State<TransactionListScreen> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: null),
          title: Text('\(name\[budget,event\]\)', style: TextStyle(fontSize: 20, color: Colors.black), ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                child: Column(
                  children: <Widget>[
                    Divider(
                      thickness: 2.0,
                      color: Colors.black,
                    ),
                    Row(
                      children: <Widget>[
                        Text('Overview', style: TextStyle(fontSize: 24.0),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                            children: <Widget>[
                              Text('Expense', style: TextStyle(fontSize: 20.0),)
                            ]
                        ),
                        Column(
                            children: <Widget>[
                              Text('                                          \(amount\)', style: TextStyle(fontSize: 20.0),)
                            ]
                        )
                      ],
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.black,
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.black,
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
                      thickness: 2.0,
                      color: Colors.black,
                    ),
                    Divider(
                      thickness: 2.0,
                      color: Colors.black,
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
                  ],
                ),
              ),
              Divider(
                thickness: 2.0,
                color: Colors.black,
              ),
              Divider(
                thickness: 2.0,
                color: Colors.black,
              ),
            ],
          ),
        )
    );
  }
}