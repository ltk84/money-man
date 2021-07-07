import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/event_detail.dart';
import 'package:intl/intl.dart';

// Đây là màn hình hiện trong tab running của event home
class CurrentlyAppliedEvent extends StatefulWidget {
  Wallet wallet; // truyền ví hiện tại vào
  CurrentlyAppliedEvent({Key key, this.wallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CurrentlyAppliedEvent();
  }
}

class _CurrentlyAppliedEvent extends State<CurrentlyAppliedEvent>
    with TickerProviderStateMixin {
  Wallet _wallet; // truyền ví hiện tại vào
  @override
  void initState() {
    // Khởi tạo giá trị cho biến _wallet khi vừa init state
    _wallet = widget.wallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CurrentlyAppliedEvent oldWidget) {
    // update lại dữ liệu của biến _wallet khi có sự thay đổi nào đó :3
    _wallet = widget.wallet ??
        Wallet(
            id: 'id',
            name: 'defaultName',
            amount: 100,
            currencyID: 'USD',
            iconID: 'assets/icons/wallet_2.svg');
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    // Tham chiếu đến các hàm của firebase
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      color: Style.backgroundColor,
      // Stream lấy tất cả các event
      child: StreamBuilder<List<Event>>(
        stream: _firestore.eventStream(_wallet.id),
        builder: (context, snapshot) {
          // List lưu trữ những event đang chạy sắp được lọc ra
          List<Event> currentlyEvent = [];
          // List lưu trữ tất cả các event
          List<Event> eventList = snapshot.data ?? [];
          // Nếu nó đã quá này, mark nó như là isFinished
          eventList.forEach((element) {
            if (element.endDate.year < DateTime.now().year ||
                (element.endDate.year == DateTime.now().year &&
                    element.endDate.month < DateTime.now().month) ||
                (element.endDate.year == DateTime.now().year &&
                    element.endDate.month == DateTime.now().month &&
                    element.endDate.day < DateTime.now().day)) {
              element.isFinished = true;
            }
            // Xét những điều kiện để nó còn đang hoạt động, thêm nó vào danh sách những event đang hoạt động
            if ((!element.isFinished && !element.finishedByHand) ||
                (element.isFinished &&
                    !element.finishedByHand &&
                    !element.autofinish) ||
                (!element.isFinished && element.autofinish)) {
              currentlyEvent.add(element);
            }
          });

          // Nếu không có event nào, hiển thị màn hình báo không có event nào
          if (currentlyEvent.length == 0)
            return Container(
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
                      'There are no events',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.24),
                      ),
                    ),
                  ],
                ));

          // Nếu có thì ta hiển thị danh sách các event đang chạy thôi :3
          return Container(
            padding: EdgeInsets.only(top: 35, left: 15, right: 15),
            child: ListView.builder(
                physics: ScrollPhysics(),
                itemCount: currentlyEvent.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Style.boxBackgroundColor,
                    ),
                    child: ListTile(
                      // Vào trang chi tiết event khi bấm vào các event trên màn hình
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: EventDetailScreen(
                                  currentEvent: currentlyEvent[index],
                                  eventWallet: _wallet,
                                )));
                      },
                      leading: SuperIcon(
                        iconPath: currentlyEvent[index].iconPath,
                        size: 45,
                      ),
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentlyEvent[index].name,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Style.fontFamily),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  'Ending date: ',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Style.foregroundColor
                                          .withOpacity(0.54),
                                      fontFamily: Style.fontFamily),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  DateFormat('EEEE, dd-MM-yyyy')
                                      .format(currentlyEvent[index].endDate),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: (currentlyEvent[index].isFinished)
                                          ? Colors.red
                                          : Style.foregroundColor,
                                      fontFamily: Style.fontFamily),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  'Spent: ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Style.foregroundColor
                                          .withOpacity(0.54),
                                      fontFamily: Style.fontFamily),
                                  textAlign: TextAlign.start,
                                ),
                                MoneySymbolFormatter(
                                    text: currentlyEvent[index].spent,
                                    currencyId: _wallet.currencyID,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Style.foregroundColor,
                                      fontSize: 15,
                                      fontFamily: Style.fontFamily,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
