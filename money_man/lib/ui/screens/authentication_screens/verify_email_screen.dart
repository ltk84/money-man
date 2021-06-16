import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/ui/screens/account_screens/account_edit_information_screen.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class VerifyEmailScreen extends StatefulWidget {
  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final auth = FirebaseAuth.instance;

  Timer timer;
  Timer timer2;

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
    timer2.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    final RoundedLoadingButtonController _btnController =
        new RoundedLoadingButtonController();
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
                              color: white,
                            )),
                        controller: _btnController,
                        onPressed: () async {
                          if (user.email.contains('gmail') == false) {
                            await user.sendEmailVerification();
                          } else {
                            final res = await _handleLinkWithGoogle(user.email);
                            if (res == null) {
                              await _showAlertDialog(
                                  'There is something wrong!');
                              await user.delete();
                            }
                          }
                          timer2 =
                              Timer.periodic(Duration(seconds: 3), (timer) {});

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

  Future _handleLinkWithGoogle(String _email) async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      if (_email.contains('gmail')) {
        // print('link');
        if (_email != googleUser.email) {
          await GoogleSignIn().signOut();
          await _showAlertDialog(
              'The google account and the email is different! Please sign up again!');
          await auth.currentUser.delete();

          // Navigator.pop(context);
        } else {
          try {
            UserCredential res =
                await auth.currentUser.linkWithCredential(credential);
            return res;
          } on FirebaseAuthException catch (e) {
            // TODO
            print(e.code);
            return null;
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      _showAlertDialog(error);
    }
  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }
}
