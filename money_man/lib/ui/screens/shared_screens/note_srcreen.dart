import 'package:flutter/material.dart';

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
  // String noteContent = '';
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();
    myController.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myController.clear();
          // noteContent = '';
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
                Navigator.pop(context, myController.text);
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
              controller: myController,
              keyboardType: TextInputType.text,
              onSaved: (String val) {
                myController.text = val;
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
