import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/authentication_screens/verify_email_screen.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
import 'package:money_man/ui/screens/introduction_screens/first_step.dart';
import 'package:money_man/ui/screens/introduction_screens/introduction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';

class Wrapper extends StatelessWidget {
  final AsyncSnapshot<User> userSnapshot;
  const Wrapper({
    Key key,
    @required this.userSnapshot,
  }) : super(key: key);

  Future<bool> checkIfExistInFirestore(AsyncSnapshot<User> userSnapshot) async {
    bool res;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userSnapshot.data.uid)
        .get()
        .then((value) {
      res = value.exists;
    });
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      if (userSnapshot.hasData) {
        if (userSnapshot.data.emailVerified &&
                checkIfExistInFirestore(userSnapshot) ==
                    Future<bool>.value(true) ||
            userSnapshot.data.isAnonymous)
          return HomeScreen();
        else if (!userSnapshot.data.emailVerified)
          return VerifyEmailScreen();
        else
          return FirstStep();
      } else
        return IntroductionScreen();
    }
    return LoadingScreen();

    // return FirstStep();
  }
}
