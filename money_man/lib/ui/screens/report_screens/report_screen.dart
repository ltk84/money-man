import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/ui/screens/report_screens/analytic_revenue_expenditure_screen.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/chart_information_home_screen.dart';
import 'package:money_man/ui/screens/report_screens/pie_chart.dart';
import 'package:money_man/ui/screens/report_screens/time_selection.dart';
import '../../style.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:provider/provider.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';


class ReportScreen extends StatefulWidget{
  Wallet currentWallet;

  ReportScreen({Key key, this.currentWallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ReportScreen();
  }
}

class _ReportScreen extends State<ReportScreen> with TickerProviderStateMixin {
  Wallet _wallet;

  // Khởi tạo mốc thời gian cần thống kê.
  DateTime beginDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  String dateDescript = 'This month';

  @override
  void initState() {
    super.initState();
    _wallet = widget.currentWallet == null
        ? Wallet(
        id: 'id',
        name: 'defaultName',
        amount: 0,
        currencyID: 'USD',
        iconID: 'a')
        : widget.currentWallet;
  }

  @override
  void didUpdateWidget(covariant ReportScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    _wallet = widget.currentWallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'a',
            iconID: 'b');
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
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
          title: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: <Widget>[
                    Text(dateDescript, style:TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    Text(DateFormat('dd/MM/yyyy').format(beginDate) + " - " + DateFormat('dd/MM/yyyy').format(endDate), style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_drop_down, color: Colors.white),
              ],
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.ios_share, color: Colors.white),
              onPressed: (){},
            ),
          ],
        ),
        body: StreamBuilder<Object>(
          stream: _firestore.transactionStream(_wallet),
          builder: (context, snapshot) {
            List<MyTransaction> _transactionList = snapshot.data ?? [];

            double openingBalance = 0;
            double closingBalance = 0;
            double income = 0;
            double expense = 0;

            _transactionList.forEach((element) {
                if (element.date.isBefore(beginDate)) {
                  if (element.category.type == 'expense')
                    openingBalance -= element.amount;
                  else
                    openingBalance += element.amount;
                }
                if (element.date.compareTo(endDate) <= 0){
                  if (element.category.type == 'expense') {
                    closingBalance -= element.amount;
                    if (element.date.compareTo(beginDate) >= 0)
                      expense += element.amount;
                  }
                  else {
                    closingBalance += element.amount;
                    if (element.date.compareTo(beginDate) >= 0)
                      income += element.amount;
                  }
                }
            });
            _transactionList = _transactionList
                .where((element) => element.date.compareTo(beginDate) >= 0  && element.date.compareTo(endDate) <= 0).toList();
            return Container(
                  color: Colors.black,
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[900],
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: Colors.grey[900],
                                  width:1.0,
                                )
                            )
                        ),
                        child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text('Opening',style: TextStyle(color: Colors.white)),
                                        Text(openingBalance.toString(),style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text('Closing',style: TextStyle(color: Colors.white)),
                                        Text(closingBalance.toString(),style: TextStyle(color: Colors.white)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ]),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey[900],
                                  width: 1.0,
                                ),
                                top: BorderSide(
                                  color: Colors.grey[900],
                                  width:1.0,
                                )
                            )
                        ),
                        child: Column(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text('Net Income',style: TextStyle(color: Colors.white)),
                                Text((closingBalance - openingBalance).toString(),style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            Container(
                              width: 450,
                              height: 200,
                              child: BarChartScreen(currentList: _transactionList, beginDate: beginDate, endDate: endDate),
                            ),
                          ]
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                  children: <Widget>[
                                    Text('Income',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                                    Text(income.toString(),style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                                    Container(
                                      width: 90,
                                      height: 90,
                                      child: PieChartScreen(), //InformationHomeScreen
                                    ),
                                  ],
                                ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text('Expense',style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                                  Text(expense.toString(),style: TextStyle(fontSize: 14.5, color: Colors.white), textAlign: TextAlign.start,),
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: PieChartScreen(),
                                  ),
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
          }
        )
      ),
    );
  }
}