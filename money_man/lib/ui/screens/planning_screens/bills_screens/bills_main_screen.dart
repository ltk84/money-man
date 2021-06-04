import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/add_bill_sceen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bill_detail_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/edit_bill_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class BillsMainScreen extends StatefulWidget {
  Wallet currentWallet;

  BillsMainScreen({Key key, @required this.currentWallet}) : super(key: key);

  @override
  _BillsMainScreenState createState() => _BillsMainScreenState();
}

class _BillsMainScreenState extends State<BillsMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.grey[900].withOpacity(0.2),
          elevation: 0.0,
          leading: Hero(
            tag: 'billToDetail_backBtn',
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                )),
          ),
          title: Hero(
            tag: 'billToDetail_title',
            child: Text('Bills',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
                  showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return AddBillScreen(
                            currentWallet: widget.currentWallet);
                      });
                },
                child: Text('Add',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    )),
              ),
            ),
            GestureDetector(
              onTap: () async {
                buildShowDialog(context, widget.currentWallet.id);
              },
              child: Container(
                child: Row(
                  children: [
                    SuperIcon(
                      iconPath: widget.currentWallet.iconID,
                      size: 25.0,
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey)
                  ],
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            buildOverallInfo(
                overdue: '\$ 1,000',
                forToday: '\$ 1,000',
                thisPeriod: '\$ 1,000'),
            SizedBox(height: 20.0),
            buildListBills(context),
          ],
        ));
  }

  Widget buildListBills(context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Text('THIS PERIOD',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              )),
        ),
        StreamBuilder<List<Bill>>(
            stream: _firestore.billStream(widget.currentWallet.id),
            builder: (context, snapshot) {
              List<Bill> listBills = snapshot.data ?? [];
              if (listBills.length == 0) return Container();
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: listBills.length,
                  itemBuilder: (context, index) =>
                      buildBillCard(listBills[index]));
            }
        ),
      ],
    );
  }

  Widget buildBillCard(Bill bill) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                childCurrent: this.widget,
                child: BillDetailScreen(
                  bill: bill,
                  wallet: widget.currentWallet,
                ),
                type: PageTransitionType.rightToLeft));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 8),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SuperIcon(
              iconPath: bill.category.iconID,
              size: 38.0,
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bill.category.name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
                Text('Next bill is 02/06/2021',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    )),
                SizedBox(height: 8.0),
                Text('Due in 1 day',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    )),
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        else
                          return Color(
                              0xFF4FCC5C); // Use the component's default.
                      },
                    ),
                    foregroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xFF4FCC5C);
                        else
                          return Colors
                              .white; // Use the component's default.
                      },
                    ),
                  ),
                  child: Text("PAY \$ 1,000",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center),
                )
              ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Remaining Bills',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
                      color: Colors.white38,
                    )),
                Text(overdue,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
                      color: Colors.white38,
                    )),
                Text(forToday,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
                      color: Colors.white38,
                    )),
                Text(thisPeriod,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ))
              ],
            )
          ],
        ));
  }

  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final _firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);

    final result = await showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.grey[900],
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
      widget.currentWallet = updatedWallet;
    });
  }
}
