import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_man/core/models/categoryModel.dart';
import 'package:money_man/ui/screens/categories_screens/categories_transaction_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String date = 'Today';
  MyCategory cate;

  @override
  Widget build(BuildContext context) {
    print('add build');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Add transaction',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.close),
          onPressed: () {},
        ),
        actions: [
          TextButton(
              onPressed: () {},
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
              style: TextStyle(color: Colors.green),
              initialValue: '0',
            ),
          ),
          ListTile(
              onTap: () async {
                final selectCate = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CategoriesTransactionScreen()));
                if (selectCate != null) {
                  setState(() {
                    this.cate = selectCate;
                  });
                }
              },
              leading: cate == null
                  ? Icon(Icons.question_answer)
                  : Icon(Icons.ac_unit),
              title: TextField(
                onTap: () async {
                  final selectCate = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CategoriesTransactionScreen()));
                  if (selectCate != null) {
                    setState(() {
                      this.cate = selectCate;
                    });
                  }
                },
                readOnly: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText:
                        this.cate == null ? 'Select category' : this.cate.name),
              )),
          ListTile(
            leading: Icon(Icons.note),
            title: TextFormField(
              decoration: InputDecoration(hintText: 'Write note'),
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: TextFormField(
              onTap: () async {
                DateTime now = DateTime.now();
                DateTime pick = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2030));
                if (pick != null) {
                  if (pick.day != now.day ||
                      pick.month != now.month ||
                      pick.year != now.year) {
                    String text = DateFormat('EEEE, dd-MM-yyyy').format(pick);
                    setState(() {
                      this.date = text;
                    });
                  }
                }
              },
              readOnly: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(hintText: this.date),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet_rounded),
            title: TextFormField(
              readOnly: true,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(hintText: 'Select wallet'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
