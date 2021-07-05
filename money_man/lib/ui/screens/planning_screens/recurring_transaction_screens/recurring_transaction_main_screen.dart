import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/recurring_transaction_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/recurring_transaction_screens/add_recurring_transaction_sceen.dart';
import 'package:money_man/ui/screens/planning_screens/recurring_transaction_screens/recurring_transaction_detail_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class RecurringTransactionMainScreen extends StatefulWidget {
  Wallet wallet;
  RecurringTransactionMainScreen({
    Key key,
    @required this.wallet,
  }) : super(key: key);

  @override
  _RecurringTransactionMainScreenState createState() =>
      _RecurringTransactionMainScreenState();
}

class _RecurringTransactionMainScreenState
    extends State<RecurringTransactionMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        backgroundColor: Style.boxBackgroundColor.withOpacity(0.2),
        elevation: 0.0,
        leading: Hero(
          tag: 'billToDetail_backBtn',
          child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Style.foregroundColor,
              )),
        ),
        centerTitle: true,
        title: Hero(
          tag: 'billToDetail_title',
          child: Material(
            color: Colors.transparent,
            child: Text('Recurring transactions',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                )),
          ),
        ),
        actions: [
          Hero(
            tag: 'billToDetail_actionBtn',
            child: TextButton(
              onPressed: () async {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddRecurringTransactionScreen(
                          wallet: widget.wallet);
                    });
              },
              child: Text('Add',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor,
                  )),
            ),
          ),
          GestureDetector(
            onTap: () async {
              buildShowDialog(context, widget.wallet.id);
            },
            child: Container(
              child: Row(
                children: [
                  SuperIcon(
                    iconPath: widget.wallet.iconID,
                    size: 25.0,
                  ),
                  Icon(Icons.arrow_drop_down,
                      color: Style.foregroundColor.withOpacity(0.54))
                ],
              ),
            ),
          ),
        ],
      ),
      body: buildListRecurringTransactionList(context),
    );
  }

  // Hàm build danh sach giao dịch lặp lại.
  Widget buildListRecurringTransactionList(context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<List<RecurringTransaction>>(
        stream: firestore.recurringTransactionStream(widget.wallet.id),
        builder: (context, snapshot) {
          List<RecurringTransaction> reTransList = snapshot.data ?? [];
          if (reTransList.length == 0)
            return Container(
                color: Style.backgroundColor,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      color: Style.foregroundColor.withOpacity(0.12),
                      size: 100,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'There are no recurring transactions',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.24),
                      ),
                    ),
                  ],
                ));
          return ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text('All',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.7),
                    )),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reTransList.length,
                  itemBuilder: (context, index) =>
                      buildRecurringTransactionCard(reTransList[index])),
            ],
          );
        });
  }

  // Hàm build thẻ cho giao dịch lặp lại.
  Widget buildRecurringTransactionCard(RecurringTransaction reTrans) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                childCurrent: widget,
                child: RecurringTransactionDetailScreen(
                  recurringTransaction: reTrans,
                  wallet: widget.wallet,
                ),
                type: PageTransitionType.rightToLeft));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                  iconPath: reTrans.category.iconID,
                  size: 40.0,
                ),
                SizedBox(width: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(reTrans.category.name,
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                    if (reTrans.note != null && reTrans.note != '')
                      Text(
                          reTrans.note.length >= 20
                              ? reTrans.note.substring(0, 19) + '...'
                              : reTrans.note,
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Style.foregroundColor.withOpacity(0.54),
                          )),
                    SizedBox(
                      height: 2,
                    ),
                    Text('Next occurrence:',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                    Text(
                        DateFormat('EEEE, dd-MM-yyyy')
                            .format(reTrans.repeatOption.beginDateTime),
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Style.foregroundColor.withOpacity(0.7),
                        ))
                  ],
                ),
              ],
            ),
            MoneySymbolFormatter(
              checkOverflow: true,
              text: reTrans.amount,
              currencyId: widget.wallet.currencyID,
              textStyle: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0),
            )
          ],
        ),
      ),
    );
  }

  // Hàm build thông tin chung.
  Widget buildOverallInfo(
      {String overdue, String forToday, String thisPeriod}) {
    return Container(
        padding: EdgeInsets.all(20.0),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remaining Bills',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                )),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overdue',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.38),
                    )),
                Text(overdue,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
                    ))
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('For today',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.38),
                    )),
                Text(forToday,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
                    ))
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('This period',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.38),
                    )),
                Text(thisPeriod,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
                    ))
              ],
            )
          ],
        ));
  }

  // Hàm hiển thị chọn wallet.
  void buildShowDialog(BuildContext context, String id) async {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Style.boxBackgroundColor,
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
    final updatedWallet = await firestore.getWalletByID(result);
    setState(() {
      widget.wallet = updatedWallet;
    });
  }
}
