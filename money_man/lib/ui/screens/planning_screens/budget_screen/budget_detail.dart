import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'line_chart_progress.dart';

class BudgetDetailScreen extends StatelessWidget {
  const BudgetDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {}),
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
                  child: Icon(
                Icons.circle,
                color: Colors.white,
                size: 45,
              )),
              title: Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Food & Beverage',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        '5,000,000 đ',
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
                                      '570,000 đ',
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
                                      '4,430,000 đ',
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
                                value: 0.5,
                              ),
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
                SizedBox(
                  width: 55,
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width - 95) * 0.5),
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
                  'May 2021',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              subtitle: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  '2 days remain',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.cloud_circle_sharp,
                  color: Colors.white,
                ),
              ),
              title: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  'Cash',
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
                          'Amount/ day',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          '4,994,000 đ',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Amount/ day',
                          style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          '4,994,000 đ',
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
                        'Realitic spent per day',
                        style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      Text(
                        '5.156 đ',
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
                  Switch(value: true, onChanged: (val) {})
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
