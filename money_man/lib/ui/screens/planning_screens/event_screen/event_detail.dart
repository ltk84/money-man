import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/delete_event.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/edit_event.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/list_transaction_of_event.dart';
import 'package:money_man/ui/style.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/date_format.dart';

class EventDetailScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  EventDetailScreen({Key key, this.currentEvent, this.eventWallet})
      : super(key: key);
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
    return Scaffold(
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Event',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,
            )),
        backgroundColor: Style.appBarColor,
        leading: TextButton(
          child: Icon(Style.backIcon, color: Style.foregroundColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final updatedTrans = await showCupertinoModalBottomSheet(
                  context: context,
                  builder: (context) => EditEventScreen(
                        currentEvent: _currentEvent,
                        eventWallet: _eventWallet,
                      ));
              if (updatedTrans != null) setState(() {});
            },
            icon: Icon(
              Icons.edit,
              color: Style.foregroundColor,
            ),
            iconSize: 25,
          ),
          IconButton(
              icon: Icon(
                Icons.delete,
                color: Style.foregroundColor,
              ),
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
                              fontFamily: Style.fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Text('No')),
                            FlatButton(
                                onPressed: () async {
                                  _firestore.deleteEvent(
                                      _currentEvent.id, _eventWallet.id);
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Navigator.pop(context);
                                },
                                child: Text('Yes'))
                          ],
                        );
                      });
                } else {
                  final getEvent = await _firestore.getEventByID(
                      _currentEvent.id, _eventWallet);
                  setState(() {
                    _currentEvent = getEvent;
                  });
                  final delete = await Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: DeleteEventScreen(
                            currentEvent: _currentEvent,
                            eventWallet: _eventWallet,
                            count: _currentEvent.transactionIdList.length,
                          )));
                  if (delete != null) setState(() {});
                }
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              decoration: BoxDecoration(
                  color: Style.boxBackgroundColor,
                  border: Border(
                      top: BorderSide(
                        color: Style.foregroundColor.withOpacity(0.12),
                        width: 0.5,
                      ),
                      bottom: BorderSide(
                        color: Style.foregroundColor.withOpacity(0.12),
                        width: 0.5,
                      ))),
              child: Column(
                children: [
                  ListTile(
                    minLeadingWidth: 50,
                    dense: true,
                    leading: SuperIcon(
                      iconPath: _currentEvent.iconPath,
                      size: 45.0,
                    ),
                    title: Text(
                      _currentEvent.name,
                      style: TextStyle(
                        fontFamily: Style.fontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Style.foregroundColor.withOpacity(0.9),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 80, top: 0),
                    child: Divider(
                      color: Style.foregroundColor.withOpacity(0.12),
                      thickness: 0.5,
                    ),
                  ),
                  ListTile(
                    minLeadingWidth: 50,
                    dense: true,
                    leading: Container(
                      padding: EdgeInsets.only(left: 8),
                      child: SuperIcon(
                        iconPath: 'assets/images/time.svg',
                        size: 30,
                      ),
                    ),
                    title: Text(
                        DateFormat('EEEE, dd-MM-yyyy')
                            .format(_currentEvent.endDate),
                        style: TextStyle(
                            color: Style.foregroundColor.withOpacity(0.8),
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0)),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 80, top: 0),
                    child: Divider(
                      color: Style.foregroundColor.withOpacity(0.12),
                      thickness: 0.5,
                    ),
                  ),
                  ListTile(
                    minLeadingWidth: 50,
                    dense: true,
                    leading: Container(
                      padding: EdgeInsets.only(left: 8),
                      child: SuperIcon(
                        iconPath: _eventWallet.iconID,
                        size: 30.0,
                      ),
                    ),
                    title: Text(_eventWallet.name,
                        style: TextStyle(
                            color: Style.foregroundColor.withOpacity(0.8),
                            fontFamily: Style.fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 18.0)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 40,
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (_currentEvent.autofinish &&
                          _currentEvent.isFinished) {
                        _currentEvent.finishedByHand = false;
                      } else {
                        _currentEvent.finishedByHand == false
                            ? _currentEvent.finishedByHand = true
                            : _currentEvent.finishedByHand = false;
                      }
                      _currentEvent.autofinish = false;
                      _firestore.updateEvent(_currentEvent, _eventWallet);
                    });
                  },
                  child: Text(
                    (_currentEvent.finishedByHand ||
                            (_currentEvent.isFinished &&
                                _currentEvent.autofinish))
                        ? 'Mark not complete'
                        : 'Mark complete',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      fontFamily: Style.fontFamily,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Style
                            .primaryColor; // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Style.primaryColor;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                height: 40,
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EventListTransactionScreen(
                              currentEvent: _currentEvent,
                              eventWallet: _eventWallet,
                            )));
                    setState(() {});
                  },
                  child: Text(
                    'Transaction of Event',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      fontFamily: Style.fontFamily,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Style.primaryColor;
                        return Colors.white; // Use the component's default.
                      },
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.white;
                        return Style
                            .primaryColor; // Use the component's default.
                      },
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
