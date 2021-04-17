import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/test.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionScreen extends StatefulWidget{  
  int indexNow = 0;
  @override
  State<StatefulWidget> createState() {

    return _TransactionScreen();
  }
}
class _TransactionScreen extends State<TransactionScreen> with TickerProviderStateMixin {
  final List<Tab> myTabs = List.generate(
      300, (index) {
        var now = DateTime.now();
      var date = DateTime(now.year, now.month + index - 150, now.day);
      String dateDisplay = DateFormat('MM/yyyy').format(date);
      return Tab(text: dateDisplay);
  }
  );

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 300, vsync: this, initialIndex: 150);
  }
  var vi = ['vi 1' , 'vi 2', 'vi 3'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 300,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: DropdownButton(
              icon: const Icon(Icons.account_balance_wallet),
            ),
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
                'Cash',
                style: new TextStyle(
                color: Colors.black,
              )
            ),
            bottom: TabBar(
              labelColor: Colors.grey[900],
              indicatorColor: Colors.yellow[700],
              //isScrollable: false,
              isScrollable: true,
              indicatorWeight: 3.0,
              controller: _tabController,
              tabs:  myTabs,
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
            children: myTabs.map((tab){
              return
                //ListView(
                  //scrollDirection: Axis.vertical,
                  // children: <Widget>[
                  //   Container(
                  //     decoration: BoxDecoration(
                  //     border: Border(
                  //       bottom: BorderSide(
                  //         color: Colors.black,
                  //         width: 1.0,
                  //       )
                  //     )
                  //     ),
                  //     padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
                  //     child: Column(
                  //       children: <Widget>[
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //             children: <Widget>[
                  //               Text('Opening balance'),
                  //               Text('+1,000,000 đ'),
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  //           child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: <Widget>[
                  //                 Text('Ending balance'),
                  //                 Text('-900,000 đ'),
                  //               ]
                  //           ),
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  //           child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: <Widget>[
                  //                 SizedBox(
                  //                   width: 10,
                  //                   height: 10,
                  //                 ),
                  //                 Divider(
                  //                   color: Colors.black,
                  //                   thickness: 1.0,
                  //                   height: 10,
                  //                 ),
                  //                 ColoredBox(color: Colors.black87)
                  //               ]
                  //           ),
                  //         ),
                  //         Container(
                  //           margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                  //           child: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: <Widget>[
                  //                 SizedBox(
                  //                   width: 10,
                  //                 ),
                  //                 Text('+100,000 đ'),
                  //               ]
                  //           ),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {},
                  //           child: Text(
                  //               'View report for this period',
                  //             style: TextStyle(color: Colors.yellow[700]),
                  //           ),
                  //           style: TextButton.styleFrom(
                  //               tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  //         )
                  //       ]
                  //     )
                  //   ),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border(
                      //     bottom: BorderSide(
                      //       color: Colors.black,
                      //       width: 1.0,
                      //     ),
                      //     top: BorderSide(
                      //       color: Colors.black,
                      //       width:1.0,
                      //     )
                      //   )
                      // ),
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
                                        Text('Opening balance'),
                                        Text('+1,000,000 đ'),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('Ending balance'),
                                          Text('-900,000 đ'),
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
                                          Text('+100,000 đ'),
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
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            decoration: BoxDecoration(
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
                                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Text(DateFormat("dd").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"])).toString(), style: TextStyle(fontSize: 30.0)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                                      child: Text(DateFormat("EEEE").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"])).toString()+'\n'+DateFormat("MMMM yyyy").format(DateFormat("dd/MM/yyyy").parse(TRANSACTION_DATA[index-1]["date"])).toString(), style: TextStyle(fontSize: 12.0)),
                                    ),
                                    Expanded(child: Text('-1,000,000 đ', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              content: Container(
                                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                      child: Icon(Icons.school, size: 30.0),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                                      child: Text(TRANSACTION_DATA[index-1]["category"], style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
                                    ),
                                    Expanded(child: Text('-1,000,000 đ', textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              ),
                              // header:  ListTile(
                              //   leading: Text(date.day.toString()),
                              //   title: Text(date.month.toString()),
                              //   subtitle: Text(date.year.toString()),
                              //   trailing: Text('Total'),
                              // ),
                              // content: ListTile(
                              //   tileColor: Colors.yellow[700],
                              //   leading: Icon(Icons.school),
                              //   title: Text(TRANSACTION_DATA[index]["category"]),
                              //   subtitle: Text(TRANSACTION_DATA[index]["note"]),
                              //   trailing: Text(TRANSACTION_DATA[index]["amount"]),
                              // )
                            ),
                          );
                        }
                      ),
                    );
                    // Container(
                    //   decoration: BoxDecoration(
                    //     border: Border(
                    //       bottom: BorderSide(
                    //         color: Colors.black,
                    //         width: 1.0,
                    //       ),
                    //       top: BorderSide(
                    //         color: Colors.black,
                    //         width:1.0,
                    //       )
                    //     )
                    //   ),
                    //   padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text('Day'),
                    //           Text('Month\nYear'),
                    //           Expanded(child: Text('Total', textAlign: TextAlign.end,)),
                    //         ],
                    //       ),
                    //       Container(
                    //         child:
                    //           ListView.builder(
                    //             shrinkWrap: true,
                    //             itemCount: TRANSACTION_DATA.length,
                    //               itemBuilder: (context, index){
                    //                 return StickyHeader(
                    //                   header: Container(
                    //                     height: 50.0,
                    //                     color: Colors.blueGrey[700],
                    //                     padding: EdgeInsets.symmetric(horizontal: 16.0),
                    //                     alignment: Alignment.centerLeft,
                    //                     child: Text('Header #$index',
                    //                       style: const TextStyle(color: Colors.white),
                    //                     ),
                    //                   ),
                    //                   content: Container(
                    //                     child: Image.network(imageForIndex(index), fit: BoxFit.cover,
                    //                         width: double.infinity, height: 200.0),
                    //                   ),
                    //                 );
                    //               }
                    //           ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 2.0,
                    // ),
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 2.0,
                    // ),
                    // SizedBox(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Text('Day  ',
                    //             style: TextStyle(fontSize: 24),),
                    //           Text('Month\n'
                    //               'Year'),
                    //           Text('                                       \(Total\)',
                    //             style: TextStyle(fontSize: 24),
                    //             textAlign: TextAlign.end,)
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Icon(Icons.attach_email, size: 50.0,),
                    //           Text('\(Category\)\n'
                    //               'name'),
                    //           Text('                                         \(amount\)\n'
                    //               '',
                    //             style: TextStyle(fontSize: 20.0),
                    //             textAlign: TextAlign.end,)
                    //         ],
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Icon(Icons.attach_email, size: 50.0,),
                    //           Text('\(Category\)\n'
                    //               'name'),
                    //           Text('                                         \(amount\)\n'
                    //               '',
                    //             style: TextStyle(fontSize: 20.0),
                    //             textAlign: TextAlign.end,)
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 2.0,
                    // ),
                    // Divider(
                    //   color: Colors.black,
                    //   thickness: 2.0,
                    // ),
                  //],
              //);
            }).toList(),
          )
        )
    );
  }
}



