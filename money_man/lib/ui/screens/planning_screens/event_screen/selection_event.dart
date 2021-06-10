import 'package:flutter/material.dart';
import 'package:money_man/core/models/event_model.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class SelectEventScreen extends StatefulWidget {
  Wallet wallet;
  Event event;
  SelectEventScreen({Key key, this.wallet, this.event}) : super(key: key);
  @override
  _SelectEventScreen createState() =>
      _SelectEventScreen();
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leadingWidth: 70.0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0))),
        leading: TextButton(
            onPressed: () {
              Navigator.of(context).pop(_wallet);
            },
            child: const Text(
              'Back',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.transparent,
            )),
        title: Text('Select Event',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                fontSize: 15.0)),
      ),
      body: Container(
        color: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<List<Event>>(
                  stream: _firestore.eventStream(_wallet.id),
                  builder: (context, snapshot) {
                    final listEvent = snapshot.data ?? [];
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
