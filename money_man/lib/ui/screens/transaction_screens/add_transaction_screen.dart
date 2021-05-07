import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String date = 'Today';

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
              leading: Icon(Icons.question_answer),
              title: TextField(
                readOnly: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(hintText: 'Select category'),
                onTap: () {},
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
                if (pick != null && pick.day != now.day ||
                    pick.month != now.month ||
                    pick.year != now.year) {
                  String text = DateFormat('EEEE, dd-MM-yyyy').format(pick);
                  setState(() {
                    this.date = text;
                  });
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
