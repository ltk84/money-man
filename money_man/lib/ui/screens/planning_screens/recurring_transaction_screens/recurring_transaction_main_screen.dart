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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Style.appBarColor,
        elevation: 0.0,
        leading: Hero(
          tag: 'billToDetail_backBtn',
          child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Style.backIcon,
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
                  fontFamily: 'Montserrat',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                )),
          ),
        ),
        flexibleSpace: ClipRect(
          child: AnimatedOpacity(
            opacity: 1,
            duration: Duration(milliseconds: 0),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 500, sigmaY: 500, tileMode: TileMode.values[0]),
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 1),
                  color: Colors.transparent),
            ),
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
                    fontFamily: 'Montserrat',
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
                  Icon(Icons.arrow_drop_down, color: Colors.grey)
                ],
              ),
            ),
          ),
        ],
      ),
      body: buildListRecurringTransactionList(context),
    );
  }

  Widget buildListRecurringTransactionList(context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<List<RecurringTransaction>>(
        stream: _firestore.recurringTransactionStream(widget.wallet.id),
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
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Text('All',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
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
            color: Style.boxBackgroundColor,
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
                          fontFamily: 'Montserrat',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                    if (reTrans.note != null && reTrans.note != '')
                      Text(reTrans.note,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Style.foregroundColor.withOpacity(0.54),
                          )),
                    SizedBox(
                      height: 2,
                    ),
                    Text('Next occurrence:',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                    Text(
                        DateFormat('EEEE, dd-MM-yyyy')
                            .format(reTrans.repeatOption.beginDateTime),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400,
                          color: Style.foregroundColor.withOpacity(0.7),
                        ))
                  ],
                ),
              ],
            ),
            MoneySymbolFormatter(
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

  Widget buildOverallInfo(
      {String overdue, String forToday, String thisPeriod}) {
    return Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Style.boxBackgroundColor,
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
                  fontFamily: 'Montserrat',
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
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.38),
                    )),
                Text(overdue,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
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
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.38),
                    )),
                Text(forToday,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
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
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor.withOpacity(0.38),
                    )),
                Text(thisPeriod,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
                    ))
              ],
            )
          ],
        ));
  }

  void buildShowDialog(BuildContext context, String id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final _firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Style.boxBackgroundColor,
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: _auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
    final updatedWallet = await _firestore.getWalletByID(result);
    setState(() {
      widget.wallet = updatedWallet;
    });
  }
}
