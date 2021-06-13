import 'package:flutter/material.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/models/transaction_model.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class SelectOtherSourceScreen extends StatelessWidget {
  final String title;
  final String titleAtEnd;
  final String criteria;
  final String walletId;
  const SelectOtherSourceScreen({
    Key key,
    @required this.title,
    @required this.titleAtEnd,
    @required this.criteria,
    @required this.walletId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: 10,
        ),
        OtherSourceListView(
          criteria: criteria,
          walletId: walletId,
        ),
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Icon(Icons.money),
          title: Text(
            titleAtEnd,
            style: TextStyle(color: Colors.black),
          ),
          trailing: Icon(Icons.chevron_right),
        )
      ]),
    );
  }
}

class OtherSourceListView extends StatelessWidget {
  final String criteria;
  final String walletId;
  const OtherSourceListView({
    Key key,
    @required this.criteria,
    @required this.walletId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return FutureBuilder<List<MyTransaction>>(
        future: _firestore.getListOfTransactionWithCriteria(criteria, walletId),
        builder: (context, AsyncSnapshot<List<MyTransaction>> snapshot) {
          List<MyTransaction> transList = snapshot.data ?? [];
          print(snapshot.hasData);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: transList.length,
                itemBuilder: (context, index) {
                  MyTransaction trans = transList[index];
                  return ListTile(
                    onTap: () {
                      Navigator.pop(context, trans);
                    },
                    leading:
                        SuperIcon(iconPath: trans.category.iconID, size: 25.0),
                    title: Text(
                      trans.category.name,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      trans.note,
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Column(
                      children: [
                        Text(trans.amount.toString()),
                        Text(trans.amount.toString() + ' left')
                      ],
                    ),
                  );
                });
          }
        });
  }
}
