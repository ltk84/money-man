import 'package:flutter/material.dart';
import 'package:money_man/ui/style.dart';

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
  // biến note
  String noteContent = '';
  // biến key để validate note
  final formKey = GlobalKey<FormState>();
  // biến để control text note
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
        },
        child: Icon(
          Icons.delete_forever_rounded,
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Style.primaryColor,
      ),
      appBar: AppBar(
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Style.boxBackgroundColor,
        title: Text('Note',
            style: TextStyle(
              fontFamily: Style.fontFamily,
              fontSize: 17.0,
              fontWeight: FontWeight.w600,
              color: Style.foregroundColor,
            )),
        actions: [
          TextButton(
              onPressed: () {
                formKey.currentState.save();
                Navigator.pop(context, myController.text);
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color: Style.foregroundColor,
                    fontFamily: Style.fontFamily,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600),
              )),
        ],
      ),
      body: Container(
        color: Style.backgroundColor1,
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: Form(
          key: formKey,
          child: TextFormField(
              maxLength: 50,
              controller: myController,
              autofocus: true,
              keyboardType: TextInputType.text,
              onSaved: (String val) {
                myController.text = val;
              },
              cursorColor: Style.primaryColor,
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
                counterStyle: TextStyle(
                    fontFamily: Style.fontFamily,
                    color: Style.foregroundColor.withOpacity(0.54),
                    fontSize: 12),
              )),
        ),
      ),
    );
  }
}
