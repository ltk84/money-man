import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuthService();
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
          OutlinedButton(onPressed: () {}, child: Text('add wallet')),
        ],
      ),
    );
  }
}
