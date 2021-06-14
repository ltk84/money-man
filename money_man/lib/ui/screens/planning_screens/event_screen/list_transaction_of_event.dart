
import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/report_screens/report_list_transaction_in_time.dart';
import 'package:provider/provider.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/list_transaction_event.dart';
class EventListTransactionScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  EventListTransactionScreen({Key key, this.currentEvent, this.eventWallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EventListTransactionScreen();
  }
}
class _EventListTransactionScreen extends State<EventListTransactionScreen>
    with TickerProviderStateMixin {
  Event _currentEvent;
  Wallet _eventWallet;
  List<DateTime> dateInChoosenTime = [];
  @override
  void initState() {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.initState();
  }
  @override
  void didUpdateWidget(covariant EventListTransactionScreen oldWidget) {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<Object>(
        stream: _firestore.transactionStream(_eventWallet, 100),
        builder: (context,snapshot) {
          double total = 0;
          List<MyTransaction> listTransaction = snapshot.data??[];
          List<MyTransaction> listTransactionOfEventByDate = [];
          listTransaction.forEach((element) {
            if(element.eventID != null)
              if(element.eventID == _currentEvent.id)
              {
                listTransactionOfEventByDate.add(element);
                if(element.category.type == 'income')
                  total += element.amount;
                else
                  total -= element.amount;
              }
          });
          listTransactionOfEventByDate.sort((a, b) => b.date.compareTo(a.date));
          return (listTransactionOfEventByDate.length == 0)?
          Scaffold(
              backgroundColor: Colors.black,
              appBar: new AppBar(
                backgroundColor: Colors.black,
                centerTitle: true,
                elevation: 0,
                title: Text('Transaction List'),
              ),
              body: Container(
                alignment:  Alignment.center,
                child: Text(
                  'No transaction',
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white54,
                  ),
                ),
              )
          ):
          ListTransactionEvent(
            endDate : listTransactionOfEventByDate[0].date,
            beginDate: listTransactionOfEventByDate[listTransactionOfEventByDate.length-1].date,
            currentList: listTransactionOfEventByDate,
            totalMoney : total,
            currentWallet: _eventWallet,
            event: _currentEvent,
          );
        }
    );
  }
}