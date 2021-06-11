import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/add_bill_sceen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bill_detail_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bill_general_detail_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:intl/intl.dart';

class BillCategoryList extends StatefulWidget {
  Wallet currentWallet;
  BillCategoryList({Key key, @required this.currentWallet}) : super(key: key);

  @override
  _BillCategoryListState createState() => _BillCategoryListState();
}

class _BillCategoryListState extends State<BillCategoryList> {

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Color(0xFF111111),
        appBar: AppBar(
          backgroundColor: Color(0xFF111111),
          elevation: 0.0,
          leading: CloseButton(),
          actions: [
            TextButton(
                onPressed: () async {
                  await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return AddBillScreen(
                            currentWallet: widget.currentWallet);
                      });
                  setState(() { });
                },
                child: Text('Add',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              ),
          ],
        ),
      body: buildListBills(context)
    );
  }

  Widget buildListBills(context) {
    String currencySymbol = CurrencyService().findByCode(widget.currentWallet.currencyID).symbol;

    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<List<Bill>>(
        stream: _firestore.billStream(widget.currentWallet.id),
        builder: (context, snapshot) {
          List<Bill> listBills = snapshot.data ?? [];
          if (listBills.length == 0) {
            return Container(
                alignment: Alignment.center,
                child: Text(
                  'No bill',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                )
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child: Text('All Bills',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      )
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemCount: listBills.length,
                    itemBuilder: (context, index) =>
                        buildBillCard(_firestore, listBills[index])
                ),
              ],
            );
          }
        }
    );
  }

  Widget buildBillCard(dynamic _firestore, Bill bill) {
    String currencySymbol = CurrencyService().findByCode(widget.currentWallet.currencyID).symbol;
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => BillGeneralDetailScreen(bill: bill, wallet: widget.currentWallet)
        );
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0xFF1c1c1c),
            border: Border(
                top: BorderSide(
                  color: Colors.white12,
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Colors.white12,
                  width: 0.5,
                ))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SuperIcon(
                  iconPath: bill.category.iconID,
                  size: 50.0,
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(bill.category.name,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                    Text(currencySymbol + ' ' + bill.amount.toString(),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        )),
                  ],
                )
              ],
            ),
            Text(bill.isFinished ? 'Finished' : 'Running',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: bill.isFinished ? Colors.white38 : Color(0xFF51f08d),
                )),
          ],
        ),
      ),
    );
  }

}
