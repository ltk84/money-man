import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/time_selection.dart';
import '../../style.dart';
import 'package:money_man/ui/screens/wallet_selection.dart';
import '../wallet_selection.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class ReportScreen extends StatefulWidget{

  final List<Tab> myTabs = List.generate(200, (index) {
    var now = DateTime.now();
    var date = DateTime(now.year, now.month + index - 100, now.day);
    String dateDisplay = DateFormat('MM/yyyy').format(date);
    return Tab(text: dateDisplay);
  });

  @override
  State<StatefulWidget> createState() {
    return _ReportScreen();
  }
}

class _ReportScreen extends State<ReportScreen> with TickerProviderStateMixin {
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

        appBar: new AppBar(
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
                          return WalletSelectionScreen();
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
            children: <Widget>[
              Text('Wallet', style: TextStyle(fontSize: 14),),
              Text('100000\$', style: TextStyle(fontSize: 14),),
            ],
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
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
              tooltip: 'Time',
              onPressed: (){
                return showDialog(
                    context: context,
                    builder: (context) {
                      return Time_Selection();
                    }
                );
              },
            ),
          ],
          ),
          body: TabBarView(
             controller: _tabController,
             children: widget.myTabs.map((tab){
               return Container(
                 color: Colors.black,
                   child: ListView(
                     shrinkWrap: true,
                   children: <Widget>[
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
                       child: Column(
                         children: <Widget>[
                     Row(
                         children: <Widget>[
                           Text('Balance',style: TextStyle(fontSize: 17, color: Colors.white), textAlign: TextAlign.start,),
                         ]
                     ),
                     Row(
                       children: <Widget>[
                         Container(
                           padding: const EdgeInsets.fromLTRB(0,10,100,10),
                           child: Column(
                             children: <Widget>[
                               Text('Openning',style: tsButton),
                               Text('100\$',style: tsButton),
                             ],
                           ),
                         ),
                         Container(
                           padding: const EdgeInsets.fromLTRB(0,10,0,10),
                           child: Column(
                             children: <Widget>[
                               Text('Closing',style: tsButton),
                               Text('300\$',style: tsButton),
                             ],
                           ),
                         )
                       ],
                     ),
                     ]),
                     ),
                     SizedBox(
                       height: 10,
                     ),
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
                       child: Column(
                         children: <Widget>[
                           Row(
                               children: <Widget>[
                                 Text('Revenue and expenditure \n',style: TextStyle(fontSize: 17, color: Colors.white), textAlign: TextAlign.start,),
                               ]
                           ),
                           Column(
                             children: <Widget>[
                               Row(
                                   children: <Widget>[
                                     Text('Net income',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                                   ]
                               ),
                               Row(
                                   children: <Widget>[
                                     Text('200\$',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                                   ]
                               ),
                             ],
                           )
                         ],
                       ) ,
                     ),
                     SizedBox(
                         width: 400,
                         height: 180,
                         child: Barchart(),
                     ),

                     SizedBox(
                       height: 10,
                     ),
                     Row(
                       children: <Widget>[
                         Container(
                           padding: const EdgeInsets.fromLTRB(15,10,100,10),
                           child: Column(
                             children: <Widget>[
                               Text('Openning',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                               Text('0\$ \n',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                               SizedBox(
                                 width: 90,
                                 height: 90,
                                 child: Piechart(),
                               ),
                             ],
                           ),
                         ),
                         Container(
                           padding: const EdgeInsets.fromLTRB(0,10,0,10),
                           child: Column(
                             children: <Widget>[
                               Text('Closing',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                               Text('0\$ \n',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                               SizedBox(
                                 width: 90,
                                 height: 90,
                                 child: Piechart(),

                               ),
                             ],
                           ),
                         )
                       ],
                     ),
                     SizedBox(
                       height: 10,
                     ),
                     Row(
                       children: <Widget>[
                         Container(
                           padding: const EdgeInsets.fromLTRB(15,10,100,10),
                           child: Column(
                             children: <Widget>[
                               Text('Owe',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                               Text('0\$ \n',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                             ],
                           ),
                         ),
                         Container(
                           padding: const EdgeInsets.fromLTRB(0,10,0,10),
                           child: Column(
                             children: <Widget>[
                               Text('Loan',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                               Text('0\$ \n',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                             ],
                           ),
                         )
                       ],
                     ),
                     Row(
                           children: <Widget>[
                             Text('Other \n100\$',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                           ],
                         )
                   ],
                 ),
                 );
             }).toList(),
         ),
      ),
    );
  }
}
