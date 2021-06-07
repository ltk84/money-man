import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:math_expressions/math_expressions.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screen/edit_budget.dart';

import 'line_chart_progress.dart';

class BudgetDetailScreen extends StatefulWidget {
  const BudgetDetailScreen({Key key, this.budget, this.wallet})
      : super(key: key);
  final Budget budget;
  final Wallet wallet;

  @override
  _BudgetDetailScreenState createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  bool isNotifi = false;
  String valueDate(Budget budget) {
    String result = DateFormat('dd/MM/yyyy').format(budget.beginDate) +
        ' - ' +
        DateFormat('dd/MM/yyyy').format(budget.endDate);
    return result;
  }

  String TimeLeft(Budget budget) {
    var today = DateTime.now();
    if (today.isBefore(budget.beginDate)) {
      int n = budget.beginDate.difference(today).inDays;
      if (n > 1) {
        return '$n days to begin';
      } else
        return '$n day to begin';
    } else if (today.isAfter(budget.endDate)) {
      return 'Finished';
    } else {
      int n = budget.endDate.difference(today).inDays;
      if (n > 1) {
        return '$n days left';
      } else
        return '$n day left';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isStart;
    DateTime today = DateTime.now();
    var todayRate = today.difference(widget.budget.beginDate).inDays /
        widget.budget.endDate.difference(widget.budget.beginDate).inDays;
    if (today.isBefore(widget.budget.beginDate))
      isStart = false;
    else
      isStart = true;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_sharp),
        ),
        title: Text('Budget'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () async {
                var result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditBudget(
                            budget: widget.budget,
                            wallet: widget.wallet,
                          )),
                );
                if (result != null) Navigator.pop(context);
              }),
          IconButton(
              icon: Icon(Icons.delete, color: Colors.white), onPressed: () {})
        ],
        backgroundColor: Color(0xff333333),
      ),
      body: Container(
        color: Color(0xff1a1a1a),
        child: ListView(
          children: [
            ListTile(
              leading: Container(
                  child: SuperIcon(
                iconPath: widget.budget.category.iconID,
                size: 45,
              )),
              title: Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.budget.category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        MoneyFormatter(amount: this.widget.budget.amount)
                            .output
                            .withoutFractionDigits,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spent',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      MoneyFormatter(
                                              amount: this.widget.budget.spent)
                                          .output
                                          .withoutFractionDigits,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              /*Expanded(child: Container(

                              )),*/
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Remain',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      MoneyFormatter(
                                              amount:
                                                  this.widget.budget.amount -
                                                      this.widget.budget.spent)
                                          .output
                                          .withoutFractionDigits,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                  backgroundColor: Color(0xff333333),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF2FB49C)),
                                  minHeight: 8,
                                  value: this.widget.budget.spent /
                                      this.widget.budget.amount),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                widget.budget.beginDate.isAfter(today) ||
                        today.isAfter(widget.budget.endDate)
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(
                            left: 60 +
                                (MediaQuery.of(context).size.width - 60 - 45) *
                                    todayRate),
                        height: 20,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xff171717)),
                        child: Text(
                          "Today",
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
              ],
            ),
            ListTile(
              leading: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.date_range_outlined,
                    color: Colors.white,
                  )),
              title: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  valueDate(widget.budget),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              subtitle: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  TimeLeft(widget.budget),
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.only(left: 10),
                child: SuperIcon(
                  iconPath: '${widget.wallet.iconID}',
                  size: 25,
                ),
              ),
              title: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  '${widget.wallet.name}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LineCharts()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 15, right: 30),
                color: Color(0xff1a1a1a),
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: LineCharts(),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Should spend/day ',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          MoneyFormatter(
                                  amount: widget.budget.amount /
                                      (widget.budget.endDate)
                                          .difference(widget.budget.beginDate)
                                          .inDays)
                              .output
                              .withoutFractionDigits,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Actual spend/ day',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          MoneyFormatter(
                                  amount: widget.budget.spent /
                                      (today)
                                          .difference(widget.budget.beginDate)
                                          .inDays)
                              .output
                              .withoutFractionDigits,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    )
                  ]),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Expected spending',
                        style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      Text(
                        MoneyFormatter(
                                amount: widget.budget.spent /
                                    (today)
                                        .difference(widget.budget.beginDate)
                                        .inDays *
                                    (widget.budget.endDate)
                                        .difference(widget.budget.beginDate)
                                        .inDays)
                            .output
                            .withoutFractionDigits,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  )
                ],
              ),
            ),
            Divider(
              color: Color(0xff333333),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Turn on notification',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                      value: isNotifi,
                      onChanged: (val) {
                        setState(() {
                          isNotifi = !isNotifi;
                        });
                      })
                ],
              ),
            ),
            Divider(
              color: Color(0xff333333),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF2FB49C),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Transaction list',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
