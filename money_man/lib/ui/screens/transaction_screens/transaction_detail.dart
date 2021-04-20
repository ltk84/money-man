import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../style.dart';

class TransactionDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: textColor),
          onPressed: () {},
        ),
        title: const Text('Transactions', style: tsAppBar),
        actions: <Widget>[
          TextButton(
              onPressed: () {},
              child: const Text('Edit', style: tsAppBar),
              style: TextButton.styleFrom(
                primary: textColor,
                backgroundColor: Colors.transparent,
              )),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              color: Colors.black,
              width: 1.0,
            ))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(Icons.local_pizza, size: 70),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '(Category)',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Note',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5)),
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text('(amount)',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        height: 1.5))),
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(
                      color: Colors.black,
                      thickness: 0.5,
                      indent: 15.0,
                      endIndent: 15.0,
                      height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1, child: Icon(Icons.calendar_today_rounded)),
                      Expanded(
                          flex: 3,
                          child: Text(DateTime.now().toString(),
                              style: tsRegular)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1, child: Icon(Icons.account_balance_wallet)),
                      Expanded(
                          flex: 3, child: Text('Wallet', style: tsRegular)),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budget",
                      style: tsMain,
                    ),
                    Text(
                      "Lorem ipsum",
                      style: tsChild,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 1, child: Icon(Icons.local_pizza, size: 35)),
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '(Category)',
                                          style: tsMain,
                                        ),
                                        Text(
                                          '(amount)',
                                          style: tsChild,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '(Total)',
                                            style: tsMain,
                                          ),
                                          Text(
                                            'Left (amount)',
                                            style: tsChild,
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                              LinearProgressIndicator(
                                value: 0.5,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.greenAccent),
                                backgroundColor: Colors.black26,
                                minHeight: 4,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 33,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ))),
              child: TextButton(
                onPressed: () {},
                child: Text('Share', style: tsButton),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(highlight)),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              height: 33,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ))),
              child: TextButton(
                onPressed: () {},
                child: Text('Delete transaction', style: tsButton),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(warning)),
              )),
        ],
      ),
    );
  }
}
