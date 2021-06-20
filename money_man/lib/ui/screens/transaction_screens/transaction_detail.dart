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
import 'package:intl/intl.dart';

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

                String result = await showDialog(
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
                                Navigator.of(context, rootNavigator: true)
                                    .pop('No');
                              },
                              child: Text('No')),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('Yes');

                                // chưa có animation để back ra transaction screen
                              },
                              child: Text('Yes'))
                        ],
                      );
                    });
                if (result == 'Yes') {
                  await _firestore.deleteTransaction(
                      _transaction, widget.wallet);
                  Navigator.pop(context);
                }
              })
        ],
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor2,
                border: Border(
                  top: BorderSide(
                    width: 0.5,
                    color: Style.foregroundColor.withOpacity(0.12),
                  ),
                  bottom: BorderSide(
                    width: 0.5,
                    color: Style.foregroundColor.withOpacity(0.12),
                  )
                )
              ),
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
                              color: Style.foregroundColor,
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
                                  color: Style.foregroundColor.withOpacity(0.54),
                                ),
                              ),
                            ),
                          MoneySymbolFormatter(
                            text: _transaction.amount,
                            currencyId: widget.wallet.currencyID,
                            textStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                color: _colorAmount,
                                fontSize: 28,
                                fontWeight: FontWeight.w500
                            ),
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
                      //_transaction.date.toString(),
                      DateFormat('EEEE, dd MMMM yyyy').format(_transaction.date),
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Style.foregroundColor,
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
                    dense: true,
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
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: Style.foregroundColor,
                      ),
                    ),
                  ),
                  if (_transaction.eventID != "" && _transaction.eventID != null)
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 92),
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 0.5,
                          ),
                        ),
                        ListTile(
                          dense: true,
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
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Style.foregroundColor,
                            ),),
                        ),
                      ],
                    ),
                  if (isDebtOrLoan)
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 92),
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 0.5,
                          ),
                        ),
                        ListTile(
                          dense: true,
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
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Style.foregroundColor,
                              ),),
                        ),
                        Container(
                          //padding: EdgeInsets.only(left: 92),
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 0.5,
                          ),
                        ),
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
                ],
              ),
            ),
            SizedBox(height: 10,),
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Divider(
            //     color: Colors.white24,
            //     thickness: 1,
            //   ),
            // ),
            // Này là để hiện budget đã có hoặc tùy chọn thêm budget
            StreamBuilder<List<Budget>>(
                stream: _firestore.budgetTransactionStream(
                    _transaction, widget.wallet.id),
                builder: (context, snapshot) {
                  List<Budget> budgets = snapshot.data ?? [];
                  print('Nafy la in tu transaction detail');

                  // Nếu không có budgets nào có categories trùng với transaction hiển thị tùy chọn thêm transaction
                  if (budgets.length == 0)
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 15, bottom: 10),
                            child: Text('Budget',
                                style: TextStyle(
                                    color: Style.foregroundColor,
                                    fontSize: 25,
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Text(
                            'This transaction is not within a budget, but it should be within a budget so you can better manage your finances.',
                            style: TextStyle(
                              color: Style.foregroundColor.withOpacity(0.7),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: Style.fontFamily,
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                await showCupertinoModalBottomSheet(
                                    isDismissible: true,
                                    backgroundColor: Style.boxBackgroundColor,
                                    context: context,
                                    builder: (context) => AddBudget(
                                          wallet: widget.wallet,
                                          myCategory: _transaction.category,
                                        ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                //width: 300,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(
                                            color: Style.primaryColor,
                                            width: 1.5,
                                        ),
                                    borderRadius: BorderRadius.circular(12)),
                                child: Text(
                                  "Add budget for this transaction",
                                  style: TextStyle(
                                      color: Style.primaryColor,
                                      fontSize: 16,
                                      fontFamily: Style.fontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 45,
                          ),
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
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 15, bottom: 10),
                          child: Text('Budget',
                              style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontSize: 25,
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w500)),
                        ),
                        Text(
                          'This transaction belongs to the following budget(s)',
                          style: TextStyle(
                            color: Style.foregroundColor.withOpacity(0.7),
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: Style.fontFamily,
                          ),
                        ),
                        SizedBox(
                          height: 15,
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
                    ),
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
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  transaction.category.name == 'Debt' ? 'Paid' : 'Received',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontSize: 12.0,
                  )
              ),
              Text(
                  'Left',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontSize: 12.0,
                  )
              ),
            ],
          ),
          SizedBox(height: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MoneySymbolFormatter(
                  text: transaction.amount - transaction.extraAmountInfo,
                  currencyId: wallet.currencyID,
                  textStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                    fontSize: 14.0,
                  ),
              ),
              MoneySymbolFormatter(
                text: transaction.extraAmountInfo,
                currencyId: wallet.currencyID,
                textStyle: TextStyle(
                  fontFamily: Style.fontFamily,
                  fontWeight: FontWeight.w600,
                  color: Style.foregroundColor,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              backgroundColor: Style.foregroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                  (transaction.amount - transaction.extraAmountInfo) /
                      (transaction.amount) >=
                      1
                      ? Style.successColor
                      : Style.warningColor),
              minHeight: 3,
              value: (transaction.amount - transaction.extraAmountInfo) /
                  (transaction.amount),
            ),
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white.withOpacity(0.87);
                        return Colors.white; // Use the component's default.
                      },
                    ),
                    foregroundColor:
                    MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Style.successColor.withOpacity(0.87);
                        return Style.successColor; // Use the component's default.
                      },
                    ),
                  ),
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
                      fontSize: 13,
                      fontFamily: Style.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              if (transaction.extraAmountInfo != 0)
                Row(
                  children: [
                    SizedBox(width: 15,),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Style.successColor.withOpacity(0.7);
                              return Style.successColor; // Use the component's default.
                            },
                          ),
                          foregroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.white.withOpacity(0.7);
                              return Colors.white; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () async {
                          // await Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => CashBackScreen(
                          //             transaction: transaction, wallet: wallet)));
                          await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => CashBackScreen(
                                  transaction: transaction, wallet: wallet));
                          print('alo');
                          refesh(null);
                          print(transaction.extraAmountInfo);
                        },
                        child: Text(
                          'Cashback',
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w700,
                          ),
                        )),
                  ],
                ),
            ],
          )
        ],
      ),
    );
  }
}
