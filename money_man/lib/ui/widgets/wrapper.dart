import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/ui/screens/account_screens/account_edit_information_screen.dart';
import 'package:money_man/ui/screens/authentication_screens/verify_email_screen.dart';
import 'package:money_man/ui/screens/home_screen/home_screen.dart';
import 'package:money_man/ui/screens/introduction_screens/introduction_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';

class Wrapper extends StatelessWidget {
  // biến lấy thông tin user từ wrapper_builder
  final AsyncSnapshot<User> userSnapshot;
  const Wrapper({
    Key key,
    @required this.userSnapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // thông tin đã được lấy về
    if (userSnapshot.connectionState == ConnectionState.active) {
      if (userSnapshot.hasData) {
        // user đã có đầy đủ thông tin
        if (userSnapshot.data.displayName != null &&
            userSnapshot.data.displayName != '')
          return HomeScreen();
        // user có email chưa được verify
        else if (!userSnapshot.data.emailVerified)
          return VerifyEmailScreen();
        // user thiếu thông tin
        else
          return AccountInformationScreen();
      }
      // chưa có thông tin
      else
        return IntroductionScreen();
    }
    // thông tin đang được lấy về
    return LoadingScreen();
  }
}
