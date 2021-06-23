
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
  final Wallet currentWallet;

  const EventScreen({Key key, this.currentWallet}) : super(key: key);
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> with TickerProviderStateMixin {
  TabController _tabController;
  Wallet _wallet;

  @override
  void initState() {
    super.initState();
    _wallet = widget.currentWallet != null?
        widget.currentWallet :
    Wallet(
        id: 'id',
        name: 'defaultName',
        amount: 100,
        currencyID: 'USD',
        iconID: 'assets/icons/wallet_2.svg');
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
            length: 2,
            child:  Scaffold(
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
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(40),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TabBar(
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
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )),
                              Tab(
                                  child: Container(
                                    width: 120,
                                    child: Text(
                                      "Finished",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      elevation: 2,
                    ),
                    body: StreamBuilder<Object>(
                        stream: _firestore.currentWallet,
                        builder: (context, snapshot) {
                          _wallet = snapshot.data?? Wallet(
                              id: 'id',
                              name: 'defaultName',
                              amount: 100,
                              currencyID: 'USD',
                              iconID: 'assets/icons/wallet_2.svg');
                          return Container(
                              color: Color(0xff1a1a1a),
                              padding: EdgeInsets.only(top: 15),
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  CurrentlyAppliedEvent(
                                    wallet: _wallet,
                                  ),
                                  AppliedEvent(
                                    wallet: _wallet,
                                  ),
                                ],
                              )
                          );}
                          ),
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: Theme
                          .of(context)
                          .hintColor,
                      child: Icon(
                        Icons.add_circle,
                        color: Color(0xFF2FB49C),
                        size: 50.0,
                      ),
                      onPressed: () async {
                        await showCupertinoModalBottomSheet(
                            isDismissible: true,
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) =>
                                AddEvent(
                                  wallet: _wallet,
                                ));
                      },
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation
                        .startTop,
                  )
            )
        );
  }
  void buildShowDialog(BuildContext context, id) async {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);
    final _firebase = Provider.of<FirebaseFireStoreService>(context, listen: false);
    final result = await showCupertinoModalBottomSheet(
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
    final updateWallet = await _firebase.getWalletByID(result);
    setState(() {
      _wallet = updateWallet;
    });
  }
}
