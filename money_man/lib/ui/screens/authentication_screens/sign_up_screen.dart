import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_man/core/models/super_icon_model.dart';
import 'package:money_man/core/services/firebase_authentication_services.dart';
import 'package:money_man/ui/screens/authentication_screens/verify_email_screen.dart';
import 'package:money_man/ui/screens/shared_screens/loading_screen.dart';
import 'package:money_man/ui/widgets/custom_alert.dart';

class SignUpScreen extends StatefulWidget {
  final Function changeShow;
  SignUpScreen({
    this.changeShow,
  });

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuthService();
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool isObcure = true;
  bool isObcureSub = true;
  bool show = true;
  bool showSub = true;
  Icon trailingIconPass = Icon(Icons.remove_red_eye, color: Color(0x70999999));
  Icon trailingIconPassSub =
      Icon(Icons.remove_red_eye, color: Color(0x70999999));
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: CloseButton(),
              backgroundColor: Colors.grey[900],
            ),
            backgroundColor: Colors.grey[900],
            body: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontFamily: 'Montserrat'),
                      ),
                      SizedBox(height: 10),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: buildInputField(),
                      ),
                      SizedBox(height: 20),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 80.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF2FB49C); // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF2FB49C);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () async {
                            await _signUpWithEmailAndPassword(_auth, context);
                          },
                          child: Text("SIGN UP",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  wordSpacing: 2.0),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 80.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF2FB49C);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF2FB49C); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            // Thao tác đăng nhập
                            widget.changeShow();
                          },
                          child: Text("LOGIN",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  wordSpacing: 2.0),
                              textAlign: TextAlign.center),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(children: <Widget>[
                          Expanded(
                              child: Divider(
                            thickness: 1,
                            color: Colors.white24,
                          )),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              " OR ",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                            thickness: 1,
                            color: Colors.white24,
                          )),
                        ]),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF2c84d4);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF2c84d4); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            _signInWithFacebookAccount();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SuperIcon(
                                  iconPath: 'assets/images/facebook.svg',
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 10,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  "Connect with Facebook",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      wordSpacing: 2.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFFfc4232);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFFfc4232); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            _signInWithGoogleAccount();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SuperIcon(
                                  iconPath: 'assets/images/google.svg',
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 10,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  "Connect with Google",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      wordSpacing: 2.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 60.0),
                        width: double.infinity,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xFF0c0c0c);
                                return Colors
                                    .white; // Use the component's default.
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.white;
                                return Color(
                                    0xFF0c0c0c); // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: () {
                            //_auth.signInWithGoogleAccount();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SuperIcon(
                                  iconPath: 'assets/images/apple.svg',
                                  size: 18,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SizedBox(
                                  width: 10,
                                ),
                              ),
                              Expanded(
                                flex: 8,
                                child: Text(
                                  "Connect with Apple",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      wordSpacing: 2.0),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  // Future _signInAnonymously(
  //     FirebaseAuthService _auth, BuildContext context) async {
  //   final res = await _auth.signInAnonymously();

  //   if (res is String) {
  //     final error = res;
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text(error)));
  //   }
  // }

  Future _signInWithFacebookAccount() async {
    try {
      _auth.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      _showAlertDialog(error);
    }
  }

  Future _signInWithGoogleAccount() async {
    try {
      _auth.signInWithGoogleAccount();
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'account-exists-with-different-credential':
          error =
              "This account is linked with another provider! Try another provider!";
          break;
        case 'email-already-in-use':
          error = "Your email address has been registered.";
          break;
        case 'invalid-credential':
          error = "Your credential is malformed or has expired.";
          break;
        case 'user-disabled':
          error = "This user has been disable.";
          break;
        default:
          error = e.code;
      }
      _showAlertDialog(error);
    } on PlatformException catch (e) {}
  }

  Future _signUpWithEmailAndPassword(
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
          case 'invalid-email':
            error = "This email is invalid.";
            break;
          case 'email-already-in-use':
            error = "Your email address has been registered.";
            break;
          case 'weak-password':
            error = "Your password is so weak! Be stronger bro!";
            break;
          default:
            error = res;
        }
        _showAlertDialog(error);
      }
    }
  }

  Future<void> _showAlertDialog(String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return CustomAlert(content: content);
      },
    );
  }

  Widget buildInputField() {
    // TextEditingController PasswordControler = TextEditingController();
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.white,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Email is empty';
              else if (EmailValidator.validate(value) == false)
                return 'Email is not valid';
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            onChanged: (value) => _email = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white12,
                ),
              ),
              prefixIcon: Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.email, color: Colors.white, size: 25.0)),
              hintText: 'Email',
              hintStyle: TextStyle(
                color: Color(0x70999999),
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            cursorColor: Color(0xFF2FB49C),
          ),
        ),
        SizedBox(height: 5),
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.white,
          ),
          child: TextFormField(
            // controller: PasswordControler,
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Password is empty';
              else if (value.length < 6)
                return 'Password must longer than 6 digits';
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            onChanged: (value) => _password = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white12,
                ),
              ),
              prefixIcon: Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.vpn_key, color: Colors.white, size: 25.0)),
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Color(0x70999999),
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: IconButton(
                icon: trailingIconPass,
                onPressed: () => this.setState(() {
                  isObcure = !isObcure;
                  show = !show;
                  trailingIconPass = Icon(
                    show == true
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: Color(0x70999999),
                  );
                }),
              ),
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            obscureText: isObcure,
            cursorColor: Color(0xFF2FB49C),
          ),
        ),
        SizedBox(height: 5),
        Theme(
          data: Theme.of(context).copyWith(
            // override textfield's icon color when selected
            primaryColor: Colors.white,
          ),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Re-password is empty';
              else if (value.length < 6)
                return 'Re-password must longer than 6 digits';
              return null;
            },
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            // onChanged: (value) => _password = value,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white12,
                ),
              ),
              prefixIcon: Container(
                  margin: EdgeInsets.only(bottom: 5.0, right: 8.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(Icons.vpn_key, color: Colors.white, size: 25.0)),
              hintText: 'Confirm Password',
              hintStyle: TextStyle(
                color: Color(0x70999999),
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              suffixIcon: IconButton(
                icon: trailingIconPassSub,
                onPressed: () => this.setState(() {
                  isObcureSub = !isObcureSub;
                  showSub = !showSub;
                  trailingIconPassSub = Icon(
                    showSub == true
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: Color(0x70999999),
                  );
                }),
              ),
              fillColor: Colors.white,
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            autocorrect: false,
            obscureText: isObcureSub,
            cursorColor: Color(0xFF2FB49C),
          ),
        ),
      ],
    );
  }
}
