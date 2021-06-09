
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/wallet_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/add_event.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/applied_event.dart';
import 'package:money_man/ui/screens/planning_screens/event_screen/current_applied_event.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_selection.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  Wallet currentWallet;
  EventScreen({Key key, this.currentWallet}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with TickerProviderStateMixin {
  TabController _tabController;
  Wallet _wallet;
  @override
  void initState() {
    super.initState();
    _wallet = widget.currentWallet ;
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: StreamBuilder<Object>(
            stream: _firestore.currentWallet,
            builder: (context, snapshot) {
              _wallet = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xff333333),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: Text(
                    "Event",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () async {
                        buildShowDialog(context, _wallet.id);
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Row(
                          children: [
                            SuperIcon(
                              iconPath: _wallet.iconID,
                              size: 25.0,
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey)
                          ],
                        ),
                      ),
                    ),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    labelPadding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    indicatorPadding: EdgeInsets.zero,
                    controller: _tabController,
                    indicatorColor: Color(0xffd3db00),
                    indicatorWeight: 2,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelColor: Colors.white30,
                    tabs: [
                      Tab(
                          child: Container(
                            width: 120,
                            child: Text(
                              "Running",
                            ),
                          )),
                      Tab(
                          child: Container(
                            width: 120,
                            child: Text(
                              "Finished",
                            ),
                          )),
                    ],
                  ),
                  elevation: 2,
                ),
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    CurrentlyAppliedEvent(
                      wallet: _wallet,
                    ),
                    AppliedEvent(
                      wallet: _wallet,
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Theme.of(context).hintColor,
                  child:  Icon(
                  Icons.add_circle,
                  color: Color(0xFF2FB49C),
                  size: 50.0,
                  ),
                    onPressed:   () async {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (_) => AddEvent(),
                          )
                      );
                    }
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
              );
            }),
      ),
    );
  }
  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);

    showCupertinoModalBottomSheet(
        isDismissible: true,
        backgroundColor: Colors.grey[900],
        context: context,
        builder: (context) {
          return Provider(
              create: (_) {
                return FirebaseFireStoreService(uid: _auth.currentUser.uid);
              },
              child: WalletSelectionScreen(
                id: id,
              ));
        });
  }
}
