import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';

class SendQuestionScreen extends StatefulWidget {
  const SendQuestionScreen({Key key}) : super(key: key);

  @override
  _SendQuestionScreenState createState() => _SendQuestionScreenState();
}

class _SendQuestionScreenState extends State<SendQuestionScreen> {
  bool isSending = false;
  String content;
  String subject;
  sendMail() async {
    String username = 'moneyman.feedback@gmail.com';
    String password = '19522252';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add('hienthe473@gmail.com')
      ..subject = 'This is a feedback mail with subject: $subject 😀 '
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>This is my feedback content</h1>\n<p>$content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      await _showAlertDialog(
          'Thank you for contact to us', 'Message sent successfully');
      Navigator.pop(context);
    } on MailerException catch (e) {
      await _showAlertDialog(
          'Sorry, there is some mistake, please try again!', null);
      Navigator.pop(context);
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Contact with us',
          style: TextStyle(fontFamily: 'Montserrat'),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff333333),
        actions: [
          GestureDetector(
            onTap: () async {
              setState(() {
                isSending = true;
              });
              if (content == null || content == "") {
                _showAlertDialog('Please type your message!', null);
              }
              await sendMail();
              setState(() {
                isSending = false;
              });
              print('ok');
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Icon(Icons.send),
              ),
            ),
          )
        ],
      ),
      body: isSending
          ? Container(
              color: Color(0xff1a1a1a),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              color: Color(0xff1a1a1a),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              child: ListView(
                children: [
                  TextFormField(
                    onChanged: (val) {
                      subject = val;
                    },
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400),
                    cursorColor: white,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.5),
                        ),
                        hintText: "Type Subject",
                        hintStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    onChanged: (val) {
                      content = val;
                    },
                    maxLines: 100,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400),
                    cursorColor: white,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message",
                        hintStyle: TextStyle(
                            color: Colors.white54,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400)),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> _showAlertDialog(String content, String title) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        if (title == null)
          return CustomAlert(
            content: content,
          );
        else
          return CustomAlert(
            content: content,
            title: title,
            iconPath: 'assets/images/success.svg',
            //iconPath: iconpath,
          );
      },
    );
  }
}
