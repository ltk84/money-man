import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/authentication_screens/forgot_password_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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
                      SizedBox(height: 30),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 65,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 10),
                      buildInputField(),
                      SizedBox(height: 15),
                      ButtonTheme(
                        minWidth: 300,
                        child: RaisedButton(
                            onPressed: () async {
                              await signInWithEmailAndPassword(_auth, context);
                            },
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            color: yellow,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                      ),
                      ButtonTheme(
                        minWidth: 300,
                        child: RaisedButton(
                          onPressed: () async {
                            await signInAnonymously(_auth, context);
                          },
                          child: Text('LOGIN AS GUEST'),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                widget.changeShow();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.blue,
                                  ),
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ForgotPasswordScreen()));
                                //Forgot Password
                              },
                              child: Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.blue,
                                ),
                              )),
                        ],
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          thickness: 2,
                          color: black,
                        )),
                        Text(
                          " OR ",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 2,
                          color: black,
                        )),
                      ]),
                      SizedBox(height: 20),
                      Container(
                        height: 40,
                        width: 300,
                        //padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: RaisedButton(
                          color: Color(0xffbcbcbc),
                          onPressed: () {
                          final _auth = FirebaseAuthService();
                          // _auth.signInWithFacebook();
                          _auth.signInWithFacebookVer2();
                          },
                          child: CustomListTile(
                            text: "Connect to Facebook",
                            imgName: "logoFB.png",
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        //padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        height: 40,
                        width: 300,
                        child: RaisedButton(
                          color: Color(0xffbcbcbc),
                          onPressed: () {},
                          child: CustomListTile(
                            text: "Connect to Google",
                            imgName: "logoGG.png",
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        //padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        height: 40,
                        width: 300,
                        child: RaisedButton(
                          color: Color(0xffbcbcbc),
                          onPressed: () {},
                          child: CustomListTile(
                            text: 'Connect to Apple',
                            imgName: 'LogoAP.png',
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
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
    FocusNode myFocusNode = new FocusNode();
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.black,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Email not empty';
              else if (EmailValidator.validate(value) == false)
                return 'Email not valid';
              return null;
            },
            textAlign: TextAlign.left,
            onChanged: (value) => _email = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              labelStyle: TextStyle(
                fontFamily: 'Montserrat',
              ),
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            cursorColor: black,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          validator: (value) {
            if (value == null || value.isEmpty)
              return 'Password not empty';
            else if (value.length < 6)
              return 'Password must longer than 6 digits';
            return null;
          },
          style: TextStyle(fontFamily: 'Montserrat'),
          onChanged: (value) => _password = value,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.security),
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
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(5),
          child: Image(
            image: AssetImage('assets/images/$imgName'),
            fit: BoxFit.fitHeight,
          ),
        ),
        Expanded(
            child: Text(
          '$text',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )),
      ]),
    );
  }
}
