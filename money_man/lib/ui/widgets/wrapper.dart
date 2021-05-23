import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/account_screens/account_edit_information_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      if (userSnapshot.hasData) {
        if (userSnapshot.data.isAnonymous || (userSnapshot.data.displayName != null &&
            userSnapshot.data.displayName != ''))
          return HomeScreen();
        else if(!userSnapshot.data.emailVerified )
          return VerifyEmailScreen();
        else
          return AccountInformationScreen();
      } else
          return IntroductionScreen();
    }
    return LoadingScreen();
    // return FirstStep();
  }
}
