import 'dart:ui';
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
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
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
                  Style.backIcon,
                  color: Style.foregroundColor,
                )),
          ),
          title: GestureDetector(
            onTap: () {
              showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) =>
                      BillCategoryList(currentWallet: widget.currentWallet));
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'billToDetail_title',
                  child: Material(
                    color: Colors.transparent,
                    child: Text('Bills',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600,
                          color: Style.foregroundColor,
                        )),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Style.foregroundColorDark)
              ],
            ),
          ),
          centerTitle: true,
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
                    Icon(Icons.arrow_drop_down,
                        color: Style.foregroundColorDark)
                  ],
                ),
              ),
            ),
          ],
        ),
        body: buildListBills(context));
  }

  Widget buildListBills(context) {
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<List<Bill>>(
        stream: firestore.billStream(widget.currentWallet.id),
        builder: (context, snapshot) {
          List<Bill> listBills = snapshot.data ?? [];

          // Các danh sách hóa đơn theo trạng thái thời gian.
          List<Map> overDueBills = [];
          List<Map> todayBills = [];
          List<Map> thisPeriodBills = [];

          listBills.forEach((element) {
            // Cập nhật ngày đáo hạn.
            element.updateDueDate();

            // Ngày hiện tại.
            var now = DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day);

            // Thêm các hóa đơn theo trạng thái thời gian vào danh sách.
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
          if (overDueBills.length == 0 &&
              todayBills.length == 0 &&
              thisPeriodBills.length == 0) {
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
                      'There are no bills to pay',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.24),
                      ),
                    ),
                  ],
                ));
          } else {
            return ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                buildOverallInfo(
                    overdue: overDueBills.fold(
                        0, (value, element) => value + element['bill'].amount),
                    forToday: todayBills.fold(
                        0, (value, element) => value + element['bill'].amount),
                    thisPeriod: thisPeriodBills.fold(
                        0, (value, element) => value + element['bill'].amount)),
                SizedBox(height: 20.0),
                buildListDue(firestore, overDueBills, 0), // Build hóa đơn quá hạn.
                buildListDue(firestore, todayBills, 1), // Build hóa đơn vào hôm nay.
                buildListDue(firestore, thisPeriodBills, 2), // Build hoa đơn kỳ kế tiếp.
              ],
            );
          }
        });
  }

  // Hàm build các danh sách hóa đơn theo trạng thái thời gian.
  Widget buildListDue(dynamic firestore, List<Map> listDue, int dueState) {
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
                buildBillCard(firestore, listDue[index], dueState)),
        SizedBox(height: 20.0),
      ],
    );
  }

  // Hàm build thẻ hóa đơn.
  Widget buildBillCard(dynamic firestore, Map info, int dueState) {
    // Biến lưu thông tin ngày đáo hạn.
    String dueDate = DateFormat('dd/MM/yyyy').format(info['due']);
    String dueDescription;

    // Ngày hiện tại.
    var now =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // Cập nhật mô tả ngày đáo hạn.
    switch (dueState) {
      case 0:
        dueDescription = 'Overdue';
        break;
      case 1:
        dueDescription = 'Due today';
        break;
      case 2:
        dueDescription = 'Due in ' +
            info['due'].difference(now).inDays.toString() +
            ' day(s)';
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
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SuperIcon(
                  iconPath: info['bill'].category.iconID,
                  size: 40.0,
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
                    if (info['bill'].note != null && info['bill'].note != '')
                      Text(info['bill'].note,
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            color: Style.foregroundColor.withOpacity(0.54),
                          )),
                    SizedBox(
                      height: 2,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Due day is ',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w400,
                            color: Style.foregroundColor.withOpacity(0.7),
                          )),
                      TextSpan(
                          text: dueDate,
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            color: Style.foregroundColor,
                          )),
                    ])),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(dueDescription,
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: Style.foregroundColor,
                    )),
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
                        await firestore.addTransaction(
                            widget.currentWallet, transFromBill);

                        // Thêm transaction vào bill.
                        if (!info['bill']
                            .transactionIdList
                            .contains(transFromBill.id)) {
                          info['bill'].transactionIdList.add(transFromBill.id);
                        }

                        // Xử lý các dueDate. (Thanh toán rồi thì dueDate sẽ được cho vào list due Dates đã thanh toán,
                        // và xóa khỏi list due Dates chưa thanh toán.
                        if (!info['bill'].paidDueDates.contains(info['due'])) {
                          info['bill'].paidDueDates.add(info['due']);
                          info['bill'].dueDates.remove(info['due']);
                        }

                        // Cập nhật thông tin bill lên firestore.
                        await firestore.updateBill(
                            info['bill'], widget.currentWallet);

                        if (this.mounted) {
                          setState(() {});
                        } // tránh bị lỗi setState() được call sau khi dispose().

                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return !info['bill'].isFinished
                                ? Style.foregroundColor
                                : Style.foregroundColor.withOpacity(0.9);
                          else
                            return !info['bill'].isFinished
                                ? Color(0xFF4FCC5C)
                                : Color(
                                    0xFFcccccc);
                        },
                      ),
                      foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return !info['bill'].isFinished
                                ? Color(0xFF4FCC5C)
                                : Style.foregroundColor.withOpacity(0.6);
                          else
                            return !info['bill'].isFinished
                                ? Style.foregroundColor
                                : Style.foregroundColor.withOpacity(
                                    0.8);
                        },
                      ),
                    ),
                    child: (info['bill'].isFinished)
                        ? Text('Finished',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center)
                        : Wrap(
                            children: [
                              Text(
                                'PAY ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              MoneySymbolFormatter(
                                text: info['bill'].amount,
                                currencyId: widget.currentWallet.currencyID,
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ))
              ],
            )
          ],
        ),
      ),
    );
  }

  // Hàm build thông tin chung.
  Widget buildOverallInfo(
      {double overdue, double forToday, double thisPeriod}) {
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
                MoneySymbolFormatter(
                    text: overdue,
                    currencyId: widget.currentWallet.currencyID,
                    textStyle: TextStyle(
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
                MoneySymbolFormatter(
                    text: forToday,
                    currencyId: widget.currentWallet.currencyID,
                    textStyle: TextStyle(
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
                MoneySymbolFormatter(
                    text: thisPeriod,
                    currencyId: widget.currentWallet.currencyID,
                    textStyle: TextStyle(
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
  void buildShowDialog(BuildContext context, id) async {
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
      widget.currentWallet = updatedWallet;
    });
  }
}
