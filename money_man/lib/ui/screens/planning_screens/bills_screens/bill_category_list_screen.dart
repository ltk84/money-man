import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/add_bill_sceen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bill_general_detail_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:currency_picker/currency_picker.dart';

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
      backgroundColor: Style.backgroundColor1,
        appBar: AppBar(
          backgroundColor: Style.boxBackgroundColor2,
          elevation: 0.0,
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
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
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
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
                color: Style.backgroundColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty,
                      color: Style.foregroundColor.withOpacity(0.12),
                      size: 100,
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'No bill',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.24),
                      ),
                    ),
                  ],
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
                        fontFamily: Style.fontFamily,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.7),
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
            color: Style.boxBackgroundColor2,
            border: Border(
                top: BorderSide(
                  color: Style.foregroundColor.withOpacity(0.12),
                  width: 0.5,
                ),
                bottom: BorderSide(
                  color: Style.foregroundColor.withOpacity(0.12),
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
                          fontFamily: Style.fontFamily,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                    if (bill.note != null && bill.note != '')
                      Text(
                          bill.note,
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0,
                            color: Style.foregroundColor.withOpacity(0.54),
                          )
                      ),
                    SizedBox(height: 2,),
                    MoneySymbolFormatter(
                      text: bill.amount,
                      currencyId: widget.currentWallet.currencyID,
                      textStyle: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Style.foregroundColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Text(bill.isFinished ? 'Finished' : 'Running',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: bill.isFinished ? Style.foregroundColor.withOpacity(0.38) : Style.runningColor,
                )),
          ],
        ),
      ),
    );
  }

}
