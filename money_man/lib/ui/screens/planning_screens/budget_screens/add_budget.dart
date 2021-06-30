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
import 'package:money_man/ui/screens/planning_screens/budget_screens/category_for_budget.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/select_time_range.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/time_range.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:provider/provider.dart';

class AddBudget extends StatefulWidget {
  AddBudget({this.tabController, Key key, this.wallet, this.myCategory})
      : super(key: key);
  @override
  _AddBudgetState createState() => _AddBudgetState();
  TabController tabController;
  Wallet wallet;
  MyCategory myCategory;
}

class _AddBudgetState extends State<AddBudget> {
  BudgetTimeRange GetmTimeRangeMonth(DateTime today) {
    var firstDayOfMonth = today.subtract(Duration(days: today.day - 1));
    var endDayOfMonth =
        DateTime(today.year, today.month + 1, 1).subtract(Duration(days: 1));
    return new BudgetTimeRange(
        beginDay: firstDayOfMonth,
        endDay: endDayOfMonth,
        description:
            DateTime.now().isBefore(today) ? 'Next month' : 'This month');
  }

  bool isRepeat = true;

  BudgetTimeRange mTimeRange;

  double amount;

  MyCategory cate;

  Wallet selectedWallet;

  String note;

  String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    if (widget.myCategory != null) cate = widget.myCategory;
    if (selectedWallet == null) selectedWallet = widget.wallet;
    if (mTimeRange == null) mTimeRange = GetmTimeRangeMonth(DateTime.now());
    if (mTimeRange.getBudgetLabel() == 'Custom') isRepeat = false;

    return Theme(
      data: ThemeData(
          primaryColor: Style.foregroundColor, fontFamily: 'Montserrat'),
      child: Scaffold(
        backgroundColor: Style.backgroundColor1,
        appBar: AppBar(
          elevation: 0,
          leading: CloseButton(
            color: Style.foregroundColor,
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                //TODO: Add new budget
                // await _firestore.updateEvent();
                if (selectedWallet == null) {
                  _showAlertDialog('Please pick your wallet!', null);
                } else if (amount == null) {
                  _showAlertDialog('Please enter amount!', null);
                } else if (cate == null) {
                  _showAlertDialog('Please pick category', null);
                } else if (mTimeRange == null) {
                  _showAlertDialog("Please pick time range", null);
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
                      isRepeat: isRepeat);
                  _firestore.addBudget(mBudget, selectedWallet);
                  Navigator.pop(context);
                }
              },
              child: Container(
                padding: EdgeInsets.only(right: 5),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: Style.fontFamily,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Style.successColor,
                    ),
                  ),
                ),
              ),
            )
          ],
          backgroundColor: Style.appBarColor,
          centerTitle: true,
          title: Text(
            'Add budget',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,
            ),
          ),
        ),
        body: Container(
          color: Style.backgroundColor1,
          padding: EdgeInsets.only(left: 15, right: 15, top: 30),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                    color: Style.boxBackgroundColor,
                    borderRadius: BorderRadius.circular(17)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListTile(
                  onTap: () async {
                    final selectCate = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => CategoriesBudgetScreen());
                    if (selectCate != null) {
                      setState(() {
                        this.cate = selectCate;
                      });
                    }
                  },
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  dense: true,
                  leading: SuperIcon(
                    iconPath:
                        cate == null ? 'assets/icons/box.svg' : cate.iconID,
                    size: 35,
                  ),
                  title: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Style.foregroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Choose group:',
                            style: TextStyle(
                                color: Style.foregroundColor,
                                fontFamily: 'Montserrat'),
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
                                        CategoriesBudgetScreen());
                            if (selectCate != null) {
                              setState(() {
                                this.cate = selectCate;
                              });
                            }
                          },
                          readOnly: true,
                          obscureText: false,
                          cursorColor: Style.foregroundColor.withOpacity(0.6),
                          style: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              hintText:
                                  cate == null ? 'Choose group' : cate.name,
                              hintStyle: TextStyle(
                                  color: cate == null
                                      ? Style.foregroundColor.withOpacity(0.24)
                                      : Style.foregroundColor,
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
                    color: Style.boxBackgroundColor,
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
                  trailing: Icon(Icons.keyboard_arrow_right,
                      color: Style.foregroundColor.withOpacity(0.7)),
                  dense: true,
                  leading: SuperIcon(
                    iconPath: 'assets/images/coin.svg',
                    size: 30,
                  ),
                  title: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Style.foregroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Target:',
                            style: TextStyle(
                                color: Style.foregroundColor,
                                fontFamily: 'Montserrat'),
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
                                  color: amount == null
                                      ? Style.foregroundColor.withOpacity(0.24)
                                      : Style.foregroundColor,
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
                    color: Style.boxBackgroundColor,
                    borderRadius: BorderRadius.circular(17)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListTile(
                  onTap: () async {
                    var resultAmount = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.backgroundColor,
                        context: context,
                        builder: (context) => SelectTimeRangeScreen());
                    if (resultAmount != null)
                      setState(() {
                        // Change the time ahihi
                        mTimeRange = resultAmount;
                        print(mTimeRange.getBudgetLabel());
                      });
                  },
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
                  dense: true,
                  leading: SuperIcon(
                    iconPath: 'assets/images/time.svg',
                    size: 30,
                  ),
                  title: Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Style.foregroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Time range:',
                            style: TextStyle(
                                color: Style.foregroundColor,
                                fontFamily: 'Montserrat'),
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
                                    backgroundColor: Style.backgroundColor,
                                    context: context,
                                    builder: (context) =>
                                        SelectTimeRangeScreen());
                            print('object ok');
                            if (resultAmount != null)
                              setState(() {
                                // Change the time ahihi
                                mTimeRange = resultAmount;
                                print(mTimeRange.getBudgetLabel());
                              });
                          },
                          readOnly: true,
                          obscureText: false,
                          cursorColor: Style.foregroundColor.withOpacity(0.6),
                          style: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              hintText: mTimeRange == null
                                  ? 'Time range:'
                                  : mTimeRange.description == null
                                      ? mTimeRange.TimeRangeString()
                                      : mTimeRange.description,
                              hintStyle: TextStyle(
                                  color: Style.foregroundColor,
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
                    color: Style.boxBackgroundColor,
                    borderRadius: BorderRadius.circular(17)),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ListTile(
                  onTap: () async {
                    var res = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Style.backgroundColor,
                        context: context,
                        builder: (context) =>
                            SelectWalletAccountScreen(wallet: widget.wallet));
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
                    color: Style.foregroundColor.withOpacity(0.7),
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
                      primaryColor: Style.foregroundColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Select wallet:',
                            style: TextStyle(
                                color: Style.foregroundColor,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () async {
                            var res = await showCupertinoModalBottomSheet(
                                isDismissible: true,
                                backgroundColor: Style.backgroundColor,
                                context: context,
                                builder: (context) => SelectWalletAccountScreen(
                                    wallet: widget.wallet));
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
                          cursorColor: Style.foregroundColor.withOpacity(0.6),
                          style: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              hintText: selectedWallet == null
                                  ? 'Select wallet'
                                  : selectedWallet.name,
                              hintStyle: TextStyle(
                                  color: Style.foregroundColor,
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
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10, top: 5),
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isRepeat = !isRepeat;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1),
                        margin:
                            EdgeInsets.only(left: 20, right: 10, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Style.foregroundColor, width: 1),
                            shape: BoxShape.circle,
                            color: Style.backgroundColor),
                        child: isRepeat
                            ? Icon(
                                Icons.check,
                                size: 17,
                                color: Style.foregroundColor,
                              )
                            : Icon(
                                null,
                                size: 17,
                                color: Style.backgroundColor,
                              ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Repeat this budget',
                          style: TextStyle(
                              color: Style.foregroundColor,
                              fontFamily: 'Montserrat',
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAlertDialog(String content, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        if (title == null)
          return CustomAlert(
            content: content,
          );
        else
          return CustomAlert(
            content: content,
            title: title,
            iconPath: 'assets/images/success.svg',
            //iconPath: iconpath,
          );
      },
    );
  }
}
