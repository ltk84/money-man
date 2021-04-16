import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';

class Wallet_Selection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Scaffold(
          backgroundColor: secondaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)
                )),
          leading: TextButton(
              onPressed: () {},
              child: const Text(
                  'Close',
                  style: tsButton,
              ),
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Colors.transparent,
              )
          ),
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
        body: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
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
                      )
                  )
              ),
              child: Row (
                children: [
                  Expanded(
                      flex: 1,
                      child: Icon(Icons.all_inclusive_outlined)
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
                      child: Icon(Icons.check)
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
                    style: tsChild,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
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
                      )
                  )
              ),
              child: Row (
                children: [
                  Expanded(
                      flex: 1,
                      child: Icon(Icons.account_balance_wallet_outlined),
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
                      child: Icon(Icons.check)
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
                    border: Border(
                        top: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        )
                    )
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text('Add wallet', style: tsButton),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(success)),
                )
            ),
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
                        )
                    )
                ),
                child: TextButton(
                  onPressed: () {},
                  child: Text('Link to services', style: tsButton),
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(success)),
                )
            ),
          ],
        )
      ),
    );
  }
}
