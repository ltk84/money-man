import 'dart:ui';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/edit_bill_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/transaction_list.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:money_man/ui/widgets/expandable_widget.dart';

class BillGeneralDetailScreen extends StatefulWidget {
  final Bill bill;
  final Wallet wallet;

  const BillGeneralDetailScreen({
    Key key,
    @required this.bill,
    @required this.wallet,
  }) : super(key: key);

  @override
  _BillGeneralDetailScreenState createState() =>
      _BillGeneralDetailScreenState();
}

class _BillGeneralDetailScreenState extends State<BillGeneralDetailScreen> {
  Bill _bill;
  String currencySymbol;

  bool expandDueDates;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bill = widget.bill;
    currencySymbol =
        CurrencyService().findByCode(widget.wallet.currencyID).symbol;
    expandDueDates = false;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
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
                  Icons.close,
                  color: Style.foregroundColor,
                )),
          ),
          title: Hero(
            tag: 'billToDetail_title',
            child: Text('Bills',
                style: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                )),
          ),
          centerTitle: true,
          flexibleSpace: ClipRect(
            child: AnimatedOpacity(
              opacity: 1,
              duration: Duration(milliseconds: 0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 500, sigmaY: 500, tileMode: TileMode.values[0]),
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 1),
                    //child: Container(
                    //color: Colors.transparent,
                    color: Colors.transparent
                    //),
                    ),
              ),
            ),
          ),
          actions: [
            Hero(
              tag: 'billToDetail_actionBtn',
              child: TextButton(
                onPressed: () async {
                  final updatedBill = await showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return EditBillScreen(
                          bill: _bill,
                          wallet: widget.wallet,
                        );
                      });
                  if (updatedBill != null) {
                    setState(() {
                      _bill = updatedBill;
                    });
                  }
                },
                child: Text('Edit',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
                    )),
              ),
            ),
          ],
        ),
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.symmetric(vertical: 5.0),
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
                  children: [
                    buildInfoCategory(
                      iconPath: _bill.category.iconID,
                      display: _bill.category.name,
                    ),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildInfoAmount(amount: _bill.amount),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildNote(display: _bill.note),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildInfoRepeat(listDueDates: _bill.dueDates),
                    // Divider ngăn cách giữa các input field.
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Divider(
                        color: Style.foregroundColor.withOpacity(0.12),
                        thickness: 1,
                      ),
                    ),
                    buildInfoWallet(
                      iconPath: widget.wallet.iconID,
                      display: widget.wallet.name,
                    ),
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 30.0),
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
              child: TextButton(
                onPressed: () async {
                  _bill.isFinished = !_bill.isFinished;
                  await _firestore.updateBill(_bill, widget.wallet);
                  setState(() {});
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF4FCC5C).withOpacity(0.4);
                      else
                        return Color(
                            0xFF4FCC5C); // Use the component's default.
                    },
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        _bill.isFinished
                            ? "Mark as running"
                            : "Mark as finished",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center),
                    SizedBox(width: 8.0),
                    Icon(Icons.check, size: 20.0)
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor2,
                  border: Border(
                      bottom: BorderSide(
                    color: Style.foregroundColor.withOpacity(0.12),
                    width: 0.5,
                  ))),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          childCurrent: this.widget,
                          child: BillTransactionList(
                              transactionListID: _bill.transactionIdList,
                              currentWallet: widget.wallet),
                          type: PageTransitionType.rightToLeft));
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xFF4FCC5C).withOpacity(0.4);
                      else
                        return Color(
                            0xFF4FCC5C); // Use the component's default.
                    },
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("View list Transactions",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center),
                    SizedBox(width: 8.0),
                    Icon(Icons.view_list, size: 20.0)
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor2,
                  border: Border(
                      bottom: BorderSide(
                    color: Style.foregroundColor.withOpacity(0.12),
                    width: 0.5,
                  ))),
              child: TextButton(
                onPressed: () async {
                  await _firestore.deleteBill(_bill, widget.wallet);
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.redAccent.withOpacity(0.4);
                      else
                        return Colors.redAccent; // Use the component's default.
                    },
                  ),
                ),
                child: Text("Delete bill for this category",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
              ),
            )
          ],
        ));
  }

  Widget buildNote({String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: Icon(Icons.notes, color: Colors.white70, size: 24.0)),
          Text(display == null || display == '' ? 'Note' : display,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: display == null || display == ''
                    ? Colors.white24
                    : Colors.white,
              )),
        ],
      ),
    );
  }

  Widget buildInfoAmount({double amount}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.attach_money,
                  color: Style.foregroundColor.withOpacity(0.7), size: 40.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Style.foregroundColor.withOpacity(0.6),
                  )),
              SizedBox(height: 5.0),
              MoneySymbolFormatter(
                text: amount,
                currencyId: widget.wallet.currencyID,
                textStyle: TextStyle(
                  color: Style.foregroundColor,
                  fontFamily: Style.fontFamily,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoCategory({String iconPath, String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: SuperIcon(
                iconPath: iconPath ?? "assets/icons/other.svg",
                size: 34.0,
              )),
          Text(display ?? 'Select category',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: display == null
                    ? Style.foregroundColor.withOpacity(0.24)
                    : Style.foregroundColor,
              )),
        ],
      ),
    );
  }

  Widget buildInfoWallet({String iconPath, String display}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: SuperIcon(
                iconPath: iconPath ?? "assets/icons/wallet_2.svg",
                size: 24.0,
              )),
          Text(display ?? 'Select wallet',
              style: TextStyle(
                fontFamily: Style.fontFamily,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: display == null
                    ? Style.foregroundColor.withOpacity(0.24)
                    : Style.foregroundColor,
              )),
        ],
      ),
    );
  }

  Widget buildInfoRepeat({List<DateTime> listDueDates}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: GestureDetector(
        onTap: () {
          setState(() {
            expandDueDates = !expandDueDates;
          });
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 23.0),
                  child: Icon(Icons.calendar_today,
                      color: Style.foregroundColor.withOpacity(0.7),
                      size: 24.0)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Due dates',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.6),
                      )),
                  Row(
                    children: [
                      Text(
                          listDueDates.length == 0
                              ? 'None'
                              : DateFormat('dd/MM/yyyy')
                                  .format(listDueDates[0]),
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: listDueDates.length == 0
                                ? Style.foregroundColor.withOpacity(0.24)
                                : Style.foregroundColor,
                          )),
                      listDueDates.length < 2
                          ? Container()
                          : Icon(Icons.arrow_drop_down,
                              color: Style.foregroundColorDark)
                    ],
                  ),
                  ExpandableWidget(
                    expand: expandDueDates,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 1; i < listDueDates.length; i++)
                            Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(listDueDates[i]),
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Style.foregroundColor,
                                )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
