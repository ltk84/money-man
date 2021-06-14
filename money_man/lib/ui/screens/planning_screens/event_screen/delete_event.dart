import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/report_screens/report_list_transaction_in_time.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
class DeleteEventScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  int count;
  DeleteEventScreen({Key key,
    this.currentEvent,
    this.eventWallet,
    this.count,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _DeleteEventScreen();
  }
}
class _DeleteEventScreen extends State<DeleteEventScreen>
    with TickerProviderStateMixin {
  Event _currentEvent;
  Wallet _eventWallet;
  List<MyTransaction> listTransactionOfEventByDate = [];
  Event event = Event(
    iconPath: 'assets/icons/wallet_2.svg',
    id: '',
    name: 'na',
    endDate: DateTime.now(),
    walletId:'id',
    isFinished: false,
    transactionIdList: [],
    spent:0,
    finishedByHand:false,
    autofinish: false,
  );
  @override
  void initState() {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return StreamBuilder<Object>(
        stream: _firestore.transactionStream(_eventWallet, 100),
        builder: (context,snapshot) {
          double total = 0;
          listTransactionOfEventByDate = [];
          List<MyTransaction> listTransaction = snapshot.data??[];
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
          listTransactionOfEventByDate.sort(
                  (a, b) => b.date.compareTo(a.date));
          return Scaffold(
            backgroundColor: Colors.grey[850],
            appBar: AppBar(
              backgroundColor: Colors.grey[900],
              title: Text('Delete event'),
            ),
            body: ListView(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(12,25,12,20),
                  child: Text(widget.count < 2 ?
                  widget.count.toString() + ' transaction in event'
                    : widget.count.toString() + ' transactions in event',
                    style: TextStyle(
                        color:  Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height :listTransactionOfEventByDate.length.toDouble()*65,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: listTransactionOfEventByDate.length,
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            title:  Row(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                    child: SuperIcon(
                                      iconPath: listTransactionOfEventByDate[index].category.iconID,
                                      size: 35,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 18, 0),
                                  child: Text(
                                      listTransactionOfEventByDate[index].category.name,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                ),
                                Expanded(
                                  child: Text(listTransactionOfEventByDate[index].category.type == 'income' ?
                                  '+' + listTransactionOfEventByDate[index].amount.toString()
                                      : '-' + listTransactionOfEventByDate[index].amount.toString(),
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: listTransactionOfEventByDate[index].category.type == 'income'
                                              ? Colors.green
                                              : Colors.red[600])),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(12),
                          child: Text('Do you want to delete only event or delete all transactions in the event?',
                            style: TextStyle(
                              color:  Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          child: RaisedButton(
                            padding: EdgeInsets.all(12),
                            onPressed: () async {
                              listTransactionOfEventByDate.forEach((element)  async {
                                element.eventID= "";
                                await _firestore.updateTransactionAfterDeletingEvent(element, _eventWallet);
                              });
                              await _firestore.deleteEvent(_currentEvent.id, _eventWallet.id);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete only event', style: TextStyle(fontSize: 20)),
                            color: Colors.red,
                            textColor: Colors.white,
                            elevation: 5,
                          ),
                        ),
                        Container(
                          height: 8,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          width: double.infinity,
                          child: RaisedButton(
                            padding: EdgeInsets.all(12),
                            onPressed: () async {
                              listTransactionOfEventByDate.forEach((element) async {
                                await _firestore.deleteTransaction(element, _eventWallet);
                              });
                              await  _firestore.deleteEvent(_currentEvent.id, _eventWallet.id);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete both', style: TextStyle(fontSize: 20)),
                            color: Colors.red,
                            textColor: Colors.white,
                            elevation: 5,
                          ),
                        ),
                      ],
                    )
                )
              ],
            ),
          );
        }
    );
  }
}
