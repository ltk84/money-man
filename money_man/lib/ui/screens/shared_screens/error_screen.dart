import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                final _auth = FirebaseAuthService();
                _auth.signOut();
              })
        ],
      ),
      body: Text('error page'),
    );
  }
}
