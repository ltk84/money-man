import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/add_budget.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/widget/budget_tile.dart';
import 'package:money_man/ui/screens/transaction_screens/cash_back_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/edit_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_list_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/accept_dialog.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

class TransactionDetail extends StatefulWidget {
  final MyTransaction transaction;
  final Wallet wallet;

  TransactionDetail({
    Key key,
    @required this.transaction,
    @required this.wallet,
  }) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  bool isDebtOrLoan;
  Event event;
  MyTransaction _transaction;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
    isDebtOrLoan = _transaction.category.name == 'Debt' ||
        _transaction.category.name == 'Loan';
    Future.delayed(Duration.zero, () async {
      var res = await getEvent(_transaction.eventID, widget.wallet);
      setState(() {
        event = res;
      });
    });
  }

  Future<Event> getEvent(String id, Wallet wallet) async {
    if (id == '' || id == null) return null;
    final _firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);
    var _event = await _firestore.getEventByID(id, wallet);
    return _event;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    Color _colorAmount;

    if (_transaction.category.type == 'expense') {
      _colorAmount = Style.expenseColor;
    } else if (_transaction.category.type == 'income') {
      _colorAmount = Style.incomeColor2;
    } else {
      switch (_transaction.category.name) {
        case 'Debt':
          _colorAmount = Style.incomeColor2;
          break;
        case 'Loan':
          _colorAmount = Style.expenseColor;
          break;
        case 'Repayment':
          _colorAmount = Style.expenseColor;
          break;
        case 'Debt Collection':
          _colorAmount = Style.incomeColor2;
          break;
      }
    }

    print('build detail');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor2,
        leading: MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Style.foregroundColor,
          ),
        ),
        title: Text(
            'Transaction',
          style: TextStyle(
              color: Style.foregroundColor,
              fontWeight: FontWeight.w500,
              fontFamily: Style.fontFamily,
              fontSize: 18.0
          )
        ),
        centerTitle: false,
        actions: [
          // IconButton(
          //     icon: Icon(
          //       Icons.share,
          //       color: Colors.white,
          //     ),
          //     onPressed: () async {
          //       //Todo: Edit transaction
          //     }),
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Style.foregroundColor.withOpacity(0.54),
              ),
              onPressed: () async {
                final updatedTrans = await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => EditTransactionScreen(
                      transaction: _transaction,
                      wallet: widget.wallet,
                      event: event,
                    ));
                if (updatedTrans != null) {
                  var e = await getEvent(updatedTrans.eventID, widget.wallet);
                  setState(() {
                    _transaction = updatedTrans;
                    event = e;
                  });
                }
              }),
          IconButton(
              icon: Icon(
                  Icons.delete,
                color: Style.foregroundColor.withOpacity(0.54),
              ),
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
                                if (_transaction.category.name == 'Repayment' ||
                                    _transaction.category.name ==
                                        'Debt Collection') {
                                  _firestore
                                      .updateDebtLoanTransationAfterDelete(
                                          _transaction, widget.wallet);
                                }
                                await _firestore.deleteTransaction(
                                    _transaction, widget.wallet);
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
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: ListView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 60,
                    leading: Container(
                        child: SuperIcon(
                          iconPath: _transaction.category.iconID,
                          size: 50,
                        )),
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _transaction.category.name,
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          if (_transaction.note != '' && _transaction.note != null)
                            Container(
                              padding: EdgeInsets.only(top: 2, bottom: 8),
                              child: Text(
                                '${_transaction.note}',
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color: Colors.white.withOpacity(0.54),
                                ),
                              ),
                            ),
                          MoneySymbolFormatter(
                            text: _transaction.amount,
                            currencyId: widget.wallet.currencyID,
                            textStyle: TextStyle(
                                color: _colorAmount,
                                fontSize: 28,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 92),
                    child: Divider(
                      color: Style.foregroundColor.withOpacity(0.12),
                      thickness: 0.5,
                    ),
                  ),
                  ListTile(
                    minLeadingWidth: 60,
                    leading: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(Icons.date_range_rounded,
                          color: Style.foregroundColor.withOpacity(0.54),
                          size: 35.0),
                    ),
                    title: Text(
                      _transaction.date.toString(),
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ListTile(
                    dense: true,
                    isThreeLine: true,
                    minLeadingWidth: 60,
                    leading: Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: SuperIcon(
                        iconPath: '${widget.wallet.iconID}',
                        size: 32,
                      ),
                    ),
                    title: Text(
                      'Wallet',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                        color: Style.foregroundColor.withOpacity(0.54),
                      )
                    ),
                    subtitle: Text(
                      '${widget.wallet.name}',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_transaction.eventID != "" && _transaction.eventID != null)
                    ListTile(
                      dense: true,
                      isThreeLine: true,
                      minLeadingWidth: 60,
                      leading: Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: SuperIcon(
                          iconPath: event != null
                              ? event.iconPath
                              : 'assets/images/email.svg',
                          size: 32.0,
                        ),
                      ),
                      title: Text(
                          'Event',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                            color: Style.foregroundColor.withOpacity(0.54),
                          )
                      ),
                      subtitle: Text(event != null ? event.name : 'a',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white,
                        ),),
                    ),
                  if (isDebtOrLoan)
                    ListTile(
                      minLeadingWidth: 60,
                      leading: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(Icons.person,
                            color: Style.foregroundColor.withOpacity(0.54),
                            size: 38.0),
                      ),
                      title: Text(
                          _transaction.contact == null
                              ? 'With someone'
                              : 'With ${_transaction.contact}',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),),
                    ),
                  if (isDebtOrLoan)
                    DebtLoanSection(
                      count: count,
                      refesh: (transaction) {
                        setState(() {
                          if (transaction != null) _transaction = transaction;
                          // _transaction = widget.transaction;
                        });
                      },
                      transaction: _transaction,
                      wallet: widget.wallet,
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                color: Colors.white12,
                thickness: 1,
              ),
            ),
            // Này là để hiện budget đã có hoặc tùy chọn thêm budget
            StreamBuilder<List<Budget>>(
                stream: _firestore.budgetTransactionStream(
                    _transaction, widget.wallet.id),
                builder: (context, snapshot) {
                  List<Budget> budgets = snapshot.data ?? [];
                  print(budgets.length);

                  // Nếu không có budgets nào có categories trùng với transaction hiển thị tùy chọn thêm transaction
                  if (budgets.length == 0)
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
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
                                          myCategory: _transaction.category,
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
                            style: TextStyle(
                                color: Style.foregroundColor,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                fontFamily: Style.fontFamily,
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'This transaction belongs to the following budget(s)',
                          style: TextStyle(
                            color: Style.foregroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: Style.fontFamily,
                          ),
                        ),
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
}

class DebtLoanSection extends StatelessWidget {
  final int count;
  final Wallet wallet;
  final MyTransaction transaction;
  final Function refesh;
  const DebtLoanSection({
    Key key,
    @required this.transaction,
    @required this.wallet,
    @required this.refesh,
    @required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Paid'),
              Text('Left'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text((transaction.amount - transaction.extraAmountInfo)
                  .toString()),
              Text(transaction.extraAmountInfo.toString())
            ],
          ),
          SizedBox(height: 8,),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              backgroundColor: Color(0xff161616),
              valueColor: AlwaysStoppedAnimation<Color>(
                  (transaction.amount - transaction.extraAmountInfo) /
                      (transaction.amount) >=
                      1
                      ? Color(0xFF2FB49C)
                      : Colors.yellow),
              minHeight: 3,
              value: (transaction.amount - transaction.extraAmountInfo) /
                  (transaction.amount),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (transaction.extraAmountInfo != 0)
                OutlineButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CashBackScreen(
                                  transaction: transaction, wallet: wallet)));
                      print('alo');
                      refesh(null);
                      print(transaction.extraAmountInfo);
                    },
                    child: Text(
                      'Cash back',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: ' Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    )),
              OutlineButton(
                  onPressed: () async {
                    MyTransaction trans = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TransactionListScreen(
                                transactionId: transaction.id,
                                wallet: wallet)));

                    refesh(trans);
                  },
                  child: Text(
                    'Transaction List',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: ' Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
