import 'package:flutter/material.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/style.dart';
import 'package:provider/provider.dart';

class SelectWalletAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Select wallet',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            child: Text(
              'Included in Total',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            padding: EdgeInsets.only(left: 10),
          ),
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
                        IconData iconData = IconData(
                            int.tryParse(listWallet[index].iconID),
                            fontFamily: 'MaterialIcons');
                        // IconData iconData = Icons.wallet_giftcard;

                        return Container(
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
                              Navigator.pop(context, listWallet[index]);
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
                            // trailing: Icon(Icons.check, color: Colors.blue),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }
}
