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
import 'package:money_man/ui/screens/planning_screens/budget_screens/current_applied_budget.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/select_time_range.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/time_range.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:provider/provider.dart';

class EditBudget extends StatefulWidget {
  EditBudget({this.tabController, Key key, this.budget, this.wallet})
      : super(key: key);
  @override
  _AddBudgetState createState() => _AddBudgetState();
  TabController tabController;
  Budget budget;
  Wallet wallet;
}

class _AddBudgetState extends State<EditBudget> {
  Budget _budget;

  BudgetTimeRange mTimeRange;

  double amount;

  MyCategory cate;

  Wallet selectedWallet;

  String note;

  String currencySymbol;

  @override
  Widget build(BuildContext context) {
    _budget = this.widget.budget;
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    if (mTimeRange == null)
      mTimeRange = new BudgetTimeRange(
          beginDay: _budget.beginDate, endDay: _budget.endDate);
    if (mTimeRange.getBudgetLabel() == 'Custom') _budget.isRepeat = false;

    return Theme(
      data: ThemeData(primaryColor: Colors.white, fontFamily: 'Montserrat'),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 70,
          backgroundColor: Style.appBarColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Style.foregroundColor.withOpacity(0.8),
                      fontFamily: 'Montserrat',
                      fontSize: 13),
                )),
          ),
          centerTitle: true,
          title: Text(
            'Edit Budget',
            style: TextStyle(
                color: Style.foregroundColor.withOpacity(1),
                fontFamily: 'Montserrat'),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                await _firestore.updateBudget(_budget, widget.wallet);
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Style.foregroundColor.withOpacity(0.8),
                        fontFamily: 'Montserrat',
                        fontSize: 13),
                  )),
            ),
          ],
        ),
        backgroundColor: Style.backgroundColor,
        body: Container(
          color: Style.backgroundColor,
          margin: EdgeInsets.symmetric(vertical: 15),
          padding: EdgeInsets.all(15),
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
                        _budget.category = this.cate;
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
                        cate == null ? _budget.category.iconID : cate.iconID,
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
                                color: white, fontFamily: 'Montserrat'),
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
                                _budget.category = this.cate;
                              });
                            }
                          },
                          readOnly: true,
                          obscureText: false,
                          cursorColor: Style.foregroundColor.withOpacity(0.7),
                          style: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              hintText: cate == null
                                  ? _budget.category.name
                                  : cate.name,
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
                    final resultAmount = await Navigator.push(context,
                        MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                    if (resultAmount != null)
                      setState(() {
                        amount = double.parse(resultAmount);
                        this._budget.amount = amount;
                      });
                  },
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Style.foregroundColor.withOpacity(0.7),
                  ),
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
                                color: white, fontFamily: 'Montserrat'),
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
                                amount = double.parse(resultAmount);
                                this._budget.amount = amount;
                              });
                          },
                          readOnly: true,
                          decoration: InputDecoration(
                              hintText: amount == null
                                  ? MoneyFormatter(amount: _budget.amount)
                                      .output
                                      .withoutFractionDigits
                                  : MoneyFormatter(amount: amount)
                                      .output
                                      .withoutFractionDigits,
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
                    var resultAmount = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.grey[900],
                        context: context,
                        builder: (context) => SelectTimeRangeScreen());
                    if (resultAmount != null)
                      setState(() {
                        // Change the time ahihi
                        mTimeRange = resultAmount;
                        _budget.beginDate = resultAmount.beginDay;
                        _budget.endDate = resultAmount.endDay;
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
                                color: white, fontFamily: 'Montserrat'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () async {
                            BudgetTimeRange resultAmount =
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
                                _budget.beginDate = resultAmount.beginDay;
                                _budget.endDate = resultAmount.endDay;
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
                                  ? new BudgetTimeRange(
                                          beginDay: widget.budget.beginDate,
                                          endDay: widget.budget.endDate)
                                      .getBudgetLabel()
                                  : mTimeRange.getBudgetLabel(),
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
                  onTap: () {},
                  trailing: Icon(Icons.lock,
                      color: Style.foregroundColor.withOpacity(0.7)),
                  dense: true,
                  leading: SuperIcon(
                    iconPath: selectedWallet == null
                        ? this.widget.wallet.iconID
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
                                color: Style.foregroundColor.withOpacity(0.54),
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () {},
                          readOnly: true,
                          obscureText: false,
                          cursorColor: Style.foregroundColor.withOpacity(0.6),
                          style: TextStyle(
                              color: Style.foregroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              hintText: selectedWallet == null
                                  ? widget.wallet.name
                                  : selectedWallet.name,
                              hintStyle: TextStyle(
                                  color:
                                      Style.foregroundColor.withOpacity(0.54),
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
                margin: EdgeInsets.only(bottom: 10, top: 5),
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _budget.isRepeat = !_budget.isRepeat;
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
                        child: _budget.isRepeat
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
                              color: white,
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

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Style.backgroundColor.withOpacity(0.54),
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
