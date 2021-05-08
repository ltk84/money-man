import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/iconPicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/add_wallet_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/edit_wallet_screen.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class WalletSelectionScreen extends StatefulWidget {
  String id = '';
  WalletSelectionScreen({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  _WalletSelectionScreenState createState() => _WalletSelectionScreenState();
}

class _WalletSelectionScreenState extends State<WalletSelectionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FlutterIconPicker.showIconPicker(context);
  }

  @override
  Widget build(BuildContext context) {
    print('wallet selection build' + widget.id.toString());
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Container(
      color: Colors.transparent,
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
                  Navigator.of(context).pop(widget.id);
                },
                child: const Text(
                  'Close',
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
            title: Text('Select Wallet',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0)),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Wallet wallet = await _firestore.getWalletByID(widget.id);
                    var res = '';
                    res = await showCupertinoModalBottomSheet(
                      backgroundColor: Colors.grey[900],
                      context: context,
                      builder: (context) => EditWalletScreen(wallet: wallet),
                    );
                    if (res != null)
                      setState(() {
                        widget.id = res;
                        // widget.changeWallet(_firestore.getWalletByID(res));
                      });
                  },
                  child: const Text(
                    'Edit',
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
                  // child: ListTile(
                  //   leading: Icon(
                  //     Icons.all_inclusive_outlined,
                  //     color: Colors.white,
                  //   ),
                  //   title: Text(
                  //     'Total',
                  //     style: tsMain,
                  //   ),
                  //   subtitle: Text(
                  //     '(amount)',
                  //     style: tsChild,
                  //   ),
                  //   trailing: Icon(
                  //     Icons.check,
                  //     color: Colors.blue,
                  //   ),
                  // ),
                  child: buildDisplayTotalWallet(),
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
                buildDisplayWallet(),
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
                      onPressed: () async {
                        final res = await showCupertinoModalBottomSheet(
                            backgroundColor: Colors.grey[900],
                            context: context,
                            builder: (context) => AddWalletScreen());
                        // print('return from add screen ' + res.toString());
                        if (res != null)
                          setState(() {
                            widget.id = res;
                            // widget.changeWallet(_firestore.getWalletByID(res));
                          });
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

  Widget buildDisplayTotalWallet() {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return widget.id == 'Total'
        ? ListTile(
            onTap: () {},
            leading: Icon(
              Icons.all_inclusive_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Total',
              style: tsMain,
            ),
            subtitle: Text(
              '(amount)',
              style: tsChild,
            ),
            trailing: Icon(
              Icons.check,
              color: Colors.blue,
            ),
          )
        : ListTile(
            onTap: () {
              setState(() {
                widget.id = 'Total';
                _firestore.updateSelectedWallet('Total');
              });
            },
            leading: Icon(
              Icons.all_inclusive_outlined,
              color: Colors.white,
            ),
            title: Text(
              'Total',
              style: tsMain,
            ),
            subtitle: Text(
              '(amount)',
              style: tsChild,
            ),
          );
  }

  Widget buildDisplayWallet() {
    print('wallet select inside build + ${widget.id}');
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Expanded(
      child: StreamBuilder<List<Wallet>>(
          stream: _firestore.streamWallet,
          builder: (context, snapshot) {
            final listWallet = snapshot.data ?? [];
            listWallet.removeWhere((element) => element.id == 'Total');
            print('stream ' + listWallet.length.toString());
            return ListView.builder(
                itemCount: listWallet.length,
                itemBuilder: (context, index) {
                  IconData iconData = IconData(
                      int.tryParse(listWallet[index].iconID),
                      fontFamily: 'MaterialIcons');

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
                                iconData,
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
                            // setState(() {
                            //   widget.id = listWallet[index].id;
                            //   _firestore.updateSelectedWallet(widget.id);
                            // });
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
                              onTap: () {
                                widget.id = listWallet[index].id;
                                _firestore.updateSelectedWallet(widget.id);
                                Navigator.pop(context);
                              },
                              leading: Icon(
                                iconData,
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
