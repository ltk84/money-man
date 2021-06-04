import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screen/select_time_range.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screen/time_range.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:provider/provider.dart';

class AddBudget extends StatefulWidget {
  AddBudget({this.tabController, Key key}) : super(key: key);
  @override
  _AddBudgetState createState() => _AddBudgetState();
  TabController tabController;
}

class _AddBudgetState extends State<AddBudget> {
  Wallet currentWallet;

  BudgetTimeRange mTimeRange;

  double amount;

  MyCategory cate;

  Wallet selectedWallet;

  String note;

  String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Theme(
      data: ThemeData(primaryColor: Colors.white, fontFamily: 'Montserrat'),
      child: Container(
        color: Color(0xff111111),
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(17)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                onTap: () async {
                  final selectCate = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => CategoriesTransactionScreen());
                  if (selectCate != null) {
                    setState(() {
                      this.cate = selectCate;
                    });
                  }
                },
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white70,
                ),
                dense: true,
                leading: SuperIcon(
                  iconPath: cate == null ? 'assets/icons/box.svg' : cate.iconID,
                  size: 35,
                ),
                title: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Choose group:',
                          style:
                              TextStyle(color: white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        onTap: () async {
                          final selectCate =
                              await showCupertinoModalBottomSheet(
                                  isDismissible: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) =>
                                      CategoriesTransactionScreen());
                          if (selectCate != null) {
                            setState(() {
                              this.cate = selectCate;
                            });
                          }
                        },
                        readOnly: true,
                        obscureText: false,
                        cursorColor: Colors.white60,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                        decoration: InputDecoration(
                            hintText: cate == null ? 'Choose group' : cate.name,
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat'),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(17)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                onTap: () async {
                  final resultAmount = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                  if (resultAmount != null)
                    setState(() {
                      print(resultAmount);
                      amount = double.parse(resultAmount);
                    });
                },
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white70,
                ),
                dense: true,
                leading: SuperIcon(
                  iconPath: 'assets/images/coin.svg',
                  size: 30,
                ),
                title: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Target:',
                          style:
                              TextStyle(color: white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        onTap: () async {
                          final resultAmount = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EnterAmountScreen()));
                          if (resultAmount != null)
                            setState(() {
                              print(resultAmount);
                              amount = double.parse(resultAmount);
                            });
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                            hintText: amount == null
                                ? 'Enter amount' //: currencySymbol +
                                : MoneyFormatter(amount: amount)
                                    .output
                                    .withoutFractionDigits,
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat'),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(17)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                onTap: () async {
                  /*final resultAmount = await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SelectTimeRangeScreen()));
                  if (resultAmount != null) setState(() {});*/
                  var resultAmount = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) => SelectTimeRangeScreen());
                  if (resultAmount != null)
                    setState(() {
                      // Change the time ahihi
                    });
                },
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white70,
                ),
                dense: true,
                leading: SuperIcon(
                  iconPath: 'assets/images/time.svg',
                  size: 30,
                ),
                title: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Time range:',
                          style:
                              TextStyle(color: white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        onTap: () async {
                          var resultAmount =
                              await showCupertinoModalBottomSheet(
                                  isDismissible: true,
                                  backgroundColor: Colors.grey[900],
                                  context: context,
                                  builder: (context) =>
                                      SelectTimeRangeScreen());
                          print('object ok');
                          if (resultAmount != null)
                            setState(() {
                              // Change the time ahihi
                              mTimeRange = resultAmount;
                            });
                        },
                        readOnly: true,
                        obscureText: false,
                        cursorColor: Colors.white60,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                        decoration: InputDecoration(
                            hintText: mTimeRange == null
                                ? 'Time range:'
                                : mTimeRange.description == null
                                    ? mTimeRange.TimeRangeString()
                                    : mTimeRange.description,
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat'),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Color(0xff333333),
                  borderRadius: BorderRadius.circular(17)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ListTile(
                onTap: () async {
                  var res = await showCupertinoModalBottomSheet(
                      isDismissible: true,
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) =>
                          SelectWalletAccountScreen(wallet: selectedWallet));
                  if (res != null)
                    setState(() {
                      selectedWallet = res;
                      currencySymbol = CurrencyService()
                          .findByCode(selectedWallet.currencyID)
                          .symbol;
                    });
                },
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white70,
                ),
                dense: true,
                leading: SuperIcon(
                  iconPath: selectedWallet == null
                      ? 'assets/icons/wallet_2.svg'
                      : selectedWallet.iconID,
                  size: 30,
                ),
                title: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Select wallet:',
                          style:
                              TextStyle(color: white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        onTap: () async {
                          var res = await showCupertinoModalBottomSheet(
                              isDismissible: true,
                              backgroundColor: Colors.grey[900],
                              context: context,
                              builder: (context) => SelectWalletAccountScreen(
                                  wallet: selectedWallet));
                          if (res != null)
                            setState(() {
                              selectedWallet = res;
                              currencySymbol = CurrencyService()
                                  .findByCode(selectedWallet.currencyID)
                                  .symbol;
                            });
                        },
                        readOnly: true,
                        obscureText: false,
                        cursorColor: Colors.white60,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Montserrat'),
                        decoration: InputDecoration(
                            hintText: selectedWallet == null
                                ? 'Select wallet'
                                : selectedWallet.name,
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Montserrat'),
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                //TODO: Add new budget
                // await _firestore.updateEvent();
                if (selectedWallet == null) {
                  _showAlertDialog('Please pick your wallet!');
                } else if (amount == null) {
                  _showAlertDialog('Please enter amount!');
                } else if (cate == null) {
                  _showAlertDialog('Please pick category');
                } else if (mTimeRange == null) {
                  _showAlertDialog("Please pick time range");
                } else {
                  Budget mBudget = new Budget(
                      id: 'id',
                      category: this.cate,
                      amount: this.amount,
                      spent: 0,
                      walletId: this.selectedWallet.id,
                      isFinished: mTimeRange.endDay.isBefore(DateTime.now())
                          ? true
                          : false,
                      beginDate: mTimeRange.beginDay,
                      endDate: mTimeRange.endDay,
                      isRepeat: false);
                  await _firestore.addBudget(mBudget, selectedWallet);
                  await _showAlertDialog(
                      "Congratulations, Add budget successfully!");
                  widget.tabController.animateTo(1);
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color(0xFF2FB49C),
                ),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Text(
                  'Add budget',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
