import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/budget_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/edit_budget.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/widget/line_chart_progress.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/screens/planning_screens/budget_screens/budget_transaction.dart';

// được hiển thị khi ấn vào budget tile ở màn hình budget home
class BudgetDetailScreen extends StatefulWidget {
  const BudgetDetailScreen({Key key, this.budget, this.wallet})
      : super(key: key);
  final Budget budget; // Budget được chọn
  final Wallet wallet; // ví của budget được chọn

  @override
  _BudgetDetailScreenState createState() => _BudgetDetailScreenState();
}

class _BudgetDetailScreenState extends State<BudgetDetailScreen> {
  bool isNotifi = false;

  // Hàm trả về string mô tả khoảng thời gian theo ngày tháng năm
  String valueDate(Budget budget) {
    String result = DateFormat('dd/MM/yyyy').format(budget.beginDate) +
        ' - ' +
        DateFormat('dd/MM/yyyy').format(budget.endDate);
    return result;
  }

  //Hàm trả về string mô tả thời gian hiện tại tương ứng với thời gian của budget như thế nào
  String getTimeLeft(Budget budget) {
    var today = DateTime.now();
    if (today.isBefore(budget.beginDate)) {
      int n = budget.beginDate.difference(today).inDays;
      if (n > 1) {
        return '$n days to begin';
      } else
        return '$n day to begin';
    } else if (today.isAfter(budget.endDate)) {
      return 'Finished';
    } else {
      int n = budget.endDate.difference(today).inDays;
      if (n > 1) {
        return '$n days left';
      } else
        return '$n day left';
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    // Số ngày kể từ ngày bắt đầu, nhỏ nhất là 1
    var currentTime =
        (DateTime.now()).difference(widget.budget.beginDate).inDays;
    if (currentTime == 0) currentTime = 1;
    // todayRate là biến biểu thị tỉ lệ thời gian hiện tại trong khoảng thời gian của budget. nếu >1 đã kết thúc, <0 chưa bắt đầu
    var todayRate =
        DateTime.now().difference(widget.budget.beginDate).inMicroseconds /
            widget.budget.endDate
                .add(Duration(days: 1))
                .difference(widget.budget.beginDate)
                .inMicroseconds;
    // tại thời điểm chính là thời điểm bắt đầu, không để giá trị của nó là 0.
    if (todayRate == 0) todayRate = 0.00001;
    print('todayrate : $todayRate');
    var todayTarget;
    todayTarget = widget.budget.spent / widget.budget.amount;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Style.backIcon,
              color: Style.foregroundColor,
            )),
        title: Text('Budget'),
        centerTitle: true,
        actions: [
          // Button chỉnh sửa budget
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Style.foregroundColor,
            ),
            onPressed: () async {
              await showCupertinoModalBottomSheet(
                  isDismissible: true,
                  backgroundColor: Colors.grey[900],
                  context: context,
                  builder: (context) => EditBudget(
                        budget: widget.budget,
                        wallet: widget.wallet,
                      ));
              setState(() {});
            },
          ),
          // button xóa budget
          IconButton(
              icon: Icon(Icons.delete, color: Style.foregroundColor),
              onPressed: () async {
                // Hiện dialog hỏi có muốn xóa không
                String res = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Budget'),
                    content: const Text('Do you want to delete this budget?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('yes'),
                      ),
                    ],
                  ),
                );
                print(res);
                if (res == 'OK') {
                  await _firestore.deleteBudget(
                      widget.budget.walletId, widget.budget.id);
                  Navigator.pop(context);
                }
              })
        ],
        backgroundColor: Style.appBarColor,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: Style.backgroundColor,
        child: ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            // Hiển thị tên nhóm + số tiền + hình ảnh của nhóm giao dịch
            ListTile(
              minVerticalPadding: 10,
              minLeadingWidth: 50,
              leading: Container(
                  child: SuperIcon(
                iconPath: widget.budget.category.iconID,
                size: 45,
              )),
              title: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.widget.budget.category.name,
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontWeight: FontWeight.w600,
                        color: Style.foregroundColor,
                        fontSize: 24,
                      ),
                    ),
                    Container(
                        child: MoneySymbolFormatter(
                          checkOverflow: false,
                      text: widget.budget.amount,
                      currencyId: widget.wallet.currencyID,
                      textStyle: TextStyle(
                          fontFamily: Style.fontFamily,
                          color: widget.budget.category.type == 'expense'
                              ? Style.expenseColor
                              : Style.incomeColor2,
                          fontSize: 32,
                          fontWeight: FontWeight.w500),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spent',
                                      style: TextStyle(
                                          fontFamily: Style.fontFamily,
                                          fontSize: 12,
                                          color: Style.foregroundColor
                                              .withOpacity(0.54),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 2),
                                    MoneySymbolFormatter(
                                      checkOverflow: true,
                                      text: widget.budget.spent,
                                      currencyId: widget.wallet.currencyID,
                                      textStyle: TextStyle(
                                          fontFamily: Style.fontFamily,
                                          color: Style.foregroundColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              // Hiển thị số tiền đã chi, còn lại/vượt quá bao nhiêu
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      todayTarget > 1 ? 'Over spent' : 'Remain',
                                      style: TextStyle(
                                          fontFamily: Style.fontFamily,
                                          fontSize: 12,
                                          color: Style.foregroundColor
                                              .withOpacity(0.54),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(height: 2),
                                    MoneySymbolFormatter(
                                      checkOverflow: true,
                                      text: todayTarget > 1
                                          ? this.widget.budget.spent -
                                              this.widget.budget.amount
                                          : this.widget.budget.amount -
                                              this.widget.budget.spent,
                                      currencyId: widget.wallet.currencyID,
                                      textStyle: TextStyle(
                                          fontFamily: Style.fontFamily,
                                          color: Style.foregroundColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          // Hiển thị progress bar
                          Container(
                            margin: EdgeInsets.only(top: 6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                  backgroundColor: Style.boxBackgroundColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      todayTarget > 1
                                          ? Colors.red[700]
                                          : todayTarget > todayRate
                                              ? Colors.orange[700]
                                              : Color(0xFF2FB49C)),
                                  minHeight: 3,
                                  value: this.widget.budget.spent /
                                      this.widget.budget.amount),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Này là để hiển thị hôm nay nằm ở đâu của ngân sách
            Row(
              children: [
                // Nếu chưa bắt đầu hoặc hết hạn thì không để today
                widget.budget.beginDate.isAfter(today) ||
                        today.isAfter(widget.budget.endDate)
                    ? Container()
                    : Container(
                        // Căn lề theo từng pixel, sử dụng kiến thức toán học để tính toán margin
                        margin: EdgeInsets.only(
                            left: 60 +
                                (MediaQuery.of(context).size.width - 60 - 45) *
                                    todayRate),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),

                        // height: 20,
                        //width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Style.boxBackgroundColor),
                        child: Text(
                          "Today",
                          style: TextStyle(
                              fontFamily: Style.fontFamily,
                              color: Style.foregroundColor,
                              fontSize: 10),
                        ),
                      ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 80),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.12),
                thickness: 1,
              ),
            ),
            // này để hiển thị ngày của budget
            ListTile(
              dense: true,
              minLeadingWidth: 50,
              leading: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.date_range_outlined,
                    color: Style.foregroundColor,
                    size: 28,
                  )),
              title: Container(
                child: Text(
                  valueDate(widget.budget),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor,
                  ),
                ),
              ),
              subtitle: Container(
                child: Text(
                  getTimeLeft(widget.budget),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor.withOpacity(0.54),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 80),
              child: Divider(
                color: Style.foregroundColor.withOpacity(0.12),
                thickness: 1,
              ),
            ),
            // Này để hiển thị ví
            ListTile(
                minLeadingWidth: 50,
                leading: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: SuperIcon(
                    iconPath: '${widget.wallet.iconID}',
                    size: 30,
                  ),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 10.0,
                        fontFamily: Style.fontFamily,
                        color: Style.foregroundColor.withOpacity(0.54),
                      ),
                    ),
                    Text(
                      '${widget.wallet.name}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                        fontFamily: Style.fontFamily,
                        color: Style.foregroundColor,
                      ),
                    ),
                  ],
                )),
            Divider(
              color: Style.foregroundColor.withOpacity(0.12),
              thickness: 1,
            ),
            // Này để hiển thị cái sơ đồ
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.only(top: 30),
                padding: EdgeInsets.only(left: 15, right: 30),
                color: Style.backgroundColor,
                width: MediaQuery.of(context).size.width,
                height: 170,
                child: LineCharts(
                  budget: widget.budget,
                  todayRate: todayRate,
                  todayTaget: todayTarget,
                ),
              ),
            ),
            // Tính toán các số ước tính
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          // này là số tiền nên chi tiêu trong 1 ngày
                          'Should spend/day ',
                          style: TextStyle(
                              fontFamily: Style.fontFamily,
                              color: Style.foregroundColor.withOpacity(0.54),
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        MoneySymbolFormatter(
                          text: widget.budget.amount /
                              (widget.budget.endDate)
                                  .difference(widget.budget.beginDate)
                                  .inDays,
                          currencyId: widget.wallet.currencyID,
                          textStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w500,
                              color: Style.foregroundColor,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          // Thực tế chi tiêu trong 1 ngày
                          'Actual spend/day',
                          style: TextStyle(
                              fontFamily: Style.fontFamily,
                              color: Style.foregroundColor.withOpacity(0.54),
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        MoneySymbolFormatter(
                          text: widget.budget.spent / currentTime,
                          currencyId: widget.wallet.currencyID,
                          textStyle: TextStyle(
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w500,
                              color: Style.foregroundColor,
                              fontSize: 16),
                        ),
                      ],
                    )
                  ]),
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        // Dự đoán khoảng tiền chi tiêu trong suốt khoảng thời gian của budget
                        'Expected spending',
                        style: TextStyle(
                            fontFamily: Style.fontFamily,
                            color: Style.foregroundColor.withOpacity(0.54),
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                      MoneySymbolFormatter(
                        text: widget.budget.spent /
                            currentTime *
                            (widget.budget.endDate)
                                .difference(widget.budget.beginDate)
                                .inDays,
                        currencyId: widget.wallet.currencyID,
                        textStyle: TextStyle(
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w500,
                            color: Style.foregroundColor,
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Divider(
                color: Style.foregroundColor.withOpacity(0.24), thickness: 0.5),
            // Bật tắt thông báo cho budget
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Turn on notification',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: Style.fontFamily,
                      color: Style.foregroundColor,
                    ),
                  ),
                  Switch(
                      value: isNotifi,
                      onChanged: (val) {
                        setState(() {
                          isNotifi = !isNotifi;
                        });
                      })
                ],
              ),
            ),
            Divider(
                color: Style.foregroundColor.withOpacity(0.24), thickness: 0.5),
            //Xem danh sách các giao dịch thuộc budget
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              alignment: Alignment.center,
              child: TextButton(
                  // Chuyển hướng đến màn hình hiển thị danh sách
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: BudgetTransactionScreen(
                              wallet: widget.wallet,
                              budget: widget.budget,
                            )));
                    await _firestore.updateBudget(widget.budget, widget.wallet);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF2FB49C),
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      'Transaction list',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: Style.fontFamily,
                        color: Style.foregroundColor,
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
