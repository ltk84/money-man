import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class SelectEventScreen extends StatefulWidget {
  Wallet wallet;
  Event event;
  SelectEventScreen({Key key, this.wallet, this.event}) : super(key: key);
  @override
  _SelectEventScreen createState() => _SelectEventScreen();
}

class _SelectEventScreen extends State<SelectEventScreen> {
  Wallet _wallet;
  @override
  void initState() {
    super.initState();
    _wallet = widget.wallet;
  }

  @override
  void didUpdateWidget(covariant SelectEventScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _wallet = widget.wallet;
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Style.boxBackgroundColor,
        leading: CloseButton(),
        title: Text('Select Event',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,)),
      ),
      body: Container(
        color: Style.backgroundColor1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30,),
            Expanded(
              child: StreamBuilder<List<Event>>(
                  stream: _firestore.eventStream(_wallet.id),
                  builder: (context, snapshot) {
                    final listEvent = snapshot.data ?? [];
                    listEvent.removeWhere((element) =>
                        (!element.isFinished && element.finishedByHand) ||
                        (element.isFinished && element.finishedByHand) ||
                        (!element.finishedByHand &&
                            element.autofinish &&
                            element.isFinished));
                    return ListView.builder(
                        itemCount: listEvent.length,
                        itemBuilder: (context, index) {
                          String iconData = listEvent[index].iconPath;
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.white12,
                                      width: 0.5,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.white12,
                                      width: 0.5,
                                    ))),
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              onTap: () {
                                setState(() {
                                  widget.event = listEvent[index];
                                });

                                Navigator.pop(context, listEvent[index]);
                              },
                              leading:
                                  SuperIcon(iconPath: iconData, size: 35.0),
                              title: Text(
                                listEvent[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                listEvent[index].spent.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: (_wallet != null &&
                                      _wallet.name == listEvent[index].name)
                                  ? Icon(Icons.check, color: Colors.blue)
                                  : null,
                            ),
                          );
                        });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
