import 'dart:ui';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/delete_dialog.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/edit_bill_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/transaction_list.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends StatefulWidget {
  final Bill bill;
  final Wallet wallet;
  final DateTime dueDate;
  final String description;

  const BillDetailScreen({
    Key key,
    @required this.bill,
    @required this.wallet,
    @required this.dueDate,
    @required this.description,
  }) : super(key: key);

  @override
  _BillDetailScreenState createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  Bill _bill;
  String currencySymbol;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bill = widget.bill;
    currencySymbol =
        CurrencyService().findByCode(widget.wallet.currencyID).symbol;
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
                  Style.backIcon,
                  color: Style.foregroundColor,
                )),
          ),
          title: Hero(
            tag: 'billToDetail_title',
            child: Material(
              color: Colors.transparent,
              child: Text('Bill',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                  )),
            ),
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
                    buildInfoRepeat(
                        dueDate:
                            DateFormat('dd/MM/yyyy').format(widget.dueDate),
                        dueDescription: widget.description),
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
                  final type = await showMaterialModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        backgroundColor: Style.boxBackgroundColor2,
                        context: context,
                        builder: (context) => DeleteDialog(),
                      ) ??
                      'none';
                  if (type == 'all') {
                    await _firestore.deleteBill(_bill, widget.wallet);
                  } else if (type == 'only') {
                    // Xử lý các dueDate. (Thanh toán rồi thì dueDate sẽ được cho vào list due Dates đã thanh toán,
                    // và xóa khỏi list due Dates chưa thanh toán.
                    if (_bill.dueDates.contains(widget.dueDate))
                      _bill.dueDates.remove(widget.dueDate);

                    if (!_bill.paidDueDates.contains(widget.dueDate)) {
                      _bill.paidDueDates.add(widget.dueDate);
                    }

                    // Cập nhật thông tin bill lên firestore.
                    await _firestore.updateBill(_bill, widget.wallet);
                  }
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
                child: Text("Delete",
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

  Widget buildInfoRepeat({String dueDate, String dueDescription}) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 8, 15, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 23.0),
              child: Icon(Icons.calendar_today,
                  color: Style.foregroundColor.withOpacity(0.7), size: 24.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dueDate ?? '',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                  )),
              Text(dueDescription ?? '',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Style.foregroundColor.withOpacity(0.7),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
