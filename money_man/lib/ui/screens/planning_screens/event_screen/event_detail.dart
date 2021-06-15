import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/delete_event.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/edit_event.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/list_transaction_of_event.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/date_format.dart';

class EventDetailScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  EventDetailScreen({Key key, this.currentEvent, this.eventWallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EventDetailScreen();
  }
}
class _EventDetailScreen extends State<EventDetailScreen>
    with TickerProviderStateMixin {
  Event _currentEvent;
  Wallet _eventWallet;
  @override
  void initState() {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.initState();
  }
  @override
  void didUpdateWidget(covariant EventDetailScreen oldWidget) {
    _currentEvent = widget.currentEvent;
    _eventWallet = widget.eventWallet;
    super.didUpdateWidget(oldWidget);
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    final _wallet = _firestore.getWalletByID(_currentEvent.walletId);
    return Scaffold(
      backgroundColor: Color(0xff1b1b1b),
      appBar: AppBar(
        leadingWidth: 380,
        elevation: 0,
        backgroundColor: Color(0xff1a1a1a),
        leading: TextButton(
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios_outlined,
                  color: Colors.white, size: 16.0),
              SizedBox(width: 6.0),
              const Text('Event',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final updatedTrans = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditEventScreen(
                        currentEvent: _currentEvent,
                        eventWallet: _eventWallet,
                      )));
              if (updatedTrans != null)
                setState(() {
                });
            },
            icon: Icon(Icons.edit),
            iconSize: 25,
          ),
          IconButton(
              icon: Icon(Icons.delete, color:  Colors.white,),
              iconSize: 25,
              onPressed: () async {
                if (_currentEvent.transactionIdList.length == 0) {
                  await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: Text(
                            'Do you want to delete this event?',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                child: Text('No')),
                            FlatButton(
                                onPressed: () async {
                                  _firestore.deleteEvent(_currentEvent.id, _eventWallet.id);
                                  Navigator.of(context, rootNavigator: true).pop();
                                  Navigator.pop(context);
                                },
                                child: Text('Yes'))
                          ],
                        );
                      }
                  );
                }
                else {
                  final getEvent = await _firestore.getEventByID(_currentEvent.id, _eventWallet);
                  setState(() {
                    _currentEvent = getEvent;
                  });
                  final delete = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              DeleteEventScreen(
                                currentEvent: _currentEvent,
                                eventWallet: _eventWallet,
                                count: _currentEvent.transactionIdList.length,
                              )));
                  if (delete != null)
                    setState(() {});
                }
              }
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[900],
                border: Border(
                    bottom: BorderSide(
                      color: Colors.white12,
                      width: 0.5,
                    ),
                    top: BorderSide(
                      color: Colors.white12,
                      width: 0.5,
                    ))),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SuperIcon(
                          iconPath: _currentEvent.iconPath,
                          size: 60.0,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                   _currentEvent.name,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ]
                          )
                        ),
                      )
                    ],
                  ),
                  Divider(
                      color: Colors.white12,
                      thickness: 0.5,
                      indent: 15.0,
                      endIndent: 15.0,
                      height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(Icons.calendar_today_rounded,
                              color: Colors.grey[500],
                              size: 30.0)),
                      Expanded(
                          flex: 3,
                          child: Text(
                              DateFormat('EEEE, dd-MM-yyyy')
                                  .format(_currentEvent.endDate),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: ' Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0))),
                    ],
                  ),
                  Divider(
                      color: Colors.white12,
                      thickness: 0.5,
                      indent: 15.0,
                      endIndent: 15.0,
                      height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: SuperIcon(
                            iconPath: _eventWallet.iconID,
                            size: 30.0,
                          )),
                      Expanded(
                          flex: 3,
                          child: Text(_eventWallet.name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: ' Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0))),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              height: 40,
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if(_currentEvent.autofinish && _currentEvent.isFinished)
                      {
                        _currentEvent.finishedByHand = false;
                      }
                    else{
                      _currentEvent.finishedByHand == false?
                      _currentEvent.finishedByHand = true:
                      _currentEvent.finishedByHand = false;
                    }
                    _currentEvent.autofinish =false;
                    _firestore.updateEvent(_currentEvent, _eventWallet);
                  });
                },
                child: Text((_currentEvent.finishedByHand ||
                    (_currentEvent.isFinished && _currentEvent.autofinish))?
                  'Mark not complete' : 'Mark complete',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.white;
                      return Colors.green; // Use the component's default.
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.green;
                      return Colors.white; // Use the component's default.
                    },
                  ),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              height: 40,
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => EventListTransactionScreen(
                          currentEvent: _currentEvent,
                          eventWallet: _eventWallet,
                        ),
                      )
                  );
                },
                child: Text('Transaction of Event',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                    )),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.white;
                      return Colors.green; // Use the component's default.
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Colors.green;
                      return Colors.white; // Use the component's default.
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
