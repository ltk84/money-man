import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';

class Wallet_Selection extends StatefulWidget {
  @override
  _Wallet_SelectionState createState() => _Wallet_SelectionState();
}

class _Wallet_SelectionState extends State<Wallet_Selection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Scaffold(
          backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: 70.0,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.grey[900],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)
                )),
          leading: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                  'Close',
                  style: tsButton,
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )
          ),
          title: Text('Select Wallet', style: tsMain),
          actions: <Widget>[
            TextButton(
                onPressed: () {},
                child: const Text(
                    'Edit',
                    style: tsButton,
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.transparent,
                )
            ),
          ],
        ),
        body: Container(
          color: Colors.black87,
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border(
                        top: BorderSide(
                          color: Colors.grey[900],
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey[900],
                          width: 1.0,
                        )
                    )
                ),
                child: Row (
                  children: [
                    Expanded(
                        flex: 1,
                        child: Icon(Icons.all_inclusive_outlined, color: Colors.white)
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Total',
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
                        flex: 1,
                        child: Icon(Icons.check, color: Colors.blue)
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 5.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                      'List',
                      style: tsChild_Sec,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border(
                        top: BorderSide(
                          color: Colors.grey[900],
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.grey[900],
                          width: 1.0,
                        )
                    )
                ),
                child: Row (
                  children: [
                    Expanded(
                        flex: 1,
                        child: Icon(Icons.account_balance_wallet_outlined, color: Colors.white),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Wallet',
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
                        flex: 1,
                        child: Icon(Icons.check, color: Colors.blue)
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  height: 33,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border(
                          top: BorderSide(
                            color: Colors.grey[900],
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey[900],
                            width: 1.0,
                          )
                      )
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Add wallet', style: tsButton_wallet),
                    //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(success)),
                  )
              ),
              Container(
                  height: 33,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border(
                          top: BorderSide(
                            color: Colors.grey[900],
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey[900],
                            width: 1.0,
                          )
                      )
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: Text('Link to services', style: tsButton_wallet),
                    //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(success)),
                  )
              ),
            ],
          ),
        )
      ),
    );
  }
}
