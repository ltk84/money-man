import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class WrapperBuilder extends StatelessWidget {
  final Widget Function(BuildContext, AsyncSnapshot<User>) builder;
  WrapperBuilder({this.builder});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuthService>(context, listen: false);

    // streambuilder để theo dõi trạng thái của user
    return StreamBuilder<User>(
        stream: auth.userStream,
        builder: (context, snapshot) {
          final user = snapshot.data;

          // trả về MultiProvider
          if (user != null) {
            return MultiProvider(providers: [
              // dịch vụ firestore
              Provider<FirebaseFireStoreService>(
                create: (BuildContext context) {
                  return FirebaseFireStoreService(uid: user.uid);
                },
              ),
            ], child: builder(context, snapshot));
          } else {
            return builder(context, snapshot);
          }
        });
  }
}
