import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';
import 'event_detail.dart';

//này là màn hình hiển thị trong tab finished của màn hình event home
class AppliedEvent extends StatefulWidget {
  // truyền vào ví hiện tại
  Wallet wallet;
  AppliedEvent({Key key, this.wallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppliedEvent();
  }
}

class _AppliedEvent extends State<AppliedEvent> with TickerProviderStateMixin {
  // Ví hiện tại
  Wallet _wallet;
  @override
  void initState() {
    // Khởi tạo ví hiện tại, nếu null thì tạo 1 ví ảo ???
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
  void didUpdateWidget(covariant AppliedEvent oldWidget) {
    // gán giá trị cho ví hiện tại, nếu vẫn còn null thì tạo ví ảo
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
    // Tham chiếu tới các hàm firebase
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      color: Style.backgroundColor,
      // stream builder tới danh sách các event
      child: StreamBuilder<List<Event>>(
        stream: _firestore.eventStream(_wallet.id),
        builder: (context, snapshot) {
          // Danh sách lọc ra đã kết thúc
          List<Event> appliedEvent = [];
          // Danh sách tất cả các event
          List<Event> eventList = snapshot.data ?? [];
          // với mỗi event, nếu nó đã kết thúc rồi thì đặt isFinished là true
          eventList.forEach((element) {
            if (element.endDate.year < DateTime.now().year ||
                (element.endDate.year == DateTime.now().year &&
                    element.endDate.month < DateTime.now().month) ||
                (element.endDate.year == DateTime.now().year &&
                    element.endDate.month == DateTime.now().month &&
                    element.endDate.day < DateTime.now().day)) {
              element.isFinished = true;
            }
            // Lọc lại nếu đã kết thúc ( bằng tay, hoặc thời gian, hoặc tự động)
            if ((!element.isFinished && element.finishedByHand) ||
                (element.isFinished &&
                    element.finishedByHand &&
                    !element.autofinish) ||
                (!element.finishedByHand &&
                    element.autofinish &&
                    element.isFinished)) {
              appliedEvent.add(element);
            }
          });
          // Nếu không có events nào trong danh sách thì hiển thị màn hình báo rỗng
          if (appliedEvent.length == 0)
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
                      'There are no event',
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Style.foregroundColor.withOpacity(0.24),
                      ),
                    ),
                  ],
                ));
          // Nếu có thì hiển thị màn hình chứa các event đã cho
          return Container(
            color: Style.backgroundColor,
            padding: EdgeInsets.only(top: 35, left: 15, right: 15),
            child: ListView.builder(
                physics: ScrollPhysics(),
                itemCount: appliedEvent.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(bottom: 15),
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Style.boxBackgroundColor,
                    ),
                    child: ListTile(
                      // Chuyển hướng đến màn hình chi tiết event
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: EventDetailScreen(
                                  currentEvent: appliedEvent[index],
                                  eventWallet: _wallet,
                                )));
                      },
                      leading: SuperIcon(
                        iconPath: appliedEvent[index].iconPath,
                        size: 45,
                      ),
                      title: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appliedEvent[index].name,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w500,
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
                                      .format(appliedEvent[index].endDate),
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w600,
                                      color: Style.foregroundColor,
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
                                    text: appliedEvent[index].spent,
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
