import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/authentication_screens/forgot_password_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignInScreen extends StatefulWidget {
  final Function changeShow;
  SignInScreen({
    this.changeShow,
  });

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            // appBar: AppBar(
            //   title: Text('dang nhap'),
            // ),
            body: ListView(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                      buildInputField(),
                      OutlinedButton(
                          onPressed: () async {
                            await signInWithEmailAndPassword(_auth, context);
                          },
                          child: Text('LOGIN')),
                      OutlinedButton(
                          onPressed: () {
                            widget.changeShow();
                          },
                          child: Text('SIGN UP')),
                      OutlinedButton(
                          onPressed: () async {
                            await signInAnonymously(_auth, context);
                          },
                          child: Text('LOGIN AS GUEST')),
                      Divider(
                        thickness: 4.0,
                        height: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          final _auth = FirebaseAuthService();
                          // _auth.signInWithFacebook();
                          _auth.signInWithFacebookVer2();
                        },
                        child: CustomListTile(
                          text: "Connect to Facebook",
                          imgName: "facebook",
                        ),
                      ),
                      OutlinedButton(
                          onPressed: () {},
                          child: CustomListTile(
                            text: "Connect to Google",
                            imgName: "google",
                          )),
                      OutlinedButton(
                          onPressed: () {},
                          child: CustomListTile(
                            text: 'Connect to Apple',
                            imgName: 'apple',
                          )),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ForgotPasswordScreen()));
                        },
                        child: Text('Forgot password'),
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

  Future signInWithEmailAndPassword(
      FirebaseAuthService _auth, BuildContext context) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      final res = await _auth.signInWithEmailAndPassword(_email, _password);
      if (res is String) {
        setState(() {
          loading = false;
        });
        String error = "";
        switch (res) {
          case 'invalid-email':
            error = "Email is invalid";
            break;
          case 'wrong-password':
            error = "Password is wrong";
            break;
          case 'user-disable':
            error = "user is disable";
            break;
          case 'user-not-found':
            error = "user not found";
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
