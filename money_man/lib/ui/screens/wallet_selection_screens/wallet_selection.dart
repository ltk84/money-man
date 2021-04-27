import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/add_wallet_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/edit_wallet_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class WalletSelectionScreen extends StatelessWidget {
  final String id;
  WalletSelectionScreen({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Container(
      color: Colors.transparent,
      //padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Scaffold(
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
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600,),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.transparent,
                )),
            title: Text('Select Wallet', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600, fontSize: 15.0)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                        backgroundColor: Colors.grey[900],
                        context: context,
                        builder: (context) => EditWalletScreen()
                    );
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w600,),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.transparent,
                  )),
            ],
          ),
          body: Container(
            color: Colors.black26,
            child: Column(
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border(
                          top: BorderSide(
                            color: Colors.grey[900],
                            width: 1.0,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey[900],
                            width: 1.0,
                          ))),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(Icons.all_inclusive_outlined,
                              color: Colors.white)),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total',
                              style: tsMain,
                            ),
                            Text(
                              '(amount)',
                              style: tsChild,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1, child: Icon(Icons.check, color: Colors.blue))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 5.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'List',
                      style: tsChild_Sec,
                    ),
                  ),
                ),
                WalletDisplay(
                  id: id,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: 33,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border(
                            top: BorderSide(
                              color: Colors.grey[900],
                              width: 1.0,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey[900],
                              width: 1.0,
                            ))),
                    child: TextButton(
                      onPressed: () {
                        showCupertinoModalBottomSheet(
                          backgroundColor: Colors.grey[900],
                          context: context,
                          builder: (context) => AddWalletScreen());
                      },
                      child: Text('Add wallet', style: tsButton_wallet),
                      //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(success)),
                    )),
                Container(
                    height: 33,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey[900],
                        border: Border(
                            top: BorderSide(
                              color: Colors.grey[900],
                              width: 1.0,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey[900],
                              width: 1.0,
                            ))),
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Link to services', style: tsButton_wallet),
                      //style: ButtonStyle(backgroundColor: MaterialStateProperty.all(success)),
                    )),
              ],
            ),
          )),
    );
  }
}

class WalletDisplay extends StatefulWidget {
  String id;
  WalletDisplay({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _WalletDisplayState createState() => _WalletDisplayState();
}

class _WalletDisplayState extends State<WalletDisplay> {
  @override
  Widget build(BuildContext context) {
    print('wallet select build + ${widget.id}');
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Expanded(
      child: StreamBuilder<List<Wallet>>(
          stream: _firestore.streamWallet,
          builder: (context, snapshot) {
            final listWallet = snapshot.data ?? [];
            print(listWallet.length);
            return ListView.builder(
                itemCount: listWallet.length,
                itemBuilder: (context, index) {
                  return widget.id == listWallet[index].id
                      ? GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ))),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                listWallet[index].name,
                                style: tsMain,
                              ),
                              subtitle: Text(
                                listWallet[index].amount.toString(),
                                style: tsChild,
                              ),
                              trailing: Icon(Icons.check, color: Colors.blue),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.id = listWallet[index].id;
                              _firestore.updateSelectedWallet(widget.id);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ),
                                    bottom: BorderSide(
                                      color: Colors.grey[900],
                                      width: 1.0,
                                    ))),
                            child: ListTile(
                              leading: Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white,
                              ),
                              title: Text(
                                listWallet[index].name,
                                style: tsMain,
                              ),
                              subtitle: Text(
                                listWallet[index].amount.toString(),
                                style: tsChild,
                              ),
                            ),
                          ),
                        );
                });
          }),
    );
  }
}
