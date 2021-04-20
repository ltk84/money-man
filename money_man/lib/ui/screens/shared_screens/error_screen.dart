import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/core/services/firebase_firestore_services.dart';
import 'package:provider/provider.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuthService();
    final _firestore = FirebaseFireStoreService(uid: _auth.currentUser.uid);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
              })
        ],
      ),
      body: Column(
        children: [
          Text('error page'),
          OutlinedButton(
              onPressed: () {
                _firestore.addWallet();
              },
              child: Text('add wallet')),
        ],
      ),
    );
  }
}
