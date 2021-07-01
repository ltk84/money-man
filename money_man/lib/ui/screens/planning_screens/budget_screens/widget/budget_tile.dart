import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../budget_detail.dart';

class MyBudgetTile extends StatefulWidget {
  const MyBudgetTile({Key key, this.budget, this.wallet}) : super(key: key);
  final Budget budget;
  final Wallet wallet;

  @override
  _MyBudgetTileState createState() => _MyBudgetTileState();
}

class _MyBudgetTileState extends State<MyBudgetTile> {
  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    var todayRate = today.difference(widget.budget.beginDate).inMicroseconds /
        widget.budget.endDate
            .difference(widget.budget.beginDate)
            .inMicroseconds;
    var todayTarget = widget.budget.spent / widget.budget.amount;
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    _firestore.updateBudget(widget.budget, widget.wallet);
    if (widget.budget.isRepeat &&
        widget.budget.endDate.add(Duration(days: 1)).isBefore(today)) {
      Budget newBudget = new Budget(
          id: 'id',
          category: widget.budget.category,
          amount: widget.budget.amount,
          spent: widget.budget.spent,
          walletId: widget.budget.walletId,
          isFinished: widget.budget.isFinished,
          beginDate: widget.budget.endDate.add(Duration(days: 1)),
          endDate: widget.budget.endDate
              .add(widget.budget.endDate.difference(widget.budget.beginDate)),
          isRepeat: widget.budget.isRepeat);
      Budget temp = widget.budget;
      temp.isRepeat = false;
      _firestore.updateBudget(temp, widget.wallet);
      _firestore.addBudget(newBudget, widget.wallet);
    }

    widget.budget.label = getBudgetLabel(widget.budget);

    return Center(
      child: GestureDetector(
        onTap: () async {
          Wallet wallet =
              await _firestore.getWalletByID(widget.budget.walletId);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BudgetDetailScreen(
                      budget: this.widget.budget,
                      wallet: wallet,
                    )),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Style.boxBackgroundColor,
          ),
          width: MediaQuery.of(context).size.width,
          //height: 140,
          margin: EdgeInsets.only(bottom: 15),
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 15, bottom: 15, top: 10, right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            widget.budget.label == null
                                ? 'Custom '
                                : '${widget.budget.label} ',
                            style: TextStyle(
                              color: Style.foregroundColor.withOpacity(0.54),
                              fontSize: 12,
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.budget.label != 'Custom'
                                ? ''
                                : '${DateFormat('dd/MM/yyyy').format(widget.budget.beginDate) + ' - ' + DateFormat('dd/MM/yyyy').format(widget.budget.endDate)}',
                            style: TextStyle(
                              color: Style.foregroundColor.withOpacity(0.54),
                              fontFamily: Style.fontFamily,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                                child: SuperIcon(
                                  iconPath: this.widget.budget.category.iconID,
                                  size: 30,
                                )),
                            Container(
                              child: Text(
                                this.widget.budget.category.name,
                                style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                ),
                              ),
                            ), //Title cho khoản chi thu đã chọn
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MoneySymbolFormatter(
                                text: this.widget.budget.amount,
                                currencyId: widget.wallet.currencyID,
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    todayTarget > 1
                                        ? 'Over spent: '
                                        : 'Remain: ',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Style.foregroundColor
                                          .withOpacity(0.54),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: Style.fontFamily,
                                    ),
                                  ),
                                  MoneySymbolFormatter(
                                    text: (this.widget.budget.spent -
                                            this.widget.budget.amount)
                                        .abs(),
                                    currencyId: widget.wallet.currencyID,
                                    textStyle: TextStyle(
                                        fontSize: 12.0,
                                        color: Style.foregroundColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: Style.fontFamily),
                                  ),
                                ],
                              ), // Remain
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(60, 8, 15, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    backgroundColor: Style.boxBackgroundColor2,
                    valueColor: AlwaysStoppedAnimation<Color>(todayTarget > 1
                        ? Colors.red[700]
                        : todayTarget > todayRate
                            ? Colors.orange[700]
                            : Color(0xFF2FB49C)),
                    minHeight: 3,
                    value:
                        this.widget.budget.spent / this.widget.budget.amount > 1
                            ? 1
                            : this.widget.budget.spent /
                                this.widget.budget.amount,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              widget.budget.beginDate.isAfter(today) ||
                      today
                          .isAfter(widget.budget.endDate.add(Duration(days: 1)))
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(
                          left: 45 +
                              (MediaQuery.of(context).size.width - 120) *
                                  todayRate),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      // height: 20,
                      // width: 40,
                      //alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Style.boxBackgroundColor2),
                      child: Text(
                        "Today",
                        style: TextStyle(
                          color: Style.foregroundColor,
                          fontSize: 8,
                          fontFamily: Style.fontFamily,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  String getBudgetLabel(Budget budget) {
    DateTime today = DateTime.now();
    DateTime begin = budget.beginDate;
    DateTime end = budget.endDate;
    if (end.weekday == 7 &&
        begin.weekday == 1 &&
        begin.isBefore(today.add(Duration(days: 1))) &&
        end.isAfter(today.subtract(Duration(days: 1)))) return 'This week';
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == today.month &&
        begin.month == end.month &&
        begin.compareTo(today) <= 0 &&
        end.add(Duration(days: 1)).compareTo(today) >= 0) return 'This month';
    var temp = DateTime(today.year, today.month + 1, today.day);
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == temp.month &&
        begin.isBefore(temp) &&
        end.isAfter(temp)) return 'Next month';

    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));

    if (begin.compareTo(firstDayOfQuarter) == 0 &&
        end.compareTo(endDayOfQuarter) == 0) return 'This quarter';

    double nextQuarterNumber = (today.month - 1) / 3 + 6;
    DateTime firstDayOfNQuarter =
        new DateTime(today.year, nextQuarterNumber.toInt(), 1);
    final endDayOfNQuarter =
        new DateTime(today.year, nextQuarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
    if (begin.compareTo(firstDayOfNQuarter) == 0 &&
        end.compareTo(endDayOfNQuarter) == 0) return 'Next quarter';

    if (begin.compareTo(DateTime(today.year, 1, 1)) == 0 &&
        end.compareTo(DateTime(today.year, 12, 31)) == 0) return 'This year';

    if (begin.compareTo(DateTime(today.year + 1, 1, 1)) == 0 &&
        end.compareTo(DateTime(today.year + 1, 12, 31)) == 0)
      return 'Next year';
    return 'Custom';
  }
}
