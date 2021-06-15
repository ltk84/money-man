import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
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
      color: Colors.grey[900],
      child: StreamBuilder<List<Event>>(
        stream: _firestore.eventStream(_wallet.id),
        builder: (context, snapshot) {
          List<Event> currentlyEvent = [];
          List<Event> eventList = snapshot.data ?? [];
          eventList.forEach((element) {
            if(element.endDate.year < DateTime.now().year||
                (element.endDate.year == DateTime.now().year
                    && element.endDate.month < DateTime.now().month) ||
                (element.endDate.year == DateTime.now().year
                    && element.endDate.month == DateTime.now().month
            && element.endDate.day < DateTime.now().day ))
              {
                element.isFinished = true;
              }
            if((!element.isFinished && !element.finishedByHand)
                || (element.isFinished && !element.finishedByHand && !element.autofinish)
            ||(!element.isFinished && element.autofinish))
              {
                currentlyEvent.add(element);
              }
          }
          );
          return ListView.builder(
            physics: ScrollPhysics(),
            itemCount: currentlyEvent.length,
              itemBuilder: (context,index)
              {
                return GestureDetector(
                    onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: EventDetailScreen(
                            currentEvent: currentlyEvent[index],
                            eventWallet: _wallet,
                          )
                          )
                  );
                },
                    child:Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ))),
                    padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 0),
                    child: Row(children: <Widget>[
                      Container(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: SuperIcon(
                          iconPath: currentlyEvent[index].iconPath,
                          size: 45,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                          decoration: BoxDecoration(
                              color: Colors.grey[900],
                              border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1.0,
                                  ))),
                          padding: EdgeInsets.fromLTRB(6.0, 6.0, 0.0, 10),
                        child:Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(currentlyEvent[index].name ,
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text('',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize : MainAxisSize.max,
                                children: <Widget>[
                                  Text('End date: ' + DateFormat('EEEE, dd-MM-yyyy').format(currentlyEvent[index].endDate),
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white54),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text((currentlyEvent[index].isFinished)?' (Out of date)':'',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.red),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisSize : MainAxisSize.max,
                                children: <Widget>[
                                  Text('Spent: ',
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        color: Colors.white),
                                    textAlign: TextAlign.start,
                                  ),
                                  Text( currentlyEvent[index].spent.toString(),
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ),
                    ]
                    )
                )
                );
              }
          );
        },
      ),
    );
  }
}
