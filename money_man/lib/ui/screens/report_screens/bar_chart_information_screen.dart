import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/category_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/ui/screens/report_screens/bar_chart.dart';
import 'package:money_man/ui/screens/report_screens/report_list_transaction_in_time.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';

class BarChartInformation extends StatefulWidget {
  final List<MyTransaction> currentList;
  final DateTime beginDate;
  final DateTime endDate;
  final Wallet currentWallet;
  BarChartInformation(
      {Key key,
      this.currentWallet,
      this.currentList,
      this.beginDate,
      this.endDate})
      : super(key: key);
  @override
  _BarChartInformation createState() => _BarChartInformation();
}

class _BarChartInformation extends State<BarChartInformation> {

  List<MyTransaction> _transactionList = [];
  DateTime _beginDate;
  DateTime _endDate;
  List<dynamic> calculationList = [];

  List<String> timeRangeList = [];
  List<DateTime> fisrtDayList = [];
  List<DateTime> secondDayList = [];
  double height;
  @override
  void initState() {
    super.initState();
    _transactionList = widget.currentList ?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    generateData(_beginDate, _endDate, timeRangeList, _transactionList);
    height = timeRangeList.length.toDouble() * 70;
  }

  @override
  void didUpdateWidget(covariant BarChartInformation oldWidget) {
    _transactionList = widget.currentList ?? [];
    _beginDate = widget.beginDate;
    _endDate = widget.endDate;
    generateData(_beginDate, _endDate, timeRangeList, _transactionList);
    height = timeRangeList.length.toDouble() * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: boxBackgroundColor2,
        border: Border(
          top: BorderSide(
            color: foregroundColor.withOpacity(0.12),
            width: 0.2,
          ),
          bottom: BorderSide(
            color: foregroundColor.withOpacity(0.12),
            width: 0.2,
          )
        )
      ),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: timeRangeList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  PageTransition(
                      childCurrent: this.widget,
                      child: ReportListTransaction(
                        beginDate: fisrtDayList[index],
                        endDate: secondDayList[index],
                        totalMoney: calculationList[index].first -
                            calculationList[index].last,
                        currentWallet: widget.currentWallet,
                      ),
                      type: PageTransitionType.rightToLeft));
            },
            child: Column(
              children: [
                if (index != 0)
                  Divider(
                    color: foregroundColor.withOpacity(0.12),
                    thickness: 1,
                    height: 25,
                  ),
                Container(
                  color: Colors.transparent, // Khắc phục lỗi không ấn được ở giữa Row khi dùng space between và gesture detector.
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible( // Làm cho text chống tràn khi bị quá dài gây ra lỗi render flex.
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: timeRangeList[index],
                              child: Text(timeRangeList[index],
                                  style: TextStyle(
                                      fontFamily: fontFamily,
                                      color: foregroundColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Text(
                                    'Tap to view transaction list for this period.',
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: foregroundColor.withOpacity(0.24),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          MoneySymbolFormatter(
                            text: (calculationList[index].first == 0)
                                ? 0.0
                                : calculationList[index].first,
                            //digit: (calculationList[index].first == 0) ? '' : '+',
                            currencyId: widget.currentWallet.currencyID,
                            textStyle: TextStyle(
                                fontFamily: fontFamily,
                                color: incomeColor2,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          MoneySymbolFormatter(
                            text: (calculationList[index].last == 0)
                                ? 0.0
                                : calculationList[index].last,
                            //digit: (calculationList[index].last == 0) ? '' : '-',
                            currencyId: widget.currentWallet.currencyID,
                            textStyle: TextStyle(
                                fontFamily: fontFamily,
                                color: expenseColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 8),
                          MoneySymbolFormatter(
                              digit: (calculationList[index].first -
                                  calculationList[index].last) >=
                                  0
                                  ? '+'
                                  : '',
                              text: (calculationList[index].first -
                                  calculationList[index].last),
                              currencyId: widget.currentWallet.currencyID,
                              textStyle: TextStyle(
                                  fontFamily: fontFamily,
                                  color: foregroundColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void generateData(DateTime beginDate, DateTime endDate,
      List<String> timeRangeList, List<MyTransaction> transactionList) {
    timeRangeList.clear();
    calculationList.clear();
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);
    int dayRange = (value.duration >= Duration(days: 6)) ? 6
        : (value.duration.inDays == 0) ? 1 : value.duration.inDays;
    var x = (value.duration.inDays / dayRange).round();
    var firstDate = beginDate.subtract(Duration(days: 1));
    for (int i = 0; i < dayRange; i++) {
      firstDate = firstDate.add(Duration(days: 1));
      var secondDate = (i != dayRange - 1) ? firstDate.add(Duration(days: x)) : endDate;
      var calculation =
          calculateByTimeRange(firstDate, secondDate, transactionList);
      if (calculation.first != 0 || calculation.last != 0) {
        calculationList.add(calculation);
        timeRangeList.add(firstDate.day.toString() + "-" + secondDate.day.toString());
        fisrtDayList.add(firstDate);
        secondDayList.add(secondDate);
      }
      firstDate = firstDate.add(Duration(days: x));
    }
  }

  List<double> calculateByTimeRange(DateTime beginDate, DateTime endDate,
      List<MyTransaction> transactionList) {
    double income = 0;
    double expense = 0;

    transactionList.forEach((element) {
      if (element.date.compareTo(beginDate) >= 0 &&
          element.date.compareTo(endDate) <= 0) {
        if (element.category.type == 'expense')
          expense += element.amount;
        else
          income += element.amount;
      }
    });
    return [income, expense];
  }
}
