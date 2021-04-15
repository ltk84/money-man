import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  final Function changeShow;
  SignUpScreen({
    this.changeShow,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool isObcure = true;
  bool show = true;
  Icon trailingIconPass = Icon(Icons.remove_red_eye);
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<FirebaseAuthService>(context);

    return loading == true
        ? LoadingScreen()
        : Scaffold(
            body: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      buildInputField(),
                      OutlinedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              signUpWithEmailAndPassword(_auth, context);
                            }
                          },
                          child: Text('SIGN UP')),
                      OutlinedButton(
                          onPressed: () {
                            widget.changeShow();
                          },
                          child: Text('LOGIN')),
                      OutlinedButton(
                          onPressed: () async {
                            signInAnonymously(_auth, context);
                          },
                          child: Text('LOGIN AS GUEST')),
                      Divider(
                        height: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: CustomListTile(
                          text: 'Connect to Facebook',
                          imgName: 'facebook',
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: CustomListTile(
                            text: "Connect to Google", imgName: 'google'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: CustomListTile(
                            text: 'Connect to Apple', imgName: 'apple'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Future signInAnonymously(
      FirebaseAuthService _auth, BuildContext context) async {
    final res = await _auth.signInAnonymously();

    if (res is String) {
      final error = res;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future signUpWithEmailAndPassword(
      FirebaseAuthService _auth, BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      final res = await _auth.signUpWithEmailAndPassword(_email, _password);
      if (res is String) {
        setState(() {
          loading = false;
        });

        String error = "";
        switch (res) {
          case 'email-already-in-use':
            error = "Email is already in use";
            break;
          case 'invalid-email':
            error = "email is invalid";
            break;
          case 'weak-password':
            error = "password is weak";
            break;
          default:
            error = res;
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }

  Widget buildInputField() {
    return Column(
      children: [
        TextFormField(
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
          textInputAction: TextInputAction.next,
          autocorrect: false,
        ),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Password not empty';
            else if (value.length < 6)
              return 'Password must longer than 6 digits';
            return null;
          },
          onChanged: (value) => _password = value,
          decoration: InputDecoration(
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: trailingIconPass,
              onPressed: () => this.setState(() {
                isObcure = !isObcure;
                show = !show;
                trailingIconPass = Icon(
                    show == true ? Icons.remove_red_eye : Icons.receipt_long);
              }),
            ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          obscureText: isObcure,
        ),
      ],
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String text;
  final String imgName;
  CustomListTile({
    Key key,
    @required this.text,
    @required this.imgName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image(
        image: AssetImage('assets/images/$imgName.jpg'),
        fit: BoxFit.contain,
      ),
      title: Text('$text'),
    );
  }
}
