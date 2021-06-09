import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';
import 'package:intl/src/intl/date_format.dart';

class EditEventScreen extends StatefulWidget {
  Event currentEvent;
  Wallet eventWallet;
  EditEventScreen({Key key, this.currentEvent, this.eventWallet}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _EditEventScreen();
  }
}
class _EditEventScreen extends State<EditEventScreen>
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 380,
        elevation: 0,
        backgroundColor: Color(0xff1a1a1a),
        leading: TextButton(
          child: Row(
            children: [
              const Icon(Icons.arrow_back_ios_outlined,
                  color: Colors.white, size: 16.0),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit event',
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}
