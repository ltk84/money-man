import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart_information_screen.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart_information_screen.dart';
import 'package:money_man/ui/style.dart';
class InformationHomeScreen extends StatefulWidget {
  int index;
  String asset='';
  InformationHomeScreen(int k,String bar)
  {
    this.index = k;
    this.asset = bar;
  }
  @override
  _InformationHomeScreen createState() => _InformationHomeScreen(index,asset);
}
class _InformationHomeScreen extends State<InformationHomeScreen> {
  int _selectedIndex = 0;
  String assettext='';
  static List<Widget> _screens = [
    PieChartInformationScreen(),
    BarChartInformationScreen(),
  ];
  _InformationHomeScreen(int index,String asset){
    _selectedIndex = index ;
    assettext = asset;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: new AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title:Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.insert_chart),
                  onPressed: (){
                    setState(() {
                      _selectedIndex = 1;
                    });
                  }
              ),
              IconButton(
                  icon: Icon(Icons.pie_chart),
                  onPressed: (){
                    setState(() {
                      _selectedIndex = 0;
                    });
                  }
              )
            ],
          ),
        ),
        body:  ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                          Container(
                            padding: const EdgeInsets.fromLTRB(0,10,100,10),
                            child: Column(
                              children: <Widget>[
                                Text((assettext =='Opening balance')?'Opening balance':'Closing balance',style: TextStyle(color: Colors.white)),
                                Text('100\$',style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ]
              ),
            ),
            _screens.elementAt(_selectedIndex),
          ],
        )
    );
  }
}