import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
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

  // Biến lưu danh sach transactions.
  List<MyTransaction> transactionList = [];

  // Biến lưu giá trị đầu và cuối của khoảng thời gian.
  DateTime beginDate;
  DateTime endDate;

  // Biến lưu giá trị tính toán cho khoảng thời gian.
  List<dynamic> calculationList = [];

  // Các biến này dùng để chia khoảng thời gian thành các phần nhỏ từ ngày bắt đầu (beginDate) và ngày kết thúc (endDate) ở trên.
  List<String> timeRangeList = [];
  List<DateTime> firstDayList = [];
  List<DateTime> secondDayList = [];

  double height;

  @override
  void initState() {
    super.initState();
    transactionList = widget.currentList ?? [];
    beginDate = widget.beginDate;
    endDate = widget.endDate;

    // Hàm lấy tính toán và chia các khoảng thời gian để thống kê từ danh sách các giao dịch.
    generateData(beginDate, endDate, timeRangeList, transactionList);

    // Gán biến độ cao dựa vào danh sách các khoảng thời gian.
    height = timeRangeList.length.toDouble() * 70;
  }

  @override
  void didUpdateWidget(covariant BarChartInformation oldWidget) {
    super.didUpdateWidget(oldWidget);
    transactionList = widget.currentList ?? [];
    beginDate = widget.beginDate;
    endDate = widget.endDate;

    // Hàm lấy tính toán và chia các khoảng thời gian để thống kê từ danh sách các giao dịch.
    generateData(beginDate, endDate, timeRangeList, transactionList);
    height = timeRangeList.length.toDouble() * 100;
  }

  @override
  Widget build(BuildContext context) {
    return transactionList.length == 0
    ? Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        alignment: Alignment.center,
        child: Text(
          'No transaction',
          style: TextStyle(
            fontFamily: Style.fontFamily,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: Style.foregroundColor.withOpacity(0.24),
          ),
        )
    )
    : Container(
      decoration: BoxDecoration(
        color: Style.boxBackgroundColor2,
        border: Border(
          top: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.2,
          ),
          bottom: BorderSide(
            color: Style.foregroundColor.withOpacity(0.12),
            width: 0.2,
          )
        )
      ),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      child: Column(
        children: List.generate(
            timeRangeList.length,
                (index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            childCurrent: this.widget,
                            child: ReportListTransaction(
                              beginDate: firstDayList[index],
                              endDate: secondDayList[index],
                              totalMoney: calculationList[index].first -
                                  calculationList[index].last,
                              currentWallet: widget.currentWallet,
                              viewByCategory: false,
                              category: null,
                            ),
                            type: PageTransitionType.rightToLeft));
                  },
                  child: Column(
                    children: [
                      if (index != 0)
                        Divider(
                          color: Style.foregroundColor.withOpacity(0.12),
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
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(timeRangeList[index],
                                          style: TextStyle(
                                              fontFamily: Style.fontFamily,
                                              color: Style.foregroundColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: Text(
                                      'Tap to view transaction list for this period.',
                                      style: TextStyle(
                                          fontFamily: Style.fontFamily,
                                          color: Style.foregroundColor.withOpacity(0.24),
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
                                  currencyId: widget.currentWallet.currencyID,
                                  textStyle: TextStyle(
                                      fontFamily: Style.fontFamily,
                                      color: Style.incomeColor2,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 8),
                                MoneySymbolFormatter(
                                  text: (calculationList[index].last == 0)
                                      ? 0.0
                                      : calculationList[index].last,
                                  currencyId: widget.currentWallet.currencyID,
                                  textStyle: TextStyle(
                                      fontFamily: Style.fontFamily,
                                      color: Style.expenseColor,
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
                                        fontFamily: Style.fontFamily,
                                        color: Style.foregroundColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500))
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
        )
      )
    );
  }

  // Mục đích của hàm này là chia nhỏ khoảng thời gian ban đầu thành những khoảng thời gian nhỏ hơn để thống kê.
  void generateData(DateTime beginDate, DateTime endDate,
      List<String> timeRangeList, List<MyTransaction> transactionList) {
    // Đảm bảo các danh sách dùng để lưu các kết quả được làm trống.
    timeRangeList.clear();
    calculationList.clear();

    // Tạo đối tượng khoảng thời gian ban đầu dựa vào ngày bắt đầu và ngày kết thúc được truyền vào.
    DateTimeRange value = DateTimeRange(start: beginDate, end: endDate);

    // Lấy số lượng của khoảng thời gian chia nhỏ
    // Nếu khoảng thời gian ban đầu lớn hơn hoặc bằng 6 ngày thì số lượngsẽ bằng 6.
    // Nếu khoảng thời gian ban đầu nhỏ hơn 6 ngày và lớn hơn 0 thì số lượng sẽ bằng đúng khoảng thời gian ban đầu đó.
    // Nếu khoảng thời gian ban đầu bằng 0 thì số lượng sẽ bằng 1.
    int numOfRange = (value.duration >= Duration(days: 6)) ? 6
        : (value.duration.inDays == 0) ? 1 : value.duration.inDays;

    // Giá trị thực của một khoảng thời gian (tức là một khoảng thời gian sau khi chia nhỏ có bao nhiêu ngày) được tính bằng khoảng thời gian ban đầu chia cho số lượng khoảng thời gian được tính ở trên.
    var x = (value.duration.inDays / numOfRange).round();

    // Subtract ở chỗ này là để khi vào hàm for bên dưới, firstDate quay về đúng với giá trị ban đầu của beginDate.
    // Vì việc add 1 ngày ở dòng đầu trong hàm for là cần thiết, không thể bỏ.
    var firstDate = beginDate.subtract(Duration(days: 1));

    for (int i = 0; i < numOfRange; i++) {
      // Khoảng thời gian thì phải có ngày bắt đầu và ngày kết thúc. Ở đây biến firstDate và secondDate được dùng để tượng trưng cho điều đó, ngày bắt đầu và ngày kết thúc của khoảng thời gian được chia tách.
      firstDate = firstDate.add(Duration(days: 1));
      var secondDate = (i != numOfRange - 1) ? firstDate.add(Duration(days: x)) : endDate;

      // Lưu kết quả tính toán thu nhập và chi tiêu theo khoảng thời gian xác định.
      var calculation =
          calculateByTimeRange(firstDate, secondDate, transactionList);

      // calculation.first là số tiền thu nhập, calculation.last là số tiền chi tiêu
      if (calculation.first != 0 || calculation.last != 0) {
        // Có một danh sách để lưu khoảng thời gian đã được chia nhỏ và một danh sách để lưu số tiền thu, chi trong khoảng thời gian đó, đối chiếu với nhau theo thứ tự.
        // Ví dụ: Khoảng thời gian có thứ tự là 1 trong danh sách khoảng thời gian sẽ có thông tin thu chi có thứ tự là 1 tranh danh sách lưu số tiền thu chi.
        calculationList.add(calculation);
        timeRangeList.add(firstDate.day.toString() + "-" + secondDate.day.toString());
        firstDayList.add(firstDate);
        secondDayList.add(secondDate);
      }
      // Tăng lên một chu kỳ.
      // Nghĩa là sẽ tiếp tục tính toán khoảng thời gian được chia nhỏ tiếp theo cho đến khi vòng lặp kết thúc.
      firstDate = firstDate.add(Duration(days: x));
    }
  }

  // Hàm tính toán thu nhập và chi tiêu trong một khoảng thời gian xác định.
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
