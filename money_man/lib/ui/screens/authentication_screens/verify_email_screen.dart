import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
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
      backgroundColor: Colors.black12,
      body: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
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
            /*OutlinedButton(
                onPressed: () async {
                  await user.sendEmailVerification();
                },
                child: Text('Verify email!'))*/
            Container(
              child: RoundedLoadingButton(
                height: 40,
                width: 200,
                color: Colors.grey[350],
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
            )
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