import 'package:flutter/material.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../budget_detail.dart';

// Này là mấy cái thẻ để hiển thị thông tin các budget trong màn hình budget home
class MyBudgetTile extends StatefulWidget {
  const MyBudgetTile({Key key, this.budget, this.wallet}) : super(key: key);
  // Budget cho thẻ hiện tại
  final Budget budget;
  // Ví cho budget của thẻ hiện tại
  final Wallet wallet;

  @override
  _MyBudgetTileState createState() => _MyBudgetTileState();
}

class _MyBudgetTileState extends State<MyBudgetTile> {
  @override
  Widget build(BuildContext context) {
    // THời gian ngày hôm nay
    DateTime today = DateTime.now();
    // Biến todayRate để hiển thị tỉ lệ ngày hôm nay so với tổng thể của budget
    var todayRate = DateTime.now()
            .difference(widget.budget.beginDate)
            .inMicroseconds /
        widget.budget.endDate
            // Cộng thêm 1 ngày vì nếu  là ngày hôm nay rồi thì vẫn là cộng thôi :v
            .add(Duration(days: 1))
            .difference(widget.budget.beginDate)
            .inMicroseconds;
    // todayTarget là tỉ lệ số tiền đã chi so với mức đề ra
    var todayTarget = widget.budget.spent / widget.budget.amount;
    // biến này để sử dụng các hàm firestore
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    //update để tính toán spent nè :3
    _firestore.updateBudget(widget.budget, widget.wallet);
    // Nếu nó là ở chế độ lặp lại và nó đã kết thúc thì tắt lặp lại, tạo cái mới :3 cái mới có ngày bắt đầu = ngày cuối + 1, ngày cuối = ngày cuối + tổng ngày ban đầu
    if (widget.budget.isRepeat &&
        widget.budget.endDate.add(Duration(days: 1)).isBefore(today)) {
      // Tạo một budget mới nè :3
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
      // update budget ban đầu
      _firestore.updateBudget(temp, widget.wallet);
      // thêm budget mới nè :v
      _firestore.addBudget(newBudget, widget.wallet);
    }

// này để lấy mô tả khoảng thời gian cho budget
    widget.budget.label = getBudgetLabel(widget.budget);

    return Center(
      child: GestureDetector(
        // Nếu ấn vào thì xem chi tiết thôi :3
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
                                checkOverflow: true,
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
                                    // todaytarget > 1 là spent lớn hơn amount rồi đó :3
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
                                    checkOverflow: true,
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
              // này là cái để đưa ra cái chỉ khoảng tiền chi tiêu nè :3 cái progress bar đó
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
              // Nếu chưa kết thúc thì hiển thị cái chỉ ngày, nếu rồi hoặc chưa bắt đầu thì không hiển thị cái đó
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

// Hàm này lấy budget nè
  String getBudgetLabel(Budget budget) {
    // lấy ngày hôm nay nè
    DateTime today = DateTime.now();
    // ngày bắt đầu nè
    DateTime begin = budget.beginDate;
    // ngày kết thúc nè
    DateTime end = budget.endDate;
    // Nếu ngày bắt đầu là thứ 2 kết thúc là thứ 7 và ngày hiện tại nằm giữa 2 thời gian đó thì nó là tuần này
    if (end.weekday == 7 &&
        begin.weekday == 1 &&
        begin.isBefore(today.add(Duration(days: 1))) &&
        end.isAfter(today.subtract(Duration(days: 1)))) return 'This week';
    // Nếu ngày bắt đầu là ngày đầu tiên của tháng, kết thúc là ngày cuối của tháng (lấy bằng cách trừ đi 1 ngày kể từ ngày đầu tiên của tháng sau) và cũng nằm giữa thì là tháng này
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
    // tương tự nhưng nếu + 1 tháng cho nó thì là tháng sau rồi :3
    if (begin.day == 1 &&
        end.day ==
            DateTime(begin.year, begin.month + 1, 1)
                .subtract(Duration(days: 1))
                .day &&
        end.month == temp.month &&
        begin.isBefore(temp) &&
        end.isAfter(temp)) return 'Next month';
// Về quý thì theo công thức đó, cũng làm tương tự
    double quarterNumber = (today.month - 1) / 3 + 3;
    DateTime firstDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt(), 1);
    final endDayOfQuarter =
        new DateTime(today.year, quarterNumber.toInt() + 3, 1)
            .subtract(Duration(days: 1));
// Tương tự ở trên
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
    // nếu không phải trường hợp nào thì nó là CUSTOM
    return 'Custom';
  }
}
