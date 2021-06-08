import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class AppliedEvent extends StatefulWidget {
  Wallet wallet;

  AppliedEvent({Key key, this.wallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _AppliedEvent();
  }
}
class _AppliedEvent extends State<AppliedEvent>
    with TickerProviderStateMixin {
  List<Event> appliedEvent = [];
  Wallet _wallet;
  int _limit = 50;
  int _limitIncrement = 20;
  ScrollController listScrollController;
  @override
  void initState() {
    _wallet = widget.wallet;
    listScrollController = ScrollController();
    listScrollController.addListener(scrollListener);
    super.initState();
  }
  @override
  void scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
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
            if(element.isFinished)
            {
              appliedEvent.add(element);
            }
          }
          );
          return ListView.builder(
              physics: ScrollPhysics(),
              itemCount: appliedEvent.length,
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
                    padding: EdgeInsets.fromLTRB(12.0, 35.0, 12.0, 0),
                    child: Row(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: SuperIcon(
                          iconPath: appliedEvent[index].iconPath,
                          size: 45,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 14, 0),
                          child: Column(
                            children: <Widget>[
                              Text(appliedEvent[index].name ,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  )
                              ),
                              Text('Spent',
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      color: Colors.white)),
                            ],
                          )
                      ),
                      Expanded(
                        child: Text('\n' + appliedEvent[index].spent.toString(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: Colors.white
                            )
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
