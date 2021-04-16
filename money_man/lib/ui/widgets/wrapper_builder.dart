import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:money_man/core/services/firebase_storage_services.dart';
import 'package:provider/provider.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;
  WrapperBuilder({this.builder});

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<FirebaseAuthService>(context, listen: false);

    return StreamBuilder<User>(
        stream: _auth.userStream,
        builder: (context, snapshot) {
          final user = _auth.currentUser;

          if (user != null) {
            return MultiProvider(providers: [
              Provider<User>.value(value: user),
              // Provider<FirebaseFireStoreService>(
              //   create: (BuildContext context) {
              //     return FirebaseFireStoreService(uid: user.uid);
              //   },
              // ),
              // Provider<FirebaseStorageService>(create: (BuildContext context) {
              //   return FirebaseStorageService(uid: user.uid);
              // })
            ], child: builder(context, snapshot));
          } else {
            return builder(context, snapshot);
          }
        });
  }
}
