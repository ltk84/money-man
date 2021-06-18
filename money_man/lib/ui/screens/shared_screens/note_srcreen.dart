import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class NoteScreen extends StatefulWidget {
  String content;
  NoteScreen({
    Key key,
    @required this.content,
  }) : super(key: key);
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  String noteContent = '';
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  @override
  void initState() {
    noteContent = widget.content;
    myController.text = noteContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.backgroundColor1,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myController.clear();
          // noteContent = '';
        },
        child: Icon(
            Icons.delete_forever_rounded,
          color: Style.foregroundColor
        ),
        elevation: 0,
        backgroundColor: Style.primaryColor,
      ),
      appBar: AppBar(
        leading: CloseButton(),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Style.boxBackgroundColor,
        title: Text('Note',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,)),
        actions: [
          TextButton(
              onPressed: () {
                _formKey.currentState.save();
                Navigator.pop(context, myController.text);
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600
                ),
              )),
        ],
      ),
      body: Container(
        color: Style.backgroundColor1,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Form(
          key: _formKey,
          child: TextFormField(
              // initialValue: noteContent,
              controller: myController,
              keyboardType: TextInputType.text,
              onSaved: (String val) {
                myController.text = val;
              },
              cursorColor: Color(0xFF2FB49C),
              style: TextStyle(
                  fontFamily: Style.fontFamily,
                  color: Style.foregroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
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
