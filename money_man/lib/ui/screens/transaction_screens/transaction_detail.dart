import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screen/add_budget.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screen/widget/budget_tile.dart';
import 'package:money_man/ui/screens/transaction_screens/edit_transaction_screen.dart';
import 'package:money_man/ui/widgets/accept_dialog.dart';
import 'package:provider/provider.dart';
import '../../style.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
  MyTransaction transaction;
  Wallet wallet;

  TransactionDetail(
      {Key key, @required this.transaction, @required this.wallet})
      : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_sharp),
        ),
        title: Text('Transaction'),
        centerTitle: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ),
              onPressed: () async {
                //Todo: Edit transaction
              }),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {
              final updatedTrans = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditTransactionScreen(
                          transaction: widget.transaction,
                          wallet: widget.wallet)));
              if (updatedTrans != null)
                setState(() {
                  widget.transaction = updatedTrans;
                });
            },
          ),
          IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                //TODO: Thuc hien xoa transaction

                await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                          'Delete this transaction?',
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No')),
                          FlatButton(
                              onPressed: () async {
                                await _firestore.deleteTransaction(
                                    widget.transaction, widget.wallet);
                                Navigator.pop(context);
                                // chưa có animation để back ra transaction screen
                                Navigator.pop(context);
                              },
                              child: Text('Yes'))
                        ],
                      );
                    });
              })
        ],
        backgroundColor: Color(0xff333333),
      ),
      body: Container(
        color: Color(0xff1a1a1a),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                  child: SuperIcon(
                iconPath: widget.transaction.category.iconID,
                size: 45,
              )),
              title: Container(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.transaction.category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        MoneyFormatter(amount: this.widget.transaction.amount)
                            .output
                            .withoutFractionDigits,
                        style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 30,
                            fontWeight: FontWeight.w200),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Nếu có note thì chèn thêm note vào <3
            widget.transaction.note != ''
                ? ListTile(
                    leading: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.textsms_outlined,
                        color: white,
                      ),
                    ),
                    title: Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '${widget.transaction.note}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    width: 1,
                  ),
            ListTile(
              leading: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.date_range_outlined,
                    color: Colors.white,
                  )),
              title: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  widget.transaction.date.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Container(
                padding: EdgeInsets.only(left: 10),
                child: SuperIcon(
                  iconPath: '${widget.wallet.iconID}',
                  size: 25,
                ),
              ),
              title: Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  '${widget.wallet.name}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.white60,
            ),
            // Này là để hiện budget đã có hoặc tùy chọn thêm budget
            StreamBuilder<List<Budget>>(
                stream: _firestore.budgetTransactionStream(
                    widget.transaction, widget.wallet.id),
                builder: (context, snapshot) {
                  List<Budget> budgets = snapshot.data ?? [];
                  print(budgets.length);

                  // Nếu không có budgets nào có categories trùng với transaction hiển thị tùy chọn thêm transaction
                  if (budgets.length == 0)
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 25, bottom: 15),
                            child: Text('Budget',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'This transaction is not within a budget, but it should be within a budget so you can better manage your finances.',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                await showCupertinoModalBottomSheet(
                                    isDismissible: true,
                                    backgroundColor: Colors.grey[900],
                                    context: context,
                                    builder: (context) => AddBudget(
                                          wallet: widget.wallet,
                                          myCategory:
                                              widget.transaction.category,
                                        ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                width: 300,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFF2FB49C)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  "ADD BUDGET FOR THIS TRANSACTION",
                                  style: TextStyle(
                                      color: Color(0xFF2FB49C),
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  budgets.sort((b, a) => b.beginDate.compareTo(a.beginDate));
                  for (int i = 0; i < budgets.length; i++) {
                    if (budgets[i].endDate.isBefore(DateTime.now())) {
                      budgets.removeAt(i);
                      i--;
                    }
                  }
                  /*return Column(
                    children: [
                      for (int i = 0; i < budgets.length; i++)
                        MyBudgetTile(
                          budget: budgets[i],
                          wallet: widget.wallet,
                        ),
                    ],
                  );*/
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15, top: 20, bottom: 10),
                        child: Text('Budget',
                            style: TextStyle(color: white, fontSize: 25)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                            'This transaction belongs to the following budgets'),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height - 450,
                        child: ListView.builder(
                          itemCount: budgets == null ? 0 : budgets.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              MyBudgetTile(
                                budget: budgets[index],
                                wallet: widget.wallet,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }

  Future<String> _showAcceptionDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAcceptAlert(
          content: 'Do you want to delete this transaction?',
        );
      },
    );
  }
}
