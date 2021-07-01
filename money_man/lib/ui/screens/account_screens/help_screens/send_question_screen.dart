import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:money_man/ui/style.dart';
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
      ..recipients.add('namyenom.tiu@gmail.com')
      ..subject = 'This is a feedback mail with subject: $subject 😀 '
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>This is my feedback content</h1>\n<p>$content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      await _showAlertDialog(
          'Thank you for contact to us', 'Your message was sent successfully');
      Navigator.pop(context);
    } on MailerException catch (e) {
      await _showAlertDialog(
          'Sorry, something went wrong, please try again!', null);
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
      backgroundColor: Style.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: CloseButton(
          color: Style.foregroundColor,
        ),
        title: Text(
          'Contact us',
          style: TextStyle(
            color: Style.foregroundColor,
            fontFamily: Style.fontFamily,
            fontSize: 17.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Style.appBarColor,
        actions: [
          GestureDetector(
            onTap: () async {
              setState(() {
                isSending = true;
              });
              if (content == null || content == "") {
                _showAlertDialog('Please type your message!', null);
              } else {
                await sendMail();
              }
              setState(() {
                isSending = false;
              });
              print('ok');
            },
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Center(
                child: Icon(
                  Icons.send,
                  color: Style.foregroundColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: isSending
          ? Container(
              color: Style.backgroundColor1,
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Style.backgroundColor1,
                ),
              ),
            )
          : Container(
              color: Style.backgroundColor1,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ListView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                //physics: NeverScrollableScrollPhysics(),
                children: [
                  TextFormField(
                    onChanged: (val) {
                      subject = val;
                    },
                    style: TextStyle(
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                    cursorColor: Style.foregroundColor,
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Style.foregroundColor.withOpacity(0.54)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Style.foregroundColor,
                            width: 1.5,
                          ),
                        ),
                        hintText: "Subject",
                        hintStyle: TextStyle(
                            color: Style.foregroundColor.withOpacity(0.24),
                            fontFamily: Style.fontFamily,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500)),
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
                        color: Style.foregroundColor,
                        fontFamily: Style.fontFamily,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400),
                    cursorColor: Style.foregroundColor,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type your message",
                        hintStyle: TextStyle(
                            color: Style.foregroundColor.withOpacity(0.24),
                            fontFamily: Style.fontFamily,
                            fontSize: 18.0,
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
      barrierColor: Style.backgroundColor.withOpacity(0.54),
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
          );
      },
    );
  }
}
