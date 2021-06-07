import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class CurrentlyAppliedEvent extends StatelessWidget {
  Wallet wallet;
  CurrentlyAppliedEvent({Key key, this.wallet}) : super(key: key);
  List<Event> currentlyEvent = [];
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Container(
      color: Colors.grey[900],
      child: StreamBuilder<List<Event>>(
        stream: _firestore.eventStream(wallet.id),
        builder: (context, snapshot) {

          List<Event> eventList = snapshot.data ?? [];

          eventList.forEach((element) {
            if(!element.isFinished)
              {
                currentlyEvent.add(element);
              }
          }
          );
          return ListView.builder(
            itemCount: 1,
              itemBuilder: (context,index)
              {
                return Text( eventList.length.toString(),
                  style: TextStyle(
                      color: Colors.white,
                    fontSize: 30,
                  ),);
              }
          );
        },
      ),
    );
  }
}
