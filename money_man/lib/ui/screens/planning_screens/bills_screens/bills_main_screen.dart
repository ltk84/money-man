import 'dart:ui';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/bill_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/add_bill_sceen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bill_category_list_screen.dart';
import 'package:money_man/ui/screens/planning_screens/bills_screens/bill_detail_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
        backgroundColor: Style.backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: Hero(
            tag: 'billToDetail_backBtn',
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  color: Style.foregroundColor,
                )),
          ),
          title: GestureDetector(
              onTap: () {
                showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => BillCategoryList(currentWallet: widget.currentWallet)
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'billToDetail_title',
                    child: Text('Bills',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                  ),
                  Icon(Icons.arrow_drop_down, color: Style.foregroundColorDark)
                ],
              ),
            ),
          centerTitle: true,
          flexibleSpace: ClipRect(
            child: AnimatedOpacity(
              opacity: 1,
              duration: Duration(milliseconds: 0),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 25,
                    sigmaY: 25,
                    tileMode: TileMode.values[0]),
                child: AnimatedContainer(
                  duration: Duration(
                      milliseconds: 100),
                  color: Colors.grey[900].withOpacity(0.2),
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
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Style.foregroundColor,
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
                    Icon(Icons.arrow_drop_down, color: Style.foregroundColorDark)
                  ],
                ),
              ),
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

          List<Map> overDueBills = [];
          List<Map> todayBills = [];
          List<Map> thisPeriodBills = [];

          listBills.forEach((element) {
            element.updateDueDate();
            //_firestore.updateBill(element, widget.currentWallet);

            var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

            element.dueDates.forEach((e) {
              if (e.compareTo(now) == 0) {
                todayBills.add({'bill': element, 'due': e});
              } else if (e.compareTo(now) > 0) {
                thisPeriodBills.add({'bill': element, 'due': e});
              } else {
                overDueBills.add({'bill': element, 'due': e});
              }
            });
          });
          if (overDueBills.length == 0 && todayBills.length == 0 && thisPeriodBills.length == 0) {
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
                      'There are no bills to pay',
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
            return ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                buildOverallInfo(
                    overdue: '$currencySymbol ' + overDueBills.fold(
                        0, (value, element) => value + element['bill'].amount)
                        .toString(),
                    forToday: '$currencySymbol ' + todayBills.fold(
                        0, (value, element) => value + element['bill'].amount)
                        .toString(),
                    thisPeriod: '$currencySymbol ' + thisPeriodBills.fold(
                        0, (value, element) => value + element['bill'].amount)
                        .toString()),
                SizedBox(height: 20.0),
                buildListDue(_firestore, overDueBills, 0),
                buildListDue(_firestore, todayBills, 1),
                buildListDue(_firestore, thisPeriodBills, 2),
              ],
            );
          }
        }
    );
  }

  Widget buildListDue (dynamic _firestore, List<Map> listDue, int dueState) {
    String title;

    switch (dueState) {
      case 0:
        title = 'OVERDUE';
        break;
      case 1:
        title = 'TODAY';
        break;
      case 2:
        title = 'THIS PERIOD';
        break;
    }

    if (listDue.length == 0) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          child: Text(title,
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
            itemCount: listDue.length,
            itemBuilder: (context, index) =>
                buildBillCard(_firestore, listDue[index], dueState)
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget buildBillCard(dynamic _firestore, Map info, int dueState) {
    String currencySymbol = CurrencyService().findByCode(widget.currentWallet.currencyID).symbol;
    String payContent = info['bill'].isFinished ? 'Finished' : 'PAY $currencySymbol ' + info['bill'].amount.toString();
    String dueDate = DateFormat('dd/MM/yyyy').format(info['due']);
    String dueDescription;

    var now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    switch (dueState) {
      case 0:
        dueDescription = 'Overdue';
        break;
      case 1:
        dueDescription = 'Due today';
        break;
      case 2:
        dueDescription = 'Due in ' + info['due'].difference(now).inDays.toString() + ' day(s)';
        break;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                childCurrent: this.widget,
                child: BillDetailScreen(
                  bill: info['bill'],
                  dueDate: info['due'],
                  description: dueDescription,
                  wallet: widget.currentWallet,
                ),
                type: PageTransitionType.rightToLeft));
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 14, 20, 8),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SuperIcon(
              iconPath: info['bill'].category.iconID,
              size: 38.0,
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info['bill'].category.name,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )),
                Text('Due day is $dueDate',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Style.foregroundColor.withOpacity(0.7),
                    )),
                SizedBox(height: 8.0),
                Text(dueDescription,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )
                ),
                TextButton(
                  onPressed: () async {
                    if (!info['bill'].isFinished) {
                      // Xử lý thêm transaction từ bill.
                      MyTransaction transFromBill;
                      transFromBill = MyTransaction(
                          id: 'id',
                          amount: info['bill'].amount,
                          note: info['bill'].note,
                          date: now,
                          currencyID: widget.currentWallet.currencyID,
                          category: info['bill'].category);
                      await _firestore.addTransaction(widget.currentWallet, transFromBill);

                      // Thêm transaction vào bill.
                      if (!info['bill'].transactionIdList.contains(transFromBill.id)) {
                        info['bill'].transactionIdList.add(transFromBill.id);
                      }

                      // Xử lý các dueDate. (Thanh toán rồi thì dueDate sẽ được cho vào list due Dates đã thanh toán,
                      // và xóa khỏi list due Dates chưa thanh toán.
                      if (!info['bill'].paidDueDates.contains(info['due'])) {
                        info['bill'].paidDueDates.add(info['due']);
                        info['bill'].dueDates.remove(info['due']);
                      }

                      // Cập nhật thông tin bill lên firestore.
                      await _firestore.updateBill(
                          info['bill'], widget.currentWallet);

                      if (this.mounted) {
                        setState(() { });
                      } // tránh bị lỗi setState() được call sau khi dispose().

                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return !info['bill'].isFinished ? Colors.white : Color(0xFFcccccc);
                        else
                          return !info['bill'].isFinished ? Color(
                              0xFF4FCC5C) : Color(0xFFcccccc); // Use the component's default.
                      },
                    ),
                    foregroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return !info['bill'].isFinished ? Color(0xFF4FCC5C) : Color(0xFFA8a8a8);
                        else
                          return !info['bill'].isFinished ? Colors
                              .white : Color(0xFFA8a8a8); // Use the component's default.
                      },
                    ),
                  ),
                  child: Text(
                      payContent,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: Style.fontFamily,
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

  void buildShowDialog(BuildContext context, id) async {
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
      widget.currentWallet = updatedWallet;
    });
  }
}
