import 'package:flutter/material.dart';

class NoteTransactionScreen extends StatefulWidget {
  @override
  _NoteTransactionScreenState createState() => _NoteTransactionScreenState();
}

class _NoteTransactionScreenState extends State<NoteTransactionScreen> {
  String noteContent = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
        actions: [
          TextButton(
              onPressed: () {
                _formKey.currentState.save();
                Navigator.pop(context, noteContent);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            onSaved: (String val) {
              noteContent = val;
            },
            style: TextStyle(color: Colors.black),
            maxLines: 100,
          ),
        ),
      ),
    );
  }
}
