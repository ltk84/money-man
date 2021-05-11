import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/wallet_selection_screens/wallet_account_screen.dart';
import 'package:provider/provider.dart';

class EditTransactionScreen extends StatefulWidget {
  MyTransaction transaction;
  Wallet wallet;
  EditTransactionScreen({
    Key key,
    @required this.wallet,
    @required this.transaction,
  }) : super(key: key);

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  DateTime pickDate;
  @override
  Widget build(BuildContext context) {
    final _firestore = Provider.of<FirebaseFireStoreService>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit transaction',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                await _firestore.updateTransaction(
                    widget.transaction, widget.wallet.id);
                Navigator.pop(context, widget.transaction);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.money),
            title: TextFormField(
              onChanged: (value) =>
                  widget.transaction.amount = double.tryParse(value),
              style: TextStyle(color: Colors.green),
              initialValue: widget.transaction.amount.toString(),
            ),
          ),
          ListTile(
              onTap: () {},
              leading: Icon(Icons.ac_unit),
              title: TextField(
                onTap: () {},
                readOnly: true,
                style: TextStyle(color: Colors.black),
                decoration:
                    InputDecoration(hintText: widget.transaction.category.name),
              )),
          ListTile(
            leading: Icon(Icons.note),
            title: TextFormField(
              decoration: InputDecoration(hintText: 'Write note'),
              style: TextStyle(color: Colors.black),
              onChanged: (value) => widget.transaction.note = value,
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: TextFormField(
              onTap: () async {
                DateTime now = DateTime.now();
                pickDate = await showDatePicker(
                    context: context,
                    initialDate: widget.transaction.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030));

                setState(() {
                  widget.transaction.date = DateTime.tryParse(
                      DateFormat('yyyy-MM-dd').format(pickDate));
                });
              },
              readOnly: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: DateFormat('EEEE, dd-MM-yyyy')
                      .format(widget.transaction.date)),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(IconData(int.tryParse(widget.wallet.iconID),
                fontFamily: 'MaterialIcons')),
            title: TextFormField(
              readOnly: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: widget.wallet == null
                      ? 'Select wallet'
                      : widget.wallet.name),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
