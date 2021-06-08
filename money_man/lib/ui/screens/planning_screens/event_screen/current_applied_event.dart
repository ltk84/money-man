import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

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
  List<Event> currentlyEvent = [];
  Wallet _wallet;
  @override
  void initState() {
    _wallet = widget.wallet;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      color: Colors.grey[900],
      child: StreamBuilder<List<Event>>(
        stream: _firestore.eventStream(_wallet.id),
        builder: (context, snapshot) {

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
            if(!element.isFinished)
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
                return Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ))),
                    padding: EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 0),
                    child: Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: SuperIcon(
                          iconPath: currentlyEvent[index].iconPath,
                          size: 45,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 14, 0),
                        child: Column(
                          children: <Widget>[
                            Text(currentlyEvent[index].name ,
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                              textAlign: TextAlign.start,
                              strutStyle: StrutStyle(
                                leading: 2,
                              ),
                            ),
                            Row(
                              children: [
                                Text('Spent',
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.white),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ],
                        )
                      ),
                      Expanded(
                        child: Text('\n' + currentlyEvent[index].spent.toString(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.white
                          ),
                          strutStyle: StrutStyle(
                            leading: 2.2,
                          ),
                        ),
                      ),
                    ]
                    )
                );
              }
          );
        },
      ),
    );
  }
}
