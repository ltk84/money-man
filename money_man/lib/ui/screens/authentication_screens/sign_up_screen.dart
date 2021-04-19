import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:money_man/core/services/constaints.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';

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
    return loading == true
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Sign Up',
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
                            onPressed: () {
                              widget.changeShow();
                            },
                            elevation: 0,
                            child: Text(
                              'SIGN UP',
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
                          elevation: 0,
                          color: Colors.white,
                          onPressed: () {
                            // Thao tác đăng nhập
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          textColor: yellow,
                          shape: RoundedRectangleBorder(
                              //side: BorderSide(color: Colors.red, width: 0),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      Divider(
                        height: 5,
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
                          onPressed: () {},
                          elevation: 0,
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
                          elevation: 0,
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
                          elevation: 0,
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

  Future signUpWithEmailAndPassword(
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
    TextEditingController PasswordControler = TextEditingController();
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
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.black,
          ),
          child: TextFormField(
            controller: PasswordControler,
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
        ),
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.black,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Retype password not empty';
              else if (value != PasswordControler.text)
                return 'Password must longer than 6 digits';
              return null;
            },
            style: TextStyle(fontFamily: 'Montserrat'),
            onChanged: (value) => _password = value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.security),
              labelText: 'Confirm Password',
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
