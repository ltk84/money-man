import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/core/models/transactionModel.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/enter_amount_screen.dart';
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
                    widget.transaction, widget.wallet);
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
            onTap: () async {
              final resultAmount = await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => EnterAmountScreen()));
              if (resultAmount != null)
                setState(() {
                  print(resultAmount);
                  widget.transaction.amount = double.parse(resultAmount);
                });
            },
            leading: Icon(Icons.money),
            title: TextFormField(
              readOnly: true,
              onTap: () async {
                final resultAmount = await Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EnterAmountScreen()));
                if (resultAmount != null)
                  setState(() {
                    print(resultAmount);
                    widget.transaction.amount = double.parse(resultAmount);
                  });
              },
              // onChanged: (value) => amount = double.tryParse(value),
              style: TextStyle(color: Colors.green),
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.green),
                  hintText: widget.transaction.amount == null
                      ? '0'
                      : MoneyFormatter(amount: widget.transaction.amount)
                          .output
                          .withoutFractionDigits),
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
            // leading: Icon(Icons.wallet_giftcard),
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
