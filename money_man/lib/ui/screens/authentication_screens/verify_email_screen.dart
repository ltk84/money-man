import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/ui/screens/account_screens/account_edit_information_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  // biến authentication
  final auth = FirebaseAuth.instance;
  // timer check verify email
  Timer timer;

  @override
  void initState() {
    super.initState();
    // mỗi 5s check verify email
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
    // biến user hiện tại
    final user = auth.currentUser;
    // controller cho nút
    final RoundedLoadingButtonController _btnController =
        new RoundedLoadingButtonController();
    // controller cho nút
    final RoundedLoadingButtonController _btnController2 =
        new RoundedLoadingButtonController();

    return Scaffold(
      backgroundColor: Color(0xff1a1a1a),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'To get access to ',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                        ),
                        Text(
                          'Money Man',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                        Text(
                          ', please',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w300,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(
                        'VERIFY YOUR EMAIL',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Please check your email!\nAfter verified, please wait for seconds',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SuperIcon(
                iconPath: "assets/images/email.svg",
                size: 120.0,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 50.0, top: 20.0),
                child: Column(
                  children: [
                    Container(
                      child: RoundedLoadingButton(
                        successColor: Color(0xff2FB49C),
                        borderRadius: 10.0,
                        height: 45,
                        width: 220,
                        color: Color(0xff2FB49C),
                        child: Text('Tap to verify email',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                              color: Colors.white,
                            )),
                        controller: _btnController,
                        onPressed: () async {
                          await user.sendEmailVerification();
                          _btnController.success();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: RoundedLoadingButton(
                        borderRadius: 10.0,
                        height: 45,
                        width: 220,
                        color: Colors.white,
                        child: Text('Back',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              fontSize: 16.0,
                              color: Color(0xff2FB49C),
                            )),
                        controller: _btnController2,
                        onPressed: () async {
                          await auth.signOut();
                        },
                      ),
                    ),
                  ],
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
          context,
          PageTransition(
            child: AccountInformationScreen(),
            type: PageTransitionType.scale,
            curve: Curves.elasticInOut,
          ));
    }
  }
}
