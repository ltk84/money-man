import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final auth = FirebaseAuth.instance;

  Timer timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkIfEmailVerified();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    final RoundedLoadingButtonController _btnController =
        new RoundedLoadingButtonController();
    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 90, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Text(
                      'Verify your email',
                      style: TextStyle(
                          color: yellow,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 35),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Text(
                      'to keep using',
                      style: TextStyle(
                          color: yellow,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Text(
                      'Money Man',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: 45),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logoEmail.png'),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: RoundedLoadingButton(
                height: 40,
                width: 200,
                color: Color(0xff007b10),
                child: Text('Verify email!',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: black)),
                controller: _btnController,
                onPressed: () async {
                  await user.sendEmailVerification();
                  _btnController.success();
                },
              ),
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
                child: Text(
                  ' Click the button then check your mailbox to get your verify email link! \n ',
                  style: TextStyle(
                    color: white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future checkIfEmailVerified() async {
    var user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => FirstStep()));
    }
  }
}
