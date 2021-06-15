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

    return Theme(
      data: ThemeData(primaryColor: Colors.white, fontFamily: 'Montserrat'),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 70,
          backgroundColor: Color(0xff333333),
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
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                      fontSize: 13),
                )),
          ),
          centerTitle: true,
          title: Text(
            'Edit Budget',
            style: TextStyle(color: white, fontFamily: 'Montserrat'),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                _firestore.updateBudget(_budget, widget.wallet);
                await _showAlertDialog(
                    "Congratulations, Update budget successfully!");
                String result = 'Ajojo';
                Navigator.pop(context, result);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Montserrat',
                        fontSize: 13),
                  )),
            ),
          ],
        ),
        backgroundColor: Color(0xff111111),
        body: Container(
          color: Color(0xff111111),
          margin: EdgeInsets.symmetric(vertical: 15),
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
                    color: Colors.white70,
                  ),
                  dense: true,
                  leading: SuperIcon(
                    iconPath:
                        cate == null ? _budget.category.iconID : cate.iconID,
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
                          cursorColor: Colors.white60,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                              hintText: cate == null
                                  ? _budget.category.name
                                  : cate.name,
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
                        amount = double.parse(resultAmount);
                        this._budget.amount = amount;
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
                          cursorColor: Colors.white60,
                          style: TextStyle(
                              color: Colors.white,
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
                    Wallet res = await showCupertinoModalBottomSheet(
                        isDismissible: true,
                        backgroundColor: Colors.grey[900],
                        context: context,
                        builder: (context) =>
                            SelectWalletAccountScreen(wallet: widget.wallet));
                    if (res != null)
                      setState(() {
                        _budget.walletId = res.id;
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
                        ? this.widget.wallet.iconID
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
                            style: TextStyle(
                                color: white, fontFamily: 'Montserrat'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () async {
                            Wallet res = await showCupertinoModalBottomSheet(
                                isDismissible: true,
                                backgroundColor: Colors.grey[900],
                                context: context,
                                builder: (context) => SelectWalletAccountScreen(
                                    wallet: selectedWallet));
                            if (res != null)
                              setState(() {
                                _budget.walletId = res.id;

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
                                  ? widget.wallet.name
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
              /*GestureDetector(
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
              ),*/
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
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
