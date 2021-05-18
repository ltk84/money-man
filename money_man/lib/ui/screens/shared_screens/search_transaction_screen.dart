import 'package:flutter/material.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class SearchTransactionScreen extends StatefulWidget {
  final Wallet wallet;

  const SearchTransactionScreen({Key key, @required this.wallet})
      : super(key: key);
  @override
  _SearchTransactionScreenState createState() =>
      _SearchTransactionScreenState();
}

class _SearchTransactionScreenState extends State<SearchTransactionScreen> {
  String searchPattern;

  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          onChanged: (value) => searchPattern = value,
          onEditingComplete: () async {
            FocusScope.of(context).unfocus();
            await _firestore.queryTransationByCategory(
                searchPattern, widget.wallet);
          },
          decoration:
              InputDecoration(hintText: 'Search by #tag, category, etc'),
        ),
        actions: [Icon(Icons.settings_applications)],
      ),
    );
  }
}
