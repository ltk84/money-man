import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NoteTransactionScreen extends StatefulWidget {
  final String noteContent;

  const NoteTransactionScreen({Key key, this.noteContent}) : super(key: key);
  @override
  _NoteTransactionScreenState createState() => _NoteTransactionScreenState();
}

class _NoteTransactionScreenState extends State<NoteTransactionScreen> {
  String noteContent ;
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  @override
  void initState() {
    noteContent = widget.noteContent;
    myController.text = noteContent ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myController.clear();
          noteContent = null;
        },
        child: Icon(Icons.delete_forever_rounded),
        elevation: 0,
        backgroundColor: Color(0xFF2FB49C),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff333333),
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
              )),
        ],
      ),
      body: Container(
        color: Color(0xff111111),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Form(
          key: _formKey,
          child: TextFormField(
           // initialValue: noteContent,
             controller: myController,
              keyboardType: TextInputType.text,
              onSaved: (String val) {
                noteContent = val;
              },
              cursorColor: Color(0xFF2FB49C),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300),
              maxLines: 100,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              )),
        ),
      ),
    );
  }
}
