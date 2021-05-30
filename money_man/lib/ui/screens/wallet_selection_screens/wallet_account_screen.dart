import 'package:flutter/material.dart';
import 'package:money_man/core/models/superIconModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class SelectWalletAccountScreen extends StatefulWidget {
  Wallet wallet;

  SelectWalletAccountScreen({Key key, this.wallet}) : super(key: key);
  @override
  _SelectWalletAccountScreenState createState() =>
      _SelectWalletAccountScreenState();
}

class _SelectWalletAccountScreenState extends State<SelectWalletAccountScreen> {
  dynamic _wallet;

  @override
  void initState() {
    super.initState();
    _wallet = widget.wallet;
  }

  @override
  void didUpdateWidget(covariant SelectWalletAccountScreen oldWidget) {
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
        title: Text('Select Wallet',
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
            Padding(
                child: Text(
                  'Included in Total',
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
                padding: EdgeInsets.fromLTRB(20, 25, 0, 8)),
            Expanded(
              child: StreamBuilder<List<Wallet>>(
                  stream: _firestore.walletStream,
                  builder: (context, snapshot) {
                    final listWallet = snapshot.data ?? [];
                    listWallet.removeWhere((element) => element.id == 'Total');
                    print('stream ' + listWallet.length.toString());
                    return ListView.builder(
                        itemCount: listWallet.length,
                        itemBuilder: (context, index) {
                          String iconData = listWallet[index].iconID;
                          // IconData iconData = Icons.wallet_giftcard;

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
                                  _wallet = listWallet[index];
                                });

                                Navigator.pop(context, listWallet[index]);
                              },
                              leading:
                                  SuperIcon(iconPath: iconData, size: 35.0),
                              title: Text(
                                listWallet[index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              subtitle: Text(
                                listWallet[index].amount.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              trailing: (_wallet != null &&
                                      _wallet.name == listWallet[index].name)
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
