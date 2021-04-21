import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';

class ForgotPasswordScreen extends StatelessWidget {
  String _email;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot password'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Email not empty';
                else if (EmailValidator.validate(value) == false)
                  return 'Email not valid';
                return null;
              },
              onChanged: (value) => _email = value,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autocorrect: false,
            ),
          ),
          OutlinedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  final _auth = FirebaseAuthService();
                  final res = await _auth.resetPassword(_email);
                  print(res.runtimeType);
                  if (res is String) {
                    print('inside if');
                    String error = "";
                    switch (res) {
                      case 'invalid-email':
                        error = 'Email is invalid';
                        break;
                      case 'user-not-found':
                        error = 'email not registered yet';
                        break;
                      default:
                    }
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)));
                  }
                }
              },
              child: Text('Send code to email'))
        ],
      ),
    );
  }
}
