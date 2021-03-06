import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:provider/provider.dart';

// Màn hình chọn event xuất hineej khi chọn event trong add transaction
class SelectEventScreen extends StatefulWidget {
  final Wallet wallet; // ví được chọn
  Event event; // event đã chọn
  final DateTime timeTransaction; // thời gian của transaction
  SelectEventScreen({Key key, this.wallet, this.event, this.timeTransaction})
      : super(key: key);
  @override
  _SelectEventScreen createState() => _SelectEventScreen();
}

class _SelectEventScreen extends State<SelectEventScreen> {
  Wallet _wallet;
  DateTime _timeTransaction;
  @override
  void initState() {
    // Khởi tạo giá trị truyền vào các biến state
    super.initState();
    _wallet = widget.wallet;
    _timeTransaction = widget.timeTransaction;
  }

  @override
  void didUpdateWidget(covariant SelectEventScreen oldWidget) {
    // updateWidget
    super.didUpdateWidget(oldWidget);
    _wallet = widget.wallet;
    _timeTransaction = widget.timeTransaction;
  }

// Hàm so sánh a và b (ngày)
  bool checkAisBeforeB(DateTime a, DateTime b) {
    if (a.year < b.year) return true;
    if (a.year == b.year && a.month < b.month) return true;
    if (a.year == b.year && a.month == b.month && a.day < b.day) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    //Tham chiếu đến các hàm trong firebase
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.appBarColor,
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        title: Text('Select Event',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,
            )),
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: StreamBuilder<List<Event>>(
                  // stream lấy tất cả các event
                  stream: _firestore.eventStream(_wallet.id),
                  builder: (context, snapshot) {
                    final listEvent = snapshot.data ?? [];
                    // Chỉ lấy những event còn đang running
                    listEvent.removeWhere((element) =>
                        (!element.isFinished && element.finishedByHand) ||
                        (element.isFinished &&
                            element.finishedByHand &&
                            !element.autofinish) ||
                        (!element.finishedByHand &&
                            element.autofinish &&
                            element.isFinished));
                    listEvent.removeWhere((element) =>
                        checkAisBeforeB(element.endDate, _timeTransaction));
                    return ListView.builder(
                        itemCount: listEvent.length,
                        itemBuilder: (context, index) {
                          String iconData = listEvent[index].iconPath;
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Style.boxBackgroundColor,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              //Thực hiện chọn event
                              onTap: () {
                                setState(() {
                                  widget.event = listEvent[index];
                                });

                                Navigator.pop(context, listEvent[index]);
                              },
                              leading:
                                  SuperIcon(iconPath: iconData, size: 35.0),
                              title: Text(
                                listEvent[index].name,
                                style: TextStyle(
                                  color: Style.foregroundColor,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: MoneySymbolFormatter(
                                  text: listEvent[index].spent,
                                  currencyId: _wallet.currencyID,
                                  textStyle: TextStyle(
                                    color: Style.foregroundColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Montserrat',
                                  )),
                              trailing: (_wallet != null &&
                                      _wallet.name == listEvent[index].name)
                                  ? Icon(Icons.check, color: Colors.blue)
                                  : null,
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
