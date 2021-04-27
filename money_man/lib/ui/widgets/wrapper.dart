import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/models/walletModel.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/ui/screens/authentication_screens/authentication.dart';
import 'package:money_man/ui/screens/authentication_screens/verify_email_screen.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:provider/provider.dart';

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
        if (userSnapshot.data.emailVerified || userSnapshot.data.isAnonymous)
          return HomeScreen();
        else
          return VerifyEmailScreen();
      } else
        return Authentication();
    }
    return LoadingScreen();

    //return HomeScreen();
  }
}
