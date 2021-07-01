import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/transaction_screens/transaction_detail.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:intl/intl.dart';

// Này là màn hình để đọc các transaction của budget, xem bằng cách ấn transaction list trong detail
class BudgetTransactionScreen extends StatefulWidget {
  Budget budget; // truyền vào budget.
  Wallet wallet; // Truyền vào ví
  BudgetTransactionScreen({Key key, this.budget, this.wallet})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BudgetTransactionScreen();
  }
}

class _BudgetTransactionScreen extends State<BudgetTransactionScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    //future builder để lấy danh sách các transaction có cùng category với budget
    return FutureBuilder<Object>(
        future: _firestore.getListOfTransactionWithCriteriaForBudget(
            widget.budget.category.name, widget.wallet.id),
        builder: (context, snapshot) {
          double total = 0;
          List<MyTransaction> listTransaction = snapshot.data ?? [];

// Loại những transaction nằm ngoài khoảng thời gian của budget
          for (int i = 0; i < listTransaction.length; i++) {
            if (listTransaction[i].date.compareTo(widget.budget.beginDate) <
                    0 ||
                listTransaction[i].date.compareTo(
                        widget.budget.endDate.add(Duration(days: 1))) >=
                    0) {
              listTransaction.removeAt(i);
              i--;
            }
          }
          // sắp xếp lại theo thứ tự giảm dần thời gian
          listTransaction.sort((a, b) => b.date.compareTo(a.date));
          return Scaffold(
            backgroundColor: Style.backgroundColor,
            appBar: AppBar(
              leading: MaterialButton(
                  // trở lại màn hình trước
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Style.backIcon,
                    color: Style.foregroundColor,
                  )),
              backgroundColor: Style.appBarColor,
              centerTitle: true,
              elevation: 0,
              title: Text('Transaction List',
                  style: TextStyle(
                    fontFamily: Style.fontFamily,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Style.foregroundColor,
                  )),
            ),
            // Nếu không có transaction nào thì hiển thị không có
            body: listTransaction.length == 0
                ? Container(
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
                          'There are no transactions',
                          style: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Style.foregroundColor.withOpacity(0.24),
                          ),
                        ),
                      ],
                    ))
                // Nếu có thì hiển thị danh sách
                : buildDisplayTransactionByDate(filterData(listTransaction)),
          );
        });
  }

// truyền vào danh sách các transaction để hiển thị
  Container buildDisplayTransactionByDate(
      List<List<MyTransaction>> transactionListSortByDate) {
    return Container(
      color: Style.backgroundColor,
      child: ListView.builder(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          shrinkWrap: true,
          itemCount: transactionListSortByDate.length,
          itemBuilder: (context, xIndex) {
            double totalAmountInDay = 0;
            transactionListSortByDate[xIndex].forEach((element) {
              // Tính toán total cho tất cả các giao dịch
              if (element.category.type == 'expense')
                totalAmountInDay -= element.amount;
              else
                totalAmountInDay += element.amount;
            });
            // xIndex đầu tiên để hiển thị thông tin ngày và tổng số tiền hao phí
            return xIndex == 0
                ? Column(
                    children: [
                      buildBottomViewByDate(
                          transactionListSortByDate, xIndex, totalAmountInDay)
                    ],
                  )
                : buildBottomViewByDate(
                    transactionListSortByDate, xIndex, totalAmountInDay);
          }),
    );
  }

// Này để hiển thị danh sách giao dịch
  Container buildBottomViewByDate(List<List<MyTransaction>> transListSortByDate,
      int xIndex, double totalAmountInDay) {
    return (transListSortByDate[xIndex].length != 0)
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            decoration: BoxDecoration(
                color: Style.boxBackgroundColor,
                border: Border(
                    bottom: BorderSide(
                      color: Style.foregroundColor.withOpacity(0.12),
                      width: 0.5,
                    ),
                    top: BorderSide(
                      color: Style.foregroundColor.withOpacity(0.12),
                      width: 0.5,
                    ))),
            child: StickyHeader(
              header: Container(
                color: Style.boxBackgroundColor,
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                      child: Text(
                          DateFormat("dd")
                              .format(transListSortByDate[xIndex][0].date),
                          style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 30.0,
                              color: Style.foregroundColor)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                      child: Text(
                          DateFormat("EEEE")
                                  .format(transListSortByDate[xIndex][0].date)
                                  .toString() +
                              '\n' +
                              DateFormat("MMMM yyyy")
                                  .format(transListSortByDate[xIndex][0].date)
                                  .toString(),
                          // 'hello',
                          style: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w400,
                              fontSize: 12.0,
                              color: Style.foregroundColor.withOpacity(0.54))),
                    ),
                    Expanded(
                      child: MoneySymbolFormatter(
                        digit: totalAmountInDay >= 0 ? '+' : '',
                        text: totalAmountInDay,
                        currencyId: widget.wallet.currencyID,
                        textAlign: TextAlign.end,
                        textStyle: TextStyle(
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.0,
                          color: Style.foregroundColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: transListSortByDate[xIndex].length,
                  itemBuilder: (context, yIndex) {
                    return GestureDetector(
                      // Xem chi tiết giao dịch
                      onTap: () async {
                        var res = await Navigator.push(
                            context,
                            PageTransition(
                                child: TransactionDetail(
                                  transaction: transListSortByDate[xIndex]
                                      [yIndex],
                                  wallet: widget.wallet,
                                ),
                                type: PageTransitionType.rightToLeft));
                        setState(() {});
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: SuperIcon(
                                  iconPath: transListSortByDate[xIndex][yIndex]
                                      .category
                                      .iconID,
                                  size: 30,
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                              child: Text(
                                  transListSortByDate[xIndex][yIndex]
                                      .category
                                      .name,
                                  style: TextStyle(
                                    fontFamily: Style.fontFamily,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14.0,
                                    color: Style.foregroundColor,
                                  )),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: MoneySymbolFormatter(
                                  text: transListSortByDate[xIndex][yIndex]
                                      .amount,
                                  currencyId: widget.wallet.currencyID,
                                  textStyle: TextStyle(
                                      fontFamily: Style.fontFamily,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: transListSortByDate[xIndex][yIndex]
                                                  .category
                                                  .type ==
                                              'income'
                                          ? Style.incomeColor2
                                          : Style.expenseColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          )
        : Container(
            height: 0.1,
          );
  }

// Này là hàm để lọc data, để chia các giao dịch theo ngày, truyền vào danh sách các giao dịch
  List<List<MyTransaction>> filterData(List<MyTransaction> transactionList) {
    // sao lưu lại danh sách
    var _transactionList = transactionList;
    // danh sách đã được sort theo các ngày
    List<List<MyTransaction>> transactionListSorted = [];
    // Danh sách các ngày
    List<DateTime> dateInChoosenTime = [];
    // sắp xếp lại các transaction theo ngày
    transactionList.sort((a, b) => b.date.compareTo(a.date));
    // Nếu các giao dịch cùng ngày thì thêm vào cái danh sách
    transactionList.forEach((element) {
      if (!dateInChoosenTime.contains(element.date))
        dateInChoosenTime.add(element.date);
    });
    // Thực hiện sort
    dateInChoosenTime.forEach((date) {
      final b = _transactionList
          .where((element) => element.date.compareTo(date) == 0);
      transactionListSorted.add(b.toList());
    });
    // trả về danh sách 2 chiều đã chia theo các ngày, các giao dịch
    return transactionListSorted;
  }
}
