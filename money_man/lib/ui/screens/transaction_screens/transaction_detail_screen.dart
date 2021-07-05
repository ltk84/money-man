import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/add_budget.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/widget/budget_tile.dart';
import 'package:money_man/ui/screens/transaction_screens/cash_back_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/edit_transaction_screen.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_list_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class TransactionDetail extends StatefulWidget {
  final MyTransaction currentTransaction;
  final Wallet wallet;

  TransactionDetail({
    Key key,
    @required this.currentTransaction,
    @required this.wallet,
  }) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  // biến xác định transaction này là debt hay loan
  bool isDebtOrLoan;
  // biến sự kiện của transaction
  Event event;
  // biến transaction hiện tại
  MyTransaction currentTransaction;

  @override
  void initState() {
    super.initState();
    currentTransaction = widget.currentTransaction;
    isDebtOrLoan = currentTransaction.category.name == 'Debt' ||
        currentTransaction.category.name == 'Loan';
    // lấy event của transaction
    Future.delayed(Duration.zero, () async {
      var res = await getEvent(currentTransaction.eventID, widget.wallet);
      setState(() {
        event = res;
      });
    });
  }

  // lấy event của transaction
  Future<Event> getEvent(String id, Wallet wallet) async {
    if (id == '' || id == null) return null;
    final firestore =
        Provider.of<FirebaseFireStoreService>(context, listen: false);
    var _event = await firestore.getEventByID(id, wallet);
    return _event;
  }

  @override
  Widget build(BuildContext context) {
    // biến để thao tác với database
    final firestore = Provider.of<FirebaseFireStoreService>(context);
    // màu của amount của transaction
    Color colorAmount;

    // cate của transaction là expense
    if (currentTransaction.category.type == 'expense') {
      colorAmount = Style.expenseColor;
      // cate của transaction là income
    } else if (currentTransaction.category.type == 'income') {
      colorAmount = Style.incomeColor2;
    }
    // cate của transaction là debt & loan
    else {
      switch (currentTransaction.category.name) {
        case 'Debt':
          colorAmount = Style.incomeColor2;
          break;
        case 'Loan':
          colorAmount = Style.expenseColor;
          break;
        case 'Repayment':
          colorAmount = Style.expenseColor;
          break;
        case 'Debt Collection':
          colorAmount = Style.incomeColor2;
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Style.appBarColor,
        leading: Hero(
          tag: 'backButton',
          child: MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Style.foregroundColor,
            ),
          ),
        ),
        title: Hero(
          tag: 'title',
          child: Material(
            color: Colors.transparent,
            child: Text('Transaction',
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: Style.fontFamily,
                    fontSize: 18.0)),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Style.foregroundColor.withOpacity(0.54),
              ),
              onPressed: () async {
                final updatedTrans = await showCupertinoModalBottomSheet(
                    context: context,
                    builder: (context) => EditTransactionScreen(
                          transaction: currentTransaction,
                          wallet: widget.wallet,
                          event: event,
                        ));
                if (updatedTrans != null) {
                  var e = await getEvent(updatedTrans.eventID, widget.wallet);
                  setState(() {
                    currentTransaction = updatedTrans;
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
                String result = await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        backgroundColor: Style.boxBackgroundColor2,
                        title: Text(
                          'Delete this transaction?',
                          style: TextStyle(
                            color: Style.errorColor,
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        actions: [
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('No');
                              },
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: Style.foregroundColor.withOpacity(0.7),
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop('Yes');
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Style.foregroundColor.withOpacity(0.7),
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                        ],
                      );
                    });
                if (result == 'Yes') {
                  // nếu transaction cate là repayment / debt collection
                  if (currentTransaction.category.name == 'Repayment' ||
                      currentTransaction.category.name == 'Debt Collection') {
                    // update extraTransaction mà liên hệ vs transaction
                    await firestore.updateDebtLoanTransationAfterDelete(
                        currentTransaction, widget.wallet);
                  }
                  // nếu transaction cate là debt/loan
                  if (currentTransaction.category.name == 'Debt' ||
                      currentTransaction.category.name == 'Loan') {
                    // xóa các thông tin cần thiết của transaction
                    await firestore.deleteInstanceInTransactionIdList(
                        currentTransaction.id, widget.wallet.id);
                  }
                  await firestore.deleteTransaction(
                      currentTransaction, widget.wallet);
                  Navigator.pop(context, 'Deleted');
                }
              })
        ],
      ),
      body: Container(
        color: Style.backgroundColor,
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
                  border: Border(
                      top: BorderSide(
                        width: 0.5,
                        color: Style.foregroundColor.withOpacity(0.12),
                      ),
                      bottom: BorderSide(
                        width: 0.5,
                        color: Style.foregroundColor.withOpacity(0.12),
                      ))),
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 60,
                    leading: Container(
                        child: SuperIcon(
                      iconPath: currentTransaction.category.iconID,
                      size: 50,
                    )),
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentTransaction.category.name,
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w600,
                              color: Style.foregroundColor,
                              fontSize: 20,
                            ),
                          ),
                          if (currentTransaction.note != '' &&
                              currentTransaction.note != null)
                            Container(
                              padding: EdgeInsets.only(top: 2, bottom: 8),
                              child: Text(
                                '${currentTransaction.note}',
                                style: TextStyle(
                                  fontFamily: Style.fontFamily,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  color:
                                      Style.foregroundColor.withOpacity(0.54),
                                ),
                              ),
                            ),
                          MoneySymbolFormatter(
                            checkOverflow: false,
                            text: currentTransaction.amount,
                            currencyId: widget.wallet.currencyID,
                            textStyle: TextStyle(
                                fontFamily: Style.fontFamily,
                                color: colorAmount,
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
                      child: SuperIcon(
                          iconPath: 'assets/images/time.svg', size: 35.0),
                    ),
                    title: Text(
                      DateFormat('EEEE, dd MMMM yyyy')
                          .format(currentTransaction.date),
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
                    title: Text('Wallet',
                        style: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          color: Style.foregroundColor.withOpacity(0.54),
                        )),
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
                  if (currentTransaction.eventID != "" &&
                      currentTransaction.eventID != null)
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
                                  : 'assets/images/event.svg',
                              size: 32.0,
                            ),
                          ),
                          title: Text('Event',
                              style: TextStyle(
                                fontFamily: Style.fontFamily,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: Style.foregroundColor.withOpacity(0.54),
                              )),
                          subtitle: Text(
                            event != null ? event.name : 'a',
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Style.foregroundColor,
                            ),
                          ),
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
                            padding: const EdgeInsets.only(left: 14),
                            child: SuperIcon(
                              iconPath:
                                  'assets/images/account_screen/user2.svg',
                              size: 28,
                            ),
                          ),
                          title: Text(
                            currentTransaction.contact == null
                                ? 'With someone'
                                : 'With ${currentTransaction.contact}',
                            style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Style.foregroundColor,
                            ),
                          ),
                        ),
                        Container(
                          child: Divider(
                            color: Style.foregroundColor.withOpacity(0.12),
                            thickness: 0.5,
                          ),
                        ),
                        DebtLoanSection(
                          refesh: (transaction) {
                            setState(() {
                              if (transaction != null)
                                currentTransaction = transaction;
                            });
                          },
                          transaction: currentTransaction,
                          wallet: widget.wallet,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Này là để hiện budget đã có hoặc tùy chọn thêm budget
            StreamBuilder<List<Budget>>(
                stream: firestore.budgetTransactionStream(
                    currentTransaction, widget.wallet.id),
                builder: (context, snapshot) {
                  List<Budget> budgets = snapshot.data ?? [];
                  print('Nafy la in tu transaction detail');
                  budgets.sort((b, a) => b.beginDate.compareTo(a.beginDate));
                  for (int i = 0; i < budgets.length; i++) {
                    if (budgets[i]
                        .endDate
                        .add(Duration(days: 1))
                        .isBefore(DateTime.now())) {
                      budgets.removeAt(i);
                      i--;
                    }
                  }

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
                                          myCategory:
                                              currentTransaction.category,
                                        ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                //width: 300,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
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
  final Wallet wallet;
  final MyTransaction transaction;
  final Function refesh;
  const DebtLoanSection({
    Key key,
    @required this.transaction,
    @required this.wallet,
    @required this.refesh,
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
              Text(transaction.category.name == 'Debt' ? 'Paid' : 'Received',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontSize: 12.0,
                  )),
              Text('Left',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontWeight: FontWeight.w400,
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontSize: 12.0,
                  )),
            ],
          ),
          SizedBox(
            height: 2,
          ),
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
          SizedBox(
            height: 10,
          ),
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
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white.withOpacity(0.87);
                        return Colors.white; // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Style.successColor.withOpacity(0.87);
                        return Style
                            .successColor; // Use the component's default.
                      },
                    ),
                  ),
                  onPressed: () async {
                    MyTransaction trans = await Navigator.push(
                        context,
                        PageTransition(
                            childCurrent: this,
                            child: TransactionListScreen(
                                transactionId: transaction.id, wallet: wallet),
                            type: PageTransitionType.rightToLeft));
                    // thực hiện refesh lại screen sau khi back về từ TransactionListScreen
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
                    SizedBox(
                      width: 15,
                    ),
                    TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Style.successColor.withOpacity(0.7);
                              return Style
                                  .successColor; // Use the component's default.
                            },
                          ),
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.white.withOpacity(0.7);
                              return Colors
                                  .white; // Use the component's default.
                            },
                          ),
                        ),
                        onPressed: () async {
                          await showCupertinoModalBottomSheet(
                              context: context,
                              builder: (context) => CashBackScreen(
                                  transaction: transaction, wallet: wallet));
                          // refesh sau khi back về từ trang CashBackScreen
                          refesh(null);
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
