import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/widgets/money_symbol_formatter.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/event_detail.dart';

class CurrentlyAppliedEvent extends StatefulWidget {
  Wallet wallet;
  CurrentlyAppliedEvent({Key key, this.wallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _CurrentlyAppliedEvent();
  }
}

class _CurrentlyAppliedEvent extends State<CurrentlyAppliedEvent>
    with TickerProviderStateMixin {
  Wallet _wallet;
  @override
  void initState() {
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
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      color: Style.backgroundColor,
      child: StreamBuilder<List<Event>>(
        stream: _firestore.eventStream(_wallet.id),
        builder: (context, snapshot) {
          List<Event> currentlyEvent = [];
          List<Event> eventList = snapshot.data ?? [];
          eventList.forEach((element) {
            if (element.endDate.year < DateTime.now().year ||
                (element.endDate.year == DateTime.now().year &&
                    element.endDate.month < DateTime.now().month) ||
                (element.endDate.year == DateTime.now().year &&
                    element.endDate.month == DateTime.now().month &&
                    element.endDate.day < DateTime.now().day)) {
              element.isFinished = true;
            }
            if ((!element.isFinished && !element.finishedByHand) ||
                (element.isFinished &&
                    !element.finishedByHand &&
                    !element.autofinish) ||
                (!element.isFinished && element.autofinish)) {
              currentlyEvent.add(element);
            }
          });
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
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
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
                                  fontSize: 24.0,
                                  color: Style.foregroundColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat'),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              'End date: ' +
                                  DateFormat('EEEE, dd-MM-yyyy')
                                      .format(currentlyEvent[index].endDate),
                              style: TextStyle(
                                  fontSize: 14.0,
                                  color:
                                      Style.foregroundColor.withOpacity(0.54),
                                  fontFamily: 'Montserrat'),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  'Spent: ',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Style.foregroundColor,
                                      fontFamily: 'Montserrat'),
                                  textAlign: TextAlign.start,
                                ),
                                MoneySymbolFormatter(
                                    text: currentlyEvent[index].spent,
                                    currencyId: _wallet.currencyID,
                                    textStyle: TextStyle(
                                      color: Style.foregroundColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
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
