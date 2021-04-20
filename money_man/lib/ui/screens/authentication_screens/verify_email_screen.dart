import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Verify email screen'),
      ),
      body: Column(
        children: [
          OutlinedButton(
              onPressed: () async {
                await user.sendEmailVerification();
              },
              child: Text('Verify email!'))
        ],
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
